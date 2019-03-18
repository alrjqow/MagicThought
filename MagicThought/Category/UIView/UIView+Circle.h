//
//  UIView+Circle.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTBorderStyle;
@interface UIView (Circle)

-(void)becomeWeakCircleWithBorder:(MTBorderStyle*) border;
-(void)becomeCircleWithBorder:(MTBorderStyle*) border;
-(void)becomeCircleWithBorder:(MTBorderStyle*) border AndRoundingCorners:(UIRectCorner)corners;

@end


@interface MTWeakLine : UIView

@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat lineMargin;

@end
