//
//  MTPhotoBrowserViewModel.m
//  DaYiProject
//
//  Created by monda on 2018/8/28.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTPhotoBrowserViewModel.h"
#import "MTPhotoPreviewViewModel.h"
#import "MTPhotoBrowser.h"
#import "MTPhotoPreviewView.h"
#import "MTPhotoPreviewViewCell.h"
#import "MTPhotoBrowserController.h"
#import "MTNavigationPhotoBrowserController.h"

#import "MTAlertView.h"
#import "MTConst.h"
#import "MTWordStyle.h"
#import "UIButton+Word.h"
#import "NSArray+Alert.h"

@interface MTPhotoBrowserViewModel ()
{
    MTNavigationPhotoBrowserController* _rootViewController;
}
@property(nonatomic,strong) NSMutableArray* positionArr;

@property(strong,nonatomic)UIWindow *previewWindow;

/**是否已展示动画*/
@property (nonatomic,assign) BOOL isShowAnimate;

/**点击删除按钮*/
@property(nonatomic,assign) BOOL deleteBtnClick;

@property (nonatomic,weak) UICollectionView* previewView;

@property (nonatomic,weak) MTPhotoBrowserController* browserController;

@end

@implementation MTPhotoBrowserViewModel



#pragma mark - 生成位置

-(CGRect)getCurrentPosition
{
    if(self.currentIndex > self.positionArr.count - 1)
        return CGRectZero;
    
    if(![self isNotHaveCurrentPosition])
        return [self.positionArr[self.currentIndex] CGRectValue];
    
    if(self.previewView)
    {
        [self.positionArr removeAllObjects];
        [self createCollectionViewPositionArrWithView:self.previewView];
        return [self getCurrentPosition];
    }
    
    return CGRectZero;
}

-(BOOL)isNotHaveCurrentPosition
{
    NSInteger min = self.positionArr.count < 2 ? 0 : [self.positionArr[self.positionArr.count - 2] integerValue];
    NSInteger max = self.positionArr.count < 1 ? 0 : [self.positionArr.lastObject integerValue];
    BOOL canScroll = self.currentIndex > max || self.currentIndex < min;
    
    return canScroll;
}

-(void)showWithPreviewViews:(NSArray<UIView*>*)previewViews startIndex:(NSInteger)index
{
    if(!self.mt_delegate)
        return;
    
    [self.positionArr removeAllObjects];
    for(NSInteger i = 0; i < previewViews.count; i++)
    {
        self.positionArr[i] = [NSValue valueWithCGRect:[[UIApplication sharedApplication].keyWindow convertRect:previewViews[i].frame fromView:previewViews[i].superview]];
    }
    
    self.positionArr[self.positionArr.count] = @(0);
    self.positionArr[self.positionArr.count] = @(previewViews.count - 1);
    self.currentIndex = index;
    [self showWindow];
}

-(void)showWithPreviewView:(UIView<MTDelegateProtocol>*)previewView
{
    if([previewView isKindOfClass:[UICollectionView class]])
    {
        [self createCollectionViewPositionArrWithView:(UICollectionView*)previewView];
        [self showWindow];
        return;
    }
    
    [self showWithPreviewViews:@[previewView] startIndex:0];
}


