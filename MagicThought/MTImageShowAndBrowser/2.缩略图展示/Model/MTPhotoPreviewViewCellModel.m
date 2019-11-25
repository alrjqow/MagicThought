//
//  MTPhotoPreviewViewCellModel.m
//  DaYiProject
//
//  Created by monda on 2018/8/24.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTPhotoPreviewViewCellModel.h"
#import "MTPhotoPreviewViewModel.h"
#import "MTPhotoBrowserViewModel.h"
#import "MTPhotoLook.h"

#import "SDWebImageManager.h"
#import "MBProgressHUD.h"


#import "UIView+Frame.h"
#import "MTConst.h"
#import "UIDevice+DeviceInfo.h"
#import "MTPhotoManager.h"
#import "MTNavigationController.h"


@interface MTPhotoPreviewViewCellModel()<UIActionSheetDelegate>

@property (nonatomic,weak) UIView* zoomView;

@property (nonatomic,assign) CGPoint zoomViewStartPosition;
@property (nonatomic,assign) CGPoint zoomViewStartAnchorPoint;
@property (nonatomic,assign) CGFloat startZoomScale;

//用于控制边界迅速滑动时阻断拖拽效果
/**是否可执行拖拽缩放*/
@property (nonatomic,assign) BOOL isPanPass;

/**是否开启isPass判断，只有当高度小于view的高度时，才会开启开启了isPassr永远为yes*/
@property (nonatomic,assign) BOOL isOpenIsPanPass;

/**是否可以dismiss*/
@property (nonatomic,assign) BOOL isOKDismiss;

/**是否用户拖拽导致的减速完成*/
@property (nonatomic,assign) BOOL isLookEndDecelerateByTracking;



//用于控制在不符合条件时仍能保持拖拽手势的进行
/**是否开始手势*/
@property (nonatomic,assign) BOOL isPanStart;

/**手势是否进行中*/
@property (nonatomic,assign) BOOL isPanDoing;

/**手势是否向下滑*/
@property (nonatomic,assign) BOOL isPanSlideDown;



@end

@implementation MTPhotoPreviewViewCellModel


#pragma mark - 重置尺寸
-(void)resizeViewForZooming:(UIView*)view
{
    self.zoomView = view;
    
    CGFloat contentHeight = self.imageLookSize.height * self.look.zoomScale;
    self.look.bounces = contentHeight > self.look.height;
    contentHeight = contentHeight > self.look.height ? contentHeight : (self.look.height + 1);
    self.look.contentSize = CGSizeMake(self.look.width * self.look.zoomScale, contentHeight);
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    CGFloat xcenter = self.look.contentSize.width > self.look.width ? self.look.contentSize.width / 2 : self.look.centerX;
    CGFloat ycenter = self.look.contentSize.height > self.look.height ? self.look.contentSize.height / 2 : self.look.centerY;
    view.center = CGPointMake(xcenter, ycenter);
    
    self.zoomViewStartPosition = view.layer.position;
    self.zoomViewStartAnchorPoint = view.layer.anchorPoint;
    self.startZoomScale = self.look.zoomScale < self.look.minimumZoomScale ? self.look.minimumZoomScale : self.look.zoomScale;
    
    self.isOpenIsPanPass = contentHeight <= (self.look.height + 1);
    self.isPanPass = false;
}

-(void)resetLook
{
    if(self.browserModel.rootViewController.navigationBar.tag != 0)
    {
        [self.browserModel.rootViewController performSelector:@selector(addStatusBarToDefault:) withObject:@(false)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:false];
    }
    [UIView animateWithDuration:self.animateTime animations:^{
        if(self.browserModel.changeAlpha)
            self.browserModel.changeAlpha(1);
        
        self.zoomView.layer.anchorPoint = self.zoomViewStartAnchorPoint;
        self.zoomView.layer.position = self.zoomViewStartPosition;
        self.zoomView.transform = CGAffineTransformMakeScale(self.startZoomScale, self.startZoomScale);
    } completion:^(BOOL finished) {
        self.isPanDoing = false;
    }];
}

#pragma mark - 拖拽效果

