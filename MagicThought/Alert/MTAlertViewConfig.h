//
//  MTAlertViewConfig.h
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTPopViewConfig.h"

@class MTPopButtonItem;
@interface MTAlertViewConfig : MTPopViewConfig

@property (nonatomic,strong) NSString* title;

@property (nonatomic,strong) NSString* detail;

@property (nonatomic,strong) NSAttributedString* attributedDetail;

@property (nonatomic,strong) NSString* logoName;

@property (nonatomic,strong) NSArray<MTPopButtonItem*>* items;

@property (nonatomic,assign) NSTextAlignment detailAlignment;


/*-----------------------------------华丽分割线-----------------------------------*/

@property (nonatomic, assign) CGFloat width;                // Default is 275.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat innerTopMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic,assign) UIEdgeInsets logoMargin;  // Default is (0, 0, 12, 6).

@property (nonatomic, assign) CGFloat detailInnerMargin;          // Default is 25.

@property (nonatomic,assign) CGFloat detailLineSpacing;     // Default is 1.

@property (nonatomic, strong) UIFont* titleFont;        // Default is 18.
@property (nonatomic, strong) UIFont* detailFont;       // Default is 14.
@property (nonatomic, strong) UIFont* buttonFont;       // Default is 17.


@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #333333.
@property (nonatomic, strong) UIColor *detailColor;         // Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.
@property (nonatomic, assign) CGFloat splitWidth;          // Default is #CCCCCC.


@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextOK;      // Default is "好".
@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消".
@property (nonatomic, strong) NSString *defaultTextConfirm; // Default is "确定".

@property (nonatomic,assign) CGFloat detailHeight;

@property (nonatomic,assign) CGFloat alertViewHeight;

@end
