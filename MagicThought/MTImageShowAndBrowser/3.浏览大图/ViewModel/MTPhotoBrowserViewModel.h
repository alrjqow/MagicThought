//
//  MTPhotoBrowserViewModel.h
//  DaYiProject
//
//  Created by monda on 2018/8/28.
//  Copyright © 2018 monda. All rights reserved.
//

#import "NSObject+CommonProtocol.h"

@class MTPhotoBrowserConfig;
@class MTPhotoPreviewViewCellModel;
@class MTPhotoPreviewViewModel;
@class MTPhotoBrowser;
@class MTPhotoLook;
@class MTNavigationPhotoBrowserController;
@protocol MTDelegateProtocol;

@interface MTPhotoBrowserViewModel : NSObject

/**改变透明度*/
@property (nonatomic,copy) void (^changeAlpha)(CGFloat);

/**图片浏览器*/
@property (nonatomic,weak, readonly) MTPhotoBrowser* photoBrowser;

/**缩略图模型*/
@property (nonatomic,weak) MTPhotoPreviewViewModel* previewViewModel;

/**缩略图数据模型*/
@property(nonatomic,strong) NSMutableArray<MTPhotoPreviewViewCellModel*>*  cellModelArr;

/**是否以模态方式显示*/
@property (nonatomic,assign) BOOL isModal;

/**是否通过pop退出*/
@property (nonatomic,assign) BOOL isPopDismiss;

/**是否隐藏删除按钮*/
@property(nonatomic,assign) BOOL isHideDeleteBtn;

/**是否隐藏小圆点*/
@property(nonatomic,assign) BOOL isHidePagePoint;

/**删除按钮图片*/
@property(nonatomic,assign) UIImage* deleteBtnImage;

/**当前索引*/
@property(nonatomic,assign) NSInteger currentIndex;

/**根控制器*/
@property (nonatomic,strong,readonly) MTNavigationPhotoBrowserController* rootViewController;

/**是否显示导航栏*/
@property (nonatomic,assign) BOOL isShowNavigationBar;

/**导航栏颜色*/
@property (nonatomic,strong) UIColor* navigationBarColor;

/**导航栏固定*/
@property (nonatomic,assign) BOOL navigationBarFix;

/**注销窗口同时移除浏览器*/
-(void)resign;

/**刷新图片浏览器*/
-(void)reloadPhotoBrowser;

/**展示用的*/
-(void)showWithPreviewViews:(NSArray<UIView*>*)previewViews startIndex:(NSInteger)index;
-(void)showWithPreviewView:(UIView<MTDelegateProtocol>*)previewView;

/**获取位置*/
-(CGRect)getCurrentPosition;

/**更新导航栏状态*/
-(void)refreshNavigationBarStatus;

/**检测是否展示正确的索引动画*/
-(BOOL)isShowAnimateAtIndex:(NSInteger)index;

/**刷新标题*/
-(void)reloadTitleAtIndex:(NSInteger)index;

@end


