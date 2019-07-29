//
//  MTPopView.h
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTDelegateView.h"

@class MTPopViewConfig;
@interface MTPopView : MTDelegateView

@property (nonatomic,strong) MTPopViewConfig* config;

@property (nonatomic, assign) BOOL touchWildToHide;

@property (nonatomic, strong) UIView *attachedView;

- (void)show;

- (void) hide;

@end