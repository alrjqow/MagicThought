//
//  MTCountingView.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/13.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateView.h"


extern NSString*  MTCountingViewOrder;
IB_DESIGNABLE
@interface MTCountingView : MTDelegateView

@property(nonatomic,assign) NSInteger totalTime;
@property(nonatomic,assign) NSInteger limitTime;
/**当前时间*/
@property(nonatomic,assign) NSInteger currentTime;

@property(nonatomic,strong) UIColor* defaultColor;
@property(nonatomic,strong) UIColor* limitColor;

@property(nonatomic,assign) BOOL canClick;

/*!
 * 圆环厚度、颜色
 */
@property (nonatomic, assign) IBInspectable CGFloat ringThickness;
@property (nonatomic, strong) IBInspectable UIColor *ringBackgroundColor;

/**圆环内的背景色*/
@property (nonatomic, strong) IBInspectable UIColor *ringCenterBackgroundColor;


@property (nonatomic, strong) IBInspectable UIFont *valueFont;
@property (nonatomic, strong) IBInspectable UIColor *valueTextColor;

@property(nonatomic,assign) BOOL repeat;
@property(nonatomic,assign) BOOL opposite;

@property(nonatomic,assign) BOOL isAnimate;


-(void)startCounting;


/*!
 *  Trigger the stoke animation of ring layer.
 */
- (void)strokeGauge;

@end