- (void)didPan:(UIPanGestureRecognizer *)pan
{
    if(self.isOpenIsPanPass)
        self.isPanPass = YES;
    
    if(!self.isPanPass)
    {
        self.isOKDismiss = false;
        return;
    }
    
    if(!self.isPanDoing && self.look.contentOffset.y > 0)
    {
        self.isPanPass = false;
        self.isOKDismiss = false;
        return;
    }
    
    
    self.isOKDismiss = YES;
    self.isPanDoing = YES;
    static CGPoint startPoint;
    static CGPoint prePoint;
    static CGPoint anchorPoint;
    static CGFloat startHeight;
    static CGPoint startTouchOffset;
    
    CGPoint location = [pan locationInView:self.look];
    startTouchOffset = [pan translationInView:self.look]; //屏幕偏移量
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            break;
        }
            
            
        case UIGestureRecognizerStateChanged:
        {
            if(!self.isPanStart)
            {
                self.look.pinchGestureRecognizer.enabled = false;
                startPoint = location;
                prePoint = location;
                
                self.look.tag = 0;
                
                CGPoint locationInImage = [pan locationInView:self.zoomView];
                anchorPoint = CGPointMake(locationInImage.x * self.startZoomScale / self.zoomView.width, locationInImage.y * self.startZoomScale / self.zoomView.height);
                
                startHeight = (self.look.height - kTabBarHeight_mt()) - self.zoomView.y;
                self.isPanStart = YES;
            }
            
            self.isPanSlideDown = location.y - prePoint.y > 0;
            //            NSLog(@"方向 : %@", (location.y - prePoint.y < 0) ? @"向上滑" : (location.y - prePoint.y > 0 ? @"向下滑" : @"等待"));
            
            prePoint = location;
            if (location.y - startPoint.y <= 0 && self.look.tag == 0)
            {
                //                NSLog(@"不行");
                return;
            }
            
            if(self.look.tag == 0 && self.browserModel.rootViewController.navigationBar.tag != 0)
                [self.browserModel.rootViewController performSelector:@selector(addStatusBarToDefault:) withObject:@(YES)];
                        
            if(self.look.tag == 0)
                self.zoomView.layer.anchorPoint = anchorPoint;
            self.zoomView.layer.position = [pan locationInView:self.look];
            
            double percent = 1 - fabs(startTouchOffset.y) / (self.look.height); // 移动距离 / 整个屏幕
            double scalePercent = self.startZoomScale * (location.y - startPoint.y < 0 ? 1 : MAX(percent, 0.35));
            CGAffineTransform scale = CGAffineTransformMakeScale(scalePercent, scalePercent);
            self.zoomView.transform = scale;
            
            if(self.browserModel.changeAlpha)
            {
                CGFloat currentHeight = (self.look.height - kTabBarHeight_mt()) - self.zoomView.y;
                self.browserModel.changeAlpha(currentHeight > startHeight ? 1 : (currentHeight / startHeight));
            }
            
            self.look.tag = 1;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            //            NSLog(@"手势结束");
            break;
        }
            
        default:
            break;
            
    }
}

-(void)lookDidEndDraggingWithDecelerate:(BOOL)decelerate
{
    if(!self.isPanDoing && self.look.contentOffset.y > 0)
        return;
    
    self.isPanDoing = false;
    self.isPanStart = false;
    self.look.pinchGestureRecognizer.enabled = YES;
    
    if(self.isLookEndDecelerateByTracking)
        return;
    
    
    if(decelerate && self.isPanSlideDown)
    {
        if(self.isOKDismiss)
            [self dismiss];
    }
    else
    {
        if(!decelerate)
            [self resetPanPass];
        [self resetLook];
    }
    
    
    //    NSLog(@"scrollViewDidEndDragging_____%@" , isSlideDown ? @"dismiss" : @"resetLook");
}

-(void)lookDidEndDecelerating
{
    //    NSLog(scrollView.isTracking ? @"有人在抓我" : @"我是自然减速");
    self.isLookEndDecelerateByTracking = self.look.isTracking;
    
    //如果是自然减速
    if(!self.look.isTracking)
        [self resetPanPass];
    else
        self.isPanPass = false;
}

-(void)resetPanPass
{
    if(self.look.contentOffset.y == 0)
        self.isPanPass = !self.isPanPass;
    else
        self.isPanPass = false;
}

- (void)didPinch:(UIPinchGestureRecognizer *)pinch
{
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.look.panGestureRecognizer.enabled = false;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.look.panGestureRecognizer.enabled = YES;
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 存图
-(void)savePhoto
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"保存图片", nil];
    [sheet showInView:mt_Window()];
}


#pragma mark - 缩放

-(void)zoomWithPoint:(CGPoint)point
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if(self.look.zoomScale == self.look.minimumZoomScale)
            [self.look zoomToRect:[self zoomRectWithPoint:point] animated:false];
        else
            self.look.zoomScale = self.look.minimumZoomScale;
    }];
}

