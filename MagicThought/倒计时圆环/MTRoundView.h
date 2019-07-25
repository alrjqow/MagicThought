//
//  MTRoundView.h
//  MyTool
//
//  Created by 王奕聪 on 2017/6/24.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateView.h"

typedef enum : NSUInteger {
    
    /**匀速*/
    MTRoundViewSpeedUniform,
    
    /**匀加速*/
    MTRoundViewSpeedAcceleration,
    
    /**匀减速*/
    MTRoundViewSpeedRetard,
    
} MTRoundViewSpeedType;

IB_DESIGNABLE
@interface MTRoundView : MTDelegateView

/**花费时间*/
@property(nonatomic,assign) CGFloat spendTime;

/**默认进度由无到有，相反则由有变无*/
@property(nonatomic,assign) BOOL opposite;

/**设置特定的进度*/
@property(nonatomic,assign) CGFloat targetProgress;

/**圆环厚度*/
@property(nonatomic,assign) CGFloat ringThickness;

/**圆环内背景颜色*/
@property(nonatomic,strong) UIColor* ringBackgroundColor;

/**圆环的颜色*/
@property(nonatomic,strong) UIColor* ringColor;

/**进度条的颜色*/
@property(nonatomic,strong) UIColor* progressDefaultColor;

/**加速类型*/
@property(nonatomic,assign) MTRoundViewSpeedType speedType;

/**是否需要动画*/
@property(nonatomic,assign) BOOL isAnimate;

-(void)startRuning;

@end