-(NSArray*)createCollectionViewPositionArrWithView:(UICollectionView*)previewView
{
    self.previewView = previewView;
    NSMutableArray<NSIndexPath*>* arr = [NSMutableArray arrayWithArray:[previewView indexPathsForVisibleItems]];
    NSInteger count = arr.count;
    for(int i = 0; i < count - 1; i++)
    {
        for(int j = i+1; j < count;j++)
        {
            if(arr[i].row <= arr[j].row) continue;
            
            NSIndexPath* temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
    
    while (self.positionArr.count < self.cellModelArr.count) {
        self.positionArr[self.positionArr.count] = @0;
    }
    
    NSInteger offset = 0;
    if([previewView isKindOfClass:[MTPhotoPreviewView class]])
    {
        self.mt_delegate = previewView;
        MTPhotoPreviewView* pView = (MTPhotoPreviewView*)previewView;
        offset = pView.model.isHideAddBtn || pView.model.isAddBtnAtLast ? 0 : -1;
    }
    
    NSInteger addBtnIndex = -1;
    for(int i = 0;i<count; i++)
    {
        UICollectionViewCell* item = [previewView cellForItemAtIndexPath:arr[i]];
        if(![item isKindOfClass:[MTPhotoPreviewViewCell class]])
            continue;
        
        if([item isKindOfClass:[MTPhotoPreviewViewCell class]])
        {
            MTPhotoPreviewViewCell* cell = (MTPhotoPreviewViewCell*)item;
            if(cell.model.isAdd)
            {
                addBtnIndex = i;
                continue;
            }
        }
        
        self.positionArr[offset + arr[i].row] = [NSValue valueWithCGRect:[[UIApplication sharedApplication].keyWindow convertRect:item.frame fromView:previewView]];
    }
    
    NSInteger minIndex = addBtnIndex == 0 ? 1 : 0;
    NSInteger maxIndex = addBtnIndex == (arr.count - 1) ? arr.count - 2 : arr.count - 1;
    
    self.positionArr[self.cellModelArr.count] = @(arr[minIndex].row + offset);
    self.positionArr[self.cellModelArr.count + 1] = @(arr[maxIndex].row + offset);
    
    return self.positionArr;
}

#pragma mark - 展示图片浏览器

-(void)showWindow
{
    MTPhotoBrowserController* browserController = [MTPhotoBrowserController photoBrowserControllerWithModel:self];
    self.browserController = browserController;
    
    [self.rootViewController.navigationBar setValue:self.isShowNavigationBar ? self.navigationBarColor : [UIColor clearColor] forKey:@"ignoreTranslucentBarTintColor"];
    
    [self.previewWindow makeKeyAndVisible];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIButton* btn = [UIButton new];
        btn.bounds = CGRectMake(0, 0, 45, 45);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btn setImage:weakSelf.deleteBtnImage ? weakSelf.deleteBtnImage : [UIImage imageNamed:@"MTPhotoBrowser.bundle/icon_delete"] forState:UIControlStateNormal];
        btn.hidden = weakSelf.isHideDeleteBtn;
        if(!weakSelf.isHideDeleteBtn)
            [btn addTarget:weakSelf action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        browserController.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btn]];
        
        
        btn = [UIButton new];
        btn.bounds = CGRectMake(0, 0, 45, 45);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setWordWithStyle:mt_WordStyleMake(16, weakSelf.isPopDismiss ? @"返回" :@"", [UIColor whiteColor])];
        if(weakSelf.isPopDismiss)
            [btn addTarget:weakSelf.rootViewController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        browserController.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btn]];
        
        
        UILabel* label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        browserController.navigationItem.titleView = label;
        
        [weakSelf.previewWindow makeKeyAndVisible];
        [weakSelf.rootViewController pushViewController:browserController animated:!weakSelf.isModal];
    });
    
}

-(void)resign
{
    [self.rootViewController popToRootViewControllerAnimated:false];
    [self.photoBrowser removeFromSuperview];
    [self.previewWindow resignKeyWindow];
    self.previewWindow = nil;
    self.changeAlpha = nil;
}

#pragma mark - 数据刷新

/**删除操作后刷新缩略图*/
-(void)reloadPreviewViewAfterDelete
{
    if(!self.deleteBtnClick)
        return;
    
    self.deleteBtnClick = false;
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self.photoBrowser withOrder:MTPhotoPreviewViewReloadDataOrder];
}

-(void)reloadPhotoBrowser
{
    self.isShowAnimate = false;
    
    _photoBrowser = [MTPhotoBrowser shareBrowser];
    self.photoBrowser.model = self;
    [self.photoBrowser show];
    self.currentIndex = self.currentIndex;
}

-(void)reloadTitleAtIndex:(NSInteger)index
{
    if(![self.browserController.navigationItem.titleView isKindOfClass:[UILabel class]])
        return;
    
    UILabel* label = (UILabel*)self.browserController.navigationItem.titleView;
    label.text = [NSString stringWithFormat:@"%zd/%zd",index + 1,self.cellModelArr.count];
    [label sizeToFit];
}

#pragma mark - 图片删除

-(void)deleteImage
{
    @[
        MTAppTitle(),
        MTContent(@"确定要删除？"),
        MTButtons(@[
            @"我按错了".bindOrder(@"MTAlertDeleteImageCancelOrder"),
            @"是的".bindOrder(@"MTAlertDeleteImageOrder"),
        ])
    ].alert_mt();
}

