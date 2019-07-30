//
//  MTLineChartViewConfig.m
//  WSLineChart
//
//  Created by monda on 2019/7/3.
//  Copyright © 2019 zws. All rights reserved.
//

#import "MTLineChartViewConfig.h"
#import "MTConst.h"

@implementation MTLineChartViewConfig

- (instancetype)init
{
    if (self = [super init])
    {
        self.xAxisDefaultMargin = self.xAxisMargin = 60;
        self.yAxisDefaultMargin = self.yAxisMargin = 40;
        self.xAxisDefaultLeftSpace = self.xAxisLeftSpace = 15;
        self.axisLabelFontSize = 12;
        self.axisLabelFontColor = hex(0x999999);
        self.numberOfYAxisElements = 5;
        
        self.xAxisMarkWidth = 10;
        self.xAxisMarkAndLabelMargin = 2;
        self.yAxisMarkWidth = 0;
        self.yAxisMarkAndLabelMargin = 0;
        self.yAxisLabelLeftMargin = 0;
        
        
        self.xAxisRightSpace = 30;
        self.detailFontSize = 12;
        self.detailFontColor = [UIColor whiteColor];
        self.yAxisLeftMargin = 30;
        self.separatorColor = hex(0xe5e5e5);
        self.xAxisColor = hex(0xe5e5e5);
        self.yAxisColor = [UIColor clearColor];
        self.axisMarkColor = [UIColor clearColor];
        self.youBiaoColor = hex(0xe5e5e5);
        self.lineColor = hex(0x2976f4);
        
        self.pointColor = [UIColor whiteColor];
        self.pointRingColor = hex(0x2976f4);
        self.pointSelectedRingColor = hexa(0x2976f4, 0.25);
        
        self.isYouBiaoWeak = YES;
        self.detailFontHMargin = 12;
        self.detailFontVMargin = 10;
        
        self.pointRadius = 3.2;
        self.pointSelectedZoomScale = 1.8;
        self.pointRingRadiusOffset = 1;
        self.pointSelectedRingRadiusOffset = 2;
        
        self.lineBgStartColor = hexa(0x2976f4, 0.4);
        self.lineBgEndColor = hexa(0xffffff, 0.4);
        
        self.isLabelScaleAutoHide = YES;
        self.xAxisMarkShowIndexArray = @[];
        
        __weak __typeof(self) weakSelf = self;
        self.detailMsg = ^(NSInteger currentIndex){
            
            if(currentIndex >= weakSelf.xTitleArray.count || currentIndex >= weakSelf.yValueArray.count)
                return @"";
            
            return [NSString stringWithFormat:@"(%@,%.0lf)", weakSelf.xTitleArray[currentIndex], ((NSNumber*)weakSelf.yValueArray[currentIndex]).floatValue];;
        };
    }
    return self;
}

-(void)setXAxisDefaultMargin:(CGFloat)xAxisDefaultMargin
{
    _xAxisDefaultMargin = xAxisDefaultMargin;
    self.xAxisMargin = xAxisDefaultMargin;
}

-(void)setYAxisDefaultMargin:(CGFloat)yAxisDefaultMargin
{
    _yAxisDefaultMargin = yAxisDefaultMargin;
    self.yAxisMargin = yAxisDefaultMargin;
}

-(void)setMTYAxisViewHeight:(CGFloat)MTYAxisViewHeight
{
    _MTYAxisViewHeight = MTYAxisViewHeight;
    
    self.yAxisOrigin = MTYAxisViewHeight - self.xAxisMarkWidth - self.xAxisMarkAndLabelMargin - self.axisLabelFontSize;
}

-(void)setMTXAxisViewWidth:(CGFloat)MTXAxisViewWidth
{
    _MTXAxisViewWidth = MTXAxisViewWidth;
    
    self.xAxisWidth = MTXAxisViewWidth - self.xAxisRightSpace;
}

-(CGFloat)yAxisHeight
{
    return self.numberOfYAxisElements * self.yAxisMargin;
}

-(CGFloat)pointSelectedRadius
{
    return (self.pointRadius + self.pointRingRadiusOffset + self.pointSelectedRingRadiusOffset) * self.pointSelectedZoomScale * 2;
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num
{
    NSInteger i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}


- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    //注意释放CGMutablePathRef
    CGPathRelease(path);
}

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}

- (void)drawWeakLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGFloat  lengths[] = {10, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}


@end
