//
//  MTPhotoLook.m
//  MTPhotoBrowser
//
//  Created by 王奕聪 on 2016/12/14.
//  Copyright © 2016年 com.king.app. All rights reserved.
//

#import "MTPhotoLook.h"
#import "MTPhotoBrowser.h"
#import "MTPhotoManager.h"
#import "MTConst.h"
#import "MBProgressHUD.h"
#import "MTPhotoPreviewViewCellModel.h"
#import "MTPhotoBrowserViewModel.h"


@interface MTPhotoLook ()<UIScrollViewDelegate>

@property(nonatomic,weak) UIImageView* imageView;

@property (nonatomic,weak) MTPhotoPreviewViewCellModel* preModel;


@end

@implementation MTPhotoLook


#pragma mark - 单击

-(void)oneTap:(UIGestureRecognizer*)tap
{
    [self.model tapPhotoDismiss];
}

#pragma mark - 双击

-(void)zoomTap:(UITapGestureRecognizer*) tap
{
    [self.model zoomWithPoint:[tap locationInView:self.imageView]];
}

#pragma mark - 长按

-(void)savePhoto:(UILongPressGestureRecognizer*)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
        [self.model savePhoto];
}


#pragma mark - 重置位置

-(void)resize
{
    if(!self.model.image || CGSizeEqualToSize(self.bounds.size, CGSizeZero))
        return;
    
    self.zoomScale = 1;
    self.imageView.image = self.model.image;
    self.imageView.bounds = CGRectMake(0,  0, self.model.imageLookSize.width, self.model.imageLookSize.height);
    self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [self.model resizeViewForZooming:self.imageView];
}


#pragma mark - scrollView代理

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self.model resizeViewForZooming:self.imageView];
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.model lookDidEndDraggingWithDecelerate:decelerate];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.model lookDidEndDecelerating];
}


#pragma mark - 懒加载

-(void)setFrame:(CGRect)frame
{
    CGRect rect = self.frame;
    [super setFrame:frame];
    
    //说明改变了尺寸
    if(rect.size.width != frame.size.width || rect.size.height != frame.size.height)
        [self resize];
}

-(void)setModel:(MTPhotoPreviewViewCellModel *)model
{
    self.preModel = _model;
    _model = model;
    
    model.look = self;
    
    __weak __typeof(self) weakSelf = self;
    model.changToOriginPosition = ^(CGRect position) {
        weakSelf.imageView.frame = position;
    };
    
    [self resize];
}

-(UIImageView *)imageView
{
    if(!_imageView)
    {
        UIImageView* imgView = [UIImageView new];
        imgView.userInteractionEnabled = YES;
        imgView.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *zoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
        zoomTap.numberOfTapsRequired = 2;
        [imgView addGestureRecognizer:zoomTap];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
        [imgView addGestureRecognizer:tap];
        [tap requireGestureRecognizerToFail:zoomTap];
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
        [imgView addGestureRecognizer:longPress];
        
        [self addSubview:imgView];
        _imageView = imgView;
    }
    
    return _imageView;
}


#pragma mark - 初始化

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        
        if (@available(iOS 11.0, *))
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.maximumZoomScale=3.0;
        self.minimumZoomScale=1;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end
