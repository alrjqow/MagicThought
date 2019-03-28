//
//  MTPhotoPreviewViewCellModel.h
//  DaYiProject
//
//  Created by monda on 2018/8/24.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTImageLoadType)
{
    MTImageLoadTypeImage,
    MTImageLoadTypeImageName,
    MTImageLoadTypeImageURL,
};

@class MTPhotoLook;
@class MTPhotoPreviewViewModel;
@class MTPhotoBrowserViewModel;
@interface MTPhotoPreviewViewCellModel : NSObject

/**切换回起始位置*/
@property (nonatomic,copy) void (^changToOriginPosition)(CGRect);

/**默认0.25秒*/
@property (nonatomic,assign) CGFloat animateTime;

/**显示的大图的View*/
@property (nonatomic,weak) MTPhotoLook* look;

/**缩略图模型*/
@property (nonatomic,weak) MTPhotoPreviewViewModel* previewViewModel;

/**浏览器模型*/
@property (nonatomic,weak) MTPhotoBrowserViewModel* browserModel;

/**根据look调整的图片尺寸*/
@property (nonatomic,assign, readonly) CGSize imageLookSize;

/**根据look调整的图片尺寸是否超出look高度*/
@property (nonatomic,assign, readonly) BOOL isImageOverLookHeight;

@property (nonatomic,assign) MTImageLoadType loadType;

/**是否通过push展示大图*/
@property (nonatomic,assign) BOOL isPopDismiss;

/**是否为添加按钮*/
@property(nonatomic,assign) BOOL isAdd;

/**是否隐藏删除按钮*/
@property(nonatomic,assign) BOOL isHideDeleteBtn;

/**删除按钮图片名*/
@property(nonatomic,strong) NSString* deleteBtnImageName;

/**加载未完成时显示的图片*/
@property(nonatomic,strong) NSString* placeholderImageName;

/**显示的图片*/
@property(nonatomic,strong) UIImage* image;

/**显示的图片字符串*/
@property(nonatomic,strong) NSString* imageString;

/**标识*/
@property (nonatomic,strong) NSString* identifier;

-(void)getImage:(void (^)(UIImage*))completion;

/**根据点击的点缩放*/
-(void)zoomWithPoint:(CGPoint)point;

/**保存图片*/
-(void)savePhoto;

/**开始缩放动画*/
-(void)startAnimate;

/**单击退出*/
-(void)tapPhotoDismiss;
/**退出*/
-(void)dismiss;


/**需要重设尺寸的view*/
-(void)resizeViewForZooming:(UIView*)view;

/**scrollView代理*/
-(void)lookDidEndDraggingWithDecelerate:(BOOL)decelerate;

/**scrollView代理*/
-(void)lookDidEndDecelerating;


@end