-(void)deleteCellModel
{
    self.deleteBtnClick = YES;
    [self.cellModelArr removeObjectAtIndex:self.currentIndex];
    
    NSInteger allCount = self.cellModelArr.count;
    self.currentIndex = (self.currentIndex > allCount - 1) ? (allCount - 1 < 0 ? 0 : allCount - 1) : (!self.cellModelArr.count ? 0 : self.currentIndex);
    
    
    //刷新数据
    [self.photoBrowser loadData];
    [self reloadPreviewViewAfterDelete];
    
    if(!self.cellModelArr.count)
        [self.rootViewController popViewControllerAnimated:false];
}


#pragma mark - 更新导航栏状态
-(void)refreshNavigationBarStatus
{
    if(self.navigationBarFix)
        return;
    
    if(self.rootViewController.navigationBar.tag == 0)
    {
        SEL navigationBarHide = @selector(navigationBarHide);
        if([self.rootViewController respondsToSelector:navigationBarHide])
           [self.rootViewController performSelector:navigationBarHide];
    }
    else
    {
        SEL navigationBarShow = @selector(navigationBarShow);
        if([self.rootViewController respondsToSelector:navigationBarShow])
           [self.rootViewController performSelector:navigationBarShow];
    }
}


#pragma mark - 将显示cell时检测
-(BOOL)isShowAnimateAtIndex:(NSInteger)index
{
    if(self.isShowAnimate)
        return YES;
    
    if(index != self.currentIndex)
        return false;
    else
    {
        self.isShowAnimate = YES;
        return false;
    }
}

#pragma mark - MT代理

-(void)doSomeThingForMe:(id)obj withOrder:(NSString*)order
{
    if([order isEqualToString:@"MTNavigationControllerDidShowRootViewControllerOrder"])
    {
        [self resign];
    }
    else if([order isEqualToString:@"MTNavigationControllerDidShowPhotoBrowserControllerOrder"])
    {
        [self refreshNavigationBarStatus];
    }
    else if([order isEqualToString:@"MTAlertDeleteImageOrder"])
    {
        [self deleteCellModel];
    }
}


#pragma mark - 懒加载

-(NSMutableArray<MTPhotoPreviewViewCellModel *> *)cellModelArr
{
    if(!_cellModelArr)
    {
        _cellModelArr = [NSMutableArray array];
    }
    
    return _cellModelArr;
}

-(void)setIsModal:(BOOL)isModal
{
    _isModal = isModal;
    
    self.isShowNavigationBar = !isModal;
    self.isPopDismiss = !isModal;
}

/**注释
 
 2、处于modal模式下，单击背景能控制导航栏显示隐藏，单击图片则能退出，但是如果图片铺满屏幕，如何单击黑色背景显示隐藏导航栏
 
 
 */


-(UIWindow *)previewWindow
{
    if(!_previewWindow)
    {
        UIWindow* window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth_mt(), kScreenHeight_mt())];
        window.backgroundColor = [UIColor clearColor];
        window.windowLevel = UIWindowLevelStatusBar + 1;
        _previewWindow = window;
        _previewWindow.rootViewController = self.rootViewController;
    }
    
    return _previewWindow;
}

-(MTNavigationPhotoBrowserController *)rootViewController
{
    if(!_rootViewController)
    {
        UIViewController* vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor clearColor];
        [self setValue:@(0) forKey:@"navigationBarAlpha"];
        _rootViewController = [[MTNavigationPhotoBrowserController alloc] initWithRootViewController: vc];
        
        UIView* bottomLine = [_rootViewController.navigationBar valueForKey:@"bottomLine"];
        bottomLine.backgroundColor = [UIColor clearColor];
        _rootViewController.mt_delegate = self;
        [_rootViewController setValue:@(YES) forKey:@"setupStatusBar"];
    }
    
    return _rootViewController;
}

#pragma mark - 生命周期

-(instancetype)init
{
    if(self = [super init])
    {
        self.isShowNavigationBar = YES;
        self.isHideDeleteBtn = YES;
        self.isPopDismiss = YES;
        self.positionArr = [NSMutableArray array];
        self.navigationBarColor = rgb(48, 50, 52);
    }
    
    return self;
}

-(void)dealloc
{
    [MTPhotoBrowser clearBrowser];
}

@end




