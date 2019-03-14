//
//  UIView+Circle.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIView+Circle.h"
#import "MTBorderStyle.h"
#import "MTDefine.h"
//#import "MTCategory.h"

@implementation MTWeakLine

-(void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, 1.0);
    // 线的颜色    
    CGContextSetStrokeColorWithColor(context, hex(0x666666).CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, 0, 0);
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    
    if(!self.lineWidth)
        self.lineWidth = 2;
    if(!self.lineMargin)
        self.lineMargin = 2;
    CGFloat lengths[] = {self.lineWidth,self.lineMargin};
   
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths,2);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect),0.0);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
}

@end


@implementation UIView (Circle)

-(void)becomeWeakCircleWithBorder:(MTBorderStyle*) border
{
    border.isWeak = YES;

    [self becomeCircleWithBorder:border];
}

-(void)becomeCircleWithBorder:(MTBorderStyle*) border
{
    if(!border)
        border = mt_BorderStyleMake(2, self.frame.size.width * 0.5, [UIColor whiteColor]);
    
    if(border.fillColor)
        self.backgroundColor = border.fillColor;
    
    self.layer.cornerRadius = border.borderRadius;
    self.layer.masksToBounds = YES;
    
    if (border.isWeak)
    {
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        layer.strokeColor = border.borderColor.CGColor;
        
        layer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        layer.frame = self.bounds;
        
        layer.lineWidth = border.borderWidth;
        
        layer.lineCap = @"square";
        
        layer.lineDashPattern = @[@4, @2];
        
        [self.layer addSublayer:layer];
    }
    else
    {
        self.layer.borderColor = border.borderColor.CGColor;
        self.layer.borderWidth = border.borderWidth;
    }
    
}


-(void)becomeCircleWithBorder:(MTBorderStyle*) border AndRoundingCorners:(UIRectCorner)corners
{    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners: corners cornerRadii:CGSizeMake(border.borderRadius, border.borderRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    self.layer.borderColor = border.borderColor.CGColor;
    self.layer.borderWidth = border.borderWidth;
    self.layer.masksToBounds = YES;
    
    if(border.fillColor)
        self.backgroundColor = border.fillColor;
}

@end
