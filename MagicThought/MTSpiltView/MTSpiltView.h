//
//  MTSpiltView.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/21.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateView.h"
#import "MTBorderStyle.h"

extern NSString*  MTSpiltViewPanEndOrder;
@interface MTSpiltView : MTDelegateView

+(instancetype _Nullable )spiltViewWithLeftView:( UIView* _Nonnull )leftView AndRightView:(UIView* _Nonnull)rightView;

@property(nonatomic,assign) CGFloat centerToLeft;
@property(nonatomic,assign) CGFloat centerToRight;
@property(nonatomic,assign) CGFloat circleToCenter;
@property(nonatomic,weak) UIColor* _Nullable spiltLineColor;
@property(nonatomic,weak) MTBorderStyle* _Nullable lineBtnStyle;

-(void)defaultCenter;



@end
