//
//  MTPhotoPreviewViewModel.h
//  DaYiProject
//
//  Created by monda on 2018/8/24.
//  Copyright © 2018 monda. All rights reserved.
//


#import "MTTakePhotoPreseterModel.h"
#import "MTDelegateProtocol.h"

@class MTPhotoPreviewViewCellModel;
@class MTPhotoPreviewView;
@class MTTakePhotoPreseter;
@class MTPhotoBrowserViewModel;

@interface MTPhotoPreviewViewModel : MTTakePhotoPreseterModel<MTDelegateProtocol>

@property(nonatomic,weak, readonly) MTPhotoPreviewView* previewView;

/**是否删除引起的刷新,在添加图片或浏览大图时复位*/
@property(nonatomic,assign) BOOL isDeleteReload;

/**一页的item数量*/
@property(nonatomic,assign) NSInteger pageCount;

/**大图模型*/
@property(nonatomic,weak) MTPhotoBrowserViewModel* browserModel;

/**重用cell的类*/
@property (nonatomic,strong) NSString* cellIdentifier;

/**图片获取类的类名*/
@property (nonatomic,weak) MTTakePhotoPreseter* photoPreseter;

/**添加按钮数据*/
@property (nonatomic,strong) MTPhotoPreviewViewCellModel* addBtnModel;

/**添加按钮是否在末尾*/
@property (nonatomic,assign) BOOL isAddBtnAtLast;

/**是否隐藏添加按钮*/
@property(nonatomic,assign) BOOL isHideAddBtn;

/**是否隐藏删除按钮*/
@property(nonatomic,assign) BOOL isHideDeleteBtn;

/**浏览模式*/
@property(nonatomic,assign) BOOL browserMode;

/**缩略图数据模型*/
@property(nonatomic,strong) NSMutableArray<MTPhotoPreviewViewCellModel*>*  cellModelArr;

/**item数量*/
@property(nonatomic,assign,readonly) NSInteger itemCount;

/**是否达到最大图片数*/
@property(nonatomic,assign,readonly) BOOL isFull;

/**更新下载进度*/
-(void)updateDownloadProgress;

/**t根据一组图片返回对应的CellModel*/
-(void)addCellModelFromImages:(NSArray<UIImage *> *)photos;

/**获取带有添加按钮的cellModel*/
-(NSMutableArray<MTPhotoPreviewViewCellModel*>*)getRealCellModelArr;

/**获取不带有添加按钮的cellModel*/
-(NSMutableArray<MTPhotoPreviewViewCellModel*>*)getImageCellModelArr;

/**转换图片索引为cell索引*/
-(NSInteger)convertToRealIndex:(NSInteger)imageIndex;

/**转换cell索引为图片索引*/
-(NSInteger)convertToImageIndex:(NSInteger)realIndex;

/**刷新缩略图*/
-(void)reloadPreviewView:(MTPhotoPreviewView*)previewView;

/**展示大图*/
-(void)showBrowserAtIndex:(NSInteger)index;

/**刷新缩略图位移*/
-(void)updatePreviewViewPosition;

@end


