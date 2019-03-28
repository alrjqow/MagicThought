//
//  MTPhotoPreviewViewCell.h
//  8kqw
//
//  Created by 王奕聪 on 2017/1/5.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateCollectionViewCell.h"
#import "MTPhotoPreviewViewCellModel.h"

@interface MTPhotoPreviewViewCell : MTDelegateCollectionViewCell

@property (strong, nonatomic, readonly) UIImageView *imgView;
@property (strong, nonatomic, readonly)  UIButton *deleteBtn;


@property (nonatomic,weak) MTPhotoPreviewViewCellModel* model;



@end
