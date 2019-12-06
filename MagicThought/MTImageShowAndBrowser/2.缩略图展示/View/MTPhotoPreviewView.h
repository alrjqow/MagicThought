//
//  MTPhotoPreviewView.h
//  8kqw
//
//  Created by 王奕聪 on 2017/1/5.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateCollectionView.h"

extern NSString*  MTPhotoPreviewViewReloadDataOrder;
extern NSString*  MTPhotoPreviewViewCellDownloadImageFinishOrder;

@class MTPhotoPreviewViewModel;
@interface MTPhotoPreviewView : MTDelegateCollectionView<UICollectionViewDelegate,MTDelegateProtocol>

@property (nonatomic,weak) MTPhotoPreviewViewModel* model;


@end
