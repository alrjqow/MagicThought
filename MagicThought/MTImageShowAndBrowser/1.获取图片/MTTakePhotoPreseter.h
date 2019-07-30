//
//  MTTakePhotoPreseter.h
//  8kqw
//
//  Created by 王奕聪 on 2016/12/21.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import "MTManager.h"

@class MTTakePhotoPreseterModel;

@interface MTTakePhotoPreseter : MTManager

@property (nonatomic,weak) MTTakePhotoPreseterModel* model;

+(instancetype)preseter;

-(void)show;


@end
