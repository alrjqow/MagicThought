//
//  MTAlertViewConfig.h
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTPopViewConfig.h"

@class MTAlertViewButtonConfig;

@interface MTAlertViewConfig : MTPopViewConfig

@property (nonatomic, strong) NSArray<MTAlertViewButtonConfig*>* buttonModelList;

/*-----------------------------------华丽分割线-----------------------------------*/

@property (nonatomic, assign) CGFloat width;                // Default is 275.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat innerTopMargin;          // Default is 25.

@property (nonatomic,assign) UIEdgeInsets logoMargin;  // Default is (0, 0, 12, 6).

@property (nonatomic, assign) CGFloat detailInnerMargin;          // Default is 25.

@property (nonatomic, assign) CGFloat splitWidth;          // Default is #CCCCCC.

@property (nonatomic,assign) CGFloat detailHeight;

@property (nonatomic,assign) CGFloat alertViewHeight;

-(void)alert;

@end


@interface MTAlertViewButtonConfig : MTBaseButtonContentModel @end