- (CGRect)zoomRectWithPoint:(CGPoint)point
{
    CGRect zoomRect;
    
    zoomRect.size.height =self.look.height / self.look.maximumZoomScale;
    zoomRect.size.width  =self.look.width / self.look.maximumZoomScale;
    zoomRect.origin.x = point.x - zoomRect.size.width * 0.5;
    zoomRect.origin.y = point.y - zoomRect.size.height * 0.5;
    return zoomRect;
}


#pragma mark - 显示
-(void)startAnimate
{
    if(self.changToOriginPosition)
        self.changToOriginPosition([self.browserModel getCurrentPosition]);
    
    [UIView animateWithDuration:self.isPopDismiss && !self.browserModel.isModal ? 0 : self.animateTime animations:^{
        
        self.look.model = self;
        if(self.browserModel.changeAlpha)
            self.browserModel.changeAlpha(1);
    }];
}

#pragma mark - 单击消失
-(void)tapPhotoDismiss
{
    if(self.isPopDismiss)
    {
        [self.browserModel refreshNavigationBarStatus];
        return;
    }
    
    [self dismiss];
}

-(void)dismiss
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:self.animateTime animations:^{
        
        weakSelf.look.zoomScale = weakSelf.look.minimumZoomScale;
        if(self.changToOriginPosition)
            self.changToOriginPosition([weakSelf.browserModel getCurrentPosition]);
        
        if(weakSelf.browserModel.changeAlpha)
            weakSelf.browserModel.changeAlpha(0);
    } completion:^(BOOL finished) {
        
        [weakSelf.browserModel resign];
    }];
}

#pragma mark - 获取图片
-(void)getImage:(void (^)(UIImage*))completion
{
    switch (self.loadType) {
        case MTImageLoadTypeImage:
        {
            [self.previewViewModel updateDownloadProgress];
            completion(self.image);
            return ;
        }
            
            
        case MTImageLoadTypeImageName:
        {
            [self.previewViewModel updateDownloadProgress];
            completion(self.image = [UIImage imageNamed:self.imageString]);
            return;
        }
            
            
        case MTImageLoadTypeImageURL:
        {
            __weak __typeof(self) weakSelf = self;
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.imageString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                [weakSelf.previewViewModel updateDownloadProgress];
                completion(weakSelf.image = image);
            }];
            return;
        }
            
        default:
            break;
    }
}

#pragma mark - ActionSheet代理

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            __weak typeof (self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSLog(@"%@",[NSThread currentThread]);
                [MTPhotoManager saveImage:weakSelf.image To:mt_AppName() completion:^(NSInteger tag, NSString* localIdentifier) {
                    // 回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"2-------%@",[NSThread currentThread]);
                        
                        
                        MBProgressHUD* view = [MBProgressHUD showHUDAddedTo:mt_Window() animated:YES];
                        view.label.text = tag != -1 ? @"保存成功" : @"图片未保存至系统相册!" ;
                        view.bezelView.color = [UIColor blackColor];
                        view.contentColor = [UIColor whiteColor];
                        view.mode = MBProgressHUDModeText;
                        view.offset = CGPointMake(0, 200);
                        [view hideAnimated:YES afterDelay:1];
                    });
                    
                    
                }];
            });
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 懒加载





-(void)setLook:(MTPhotoLook *)look
{
    _look = look;
    
    [look.panGestureRecognizer removeTarget:[self.look valueForKey:@"preModel"] action:@selector(didPan:)];
    [look.panGestureRecognizer addTarget:self action:@selector(didPan:)];
    look.panGestureRecognizer.maximumNumberOfTouches = 1;
    
    [look.pinchGestureRecognizer addTarget:self action:@selector(didPinch:)];
    
    if(!self.image)
        _imageLookSize = CGSizeZero;
    else
    {
        CGFloat ratio = self.image.size.height / self.image.size.width;
        CGFloat bigW = look.width;
        CGFloat bigH = bigW*ratio;
        
        _imageLookSize = CGSizeMake(bigW, bigH);
    }
    
    _isImageOverLookHeight = _imageLookSize.height > look.height;
}




#pragma mark - 初始化

-(instancetype)init
{
    if(self = [super init])
    {
        self.isPopDismiss = YES;
        self.animateTime = 0.25;
    }
    
    return self;
}

-(void)dealloc
{
    self.changToOriginPosition = nil;
}

@end
