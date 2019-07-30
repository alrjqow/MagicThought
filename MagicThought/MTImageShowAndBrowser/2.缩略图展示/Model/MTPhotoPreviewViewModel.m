//
//  MTPhotoPreviewViewModel.m
//  DaYiProject
//
//  Created by monda on 2018/8/24.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTPhotoPreviewViewModel.h"
#import "MTPhotoPreviewViewCellModel.h"
#import "MTPhotoPreviewViewCell.h"
#import "MTPhotoPreviewView.h"
#import "MTPhotoBrowser.h"
#import "MTTakePhotoPreseter.h"
#import "MTPhotoBrowserViewModel.h"

#import "MTConst.h"


@interface MTPhotoPreviewViewModel ()

/**是否完成下载*/
@property(nonatomic,assign,readonly) BOOL isDownloadFinish;

/**图片加载进度*/
@property(nonatomic,assign) NSInteger progress;



@end

@implementation MTPhotoPreviewViewModel

-(void)showBrowserAtIndex:(NSInteger)index
{
    MTPhotoPreviewViewCellModel* model = [self getRealCellModelArr][index];
    
//    if(!self.isDownloadFinish) return;
    
    if(model.isAdd)
    {
        [self goToTakePhoto];
        return;
    }
    
    self.isDeleteReload = false;
    self.browserModel.currentIndex = [self convertToImageIndex:index];
    [self.browserModel showWithPreviewView:self.previewView];
}

-(void)updatePreviewViewPosition
{
    NSInteger index = [self convertToRealIndex:self.browserModel.currentIndex];    
    [self.previewView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];        
}

#pragma mark 获取图片
-(void)goToTakePhoto
{
    if(self.isFull)
    {
        [[[UIAlertView alloc] initWithTitle:mt_AppName() message:[NSString stringWithFormat:@"图片数量达到上限,最多为%zd张.",((NSInteger)self.maxCount)] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    self.completion = ^ {
                                
        [weakSelf.previewView loadData];
    };
    
    self.photoPreseter.model = self;
    [self.photoPreseter show];
}


-(void)updateDownloadProgress
{
    self.progress++;
}


-(void)addCellModelFromImages:(NSArray<UIImage *> *)photos
{
    for(UIImage* image in photos)
    {
        MTPhotoPreviewViewCellModel* cellModel = [MTPhotoPreviewViewCellModel new];
        cellModel.image = image;
        cellModel.isHideDeleteBtn = self.isHideDeleteBtn;
        cellModel.previewViewModel = self;
        cellModel.isPopDismiss = self.browserModel.isPopDismiss;
        cellModel.browserModel = self.browserModel;
        [self.cellModelArr addObject:cellModel];
    }
    
    self.isDeleteReload = false;
}

-(void)reloadPreviewView:(MTPhotoPreviewView*)previewView
{
    _previewView = previewView;
    previewView.model = self;
}



#pragma mark - 懒加载

-(void)setCellIdentifier:(NSString *)cellIdentifier
{
    if(!NSClassFromString(cellIdentifier))
        return;
    
    _cellIdentifier = cellIdentifier;
}

-(void)setBrowserModel:(MTPhotoBrowserViewModel *)browserModel
{
    _browserModel = browserModel;
    browserModel.previewViewModel = self;
    browserModel.cellModelArr = [self getImageCellModelArr];
}

-(void)setBrowserMode:(BOOL)browserMode
{
    _browserMode = browserMode;
    
    self.isHideAddBtn = YES;
    self.isHideDeleteBtn = YES;
}

-(NSInteger)itemCount
{
    return self.cellModelArr.count + !self.isHideAddBtn;
}

-(BOOL)isFull
{
    return self.cellModelArr.count >= self.maxCount;
}

-(MTPhotoPreviewViewCellModel *)addBtnModel
{
    if(!_addBtnModel)
    {
        _addBtnModel = [MTPhotoPreviewViewCellModel new];
        _addBtnModel.isHideDeleteBtn = YES;
        _addBtnModel.image = [UIImage imageNamed:@"MTPhotoBrowser.bundle/add"];
        _addBtnModel.isAdd = YES;
    }
    
    return _addBtnModel;
}

-(NSMutableArray<MTPhotoPreviewViewCellModel*>*)getRealCellModelArr
{
    return [self getCellModelArr:YES];
}
-(NSMutableArray<MTPhotoPreviewViewCellModel*>*)getImageCellModelArr
{
    return [self getCellModelArr:false];
}
-(NSMutableArray<MTPhotoPreviewViewCellModel*>*)getCellModelArr:(BOOL)isReal
{
    if(!isReal || self.isHideAddBtn)
    {
        [self.cellModelArr removeObject:self.addBtnModel];
        return self.cellModelArr;
    }
    
    if([self.cellModelArr objectAtIndex:0] != self.addBtnModel)
    {
        NSInteger index = self.isAddBtnAtLast ? self.cellModelArr.count : 0;
        [self.cellModelArr insertObject:self.addBtnModel atIndex:index];
    }
        
    return self.cellModelArr;
}

-(NSInteger)convertToRealIndex:(NSInteger)imageIndex
{
    return imageIndex + (self.isHideAddBtn || self.isAddBtnAtLast ? 0 : 1);
}

-(NSInteger)convertToImageIndex:(NSInteger)realIndex
{
    return realIndex + (self.isHideAddBtn || self.isAddBtnAtLast ? 0 : -1);
}

-(BOOL)isDownloadFinish
{
    return self.progress >= [self getImageCellModelArr].count;
}

#pragma mark - 初始化
-(instancetype)init
{
    if(self = [super init])
    {        
        self.cellModelArr = [NSMutableArray array];
        self.cellIdentifier = @"MTPhotoPreviewViewCell";
        self.photoPreseter = [MTTakePhotoPreseter preseter];
    }
    
    return self;
}


@end
