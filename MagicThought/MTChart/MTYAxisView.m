//
//  MTYAxisView.m
//  WSLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "MTYAxisView.h"

@interface MTYAxisView ()


@end

@implementation MTYAxisView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame: frame];
    
    self.config.yAxisViewHeight = frame.size.height;
}

-(void)setConfig:(MTLineChartViewConfig *)config
{
    _config = config;
    
    config.yAxisViewHeight = self.frame.size.height;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 计算坐标轴的位置以及大小
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    //    [style setAlignment: NSTextAlignmentCenter];
    NSDictionary *attr = @{NSParagraphStyleAttributeName: style, NSFontAttributeName : [UIFont systemFontOfSize:self.config.axisLabelFontSize], NSForegroundColorAttributeName:self.config.axisLabelFontColor};
    
    
    CGFloat avgValue = (self.config.yMax - self.config.yMin) / self.config.numberOfYAxisElements;
    
    CGFloat startPointY = 0;
    CGFloat endPointY = 0;
    
    // 添加Label
    for (int i = 0; i < self.config.numberOfYAxisElements + 1; i++) {
        
        CGFloat pointY = self.config.yAxisOrigin - self.config.yAxisMargin * i;
        
        if(i == 0)
        {
            pointY++;
            startPointY = pointY;
        }
        
        if(i == self.config.numberOfYAxisElements)
            endPointY = pointY;
        
        
        [self.config drawLine:context startPoint:CGPointMake(self.config.yAxisLeftMargin - (i == 0 ? 0 : 1), pointY) endPoint:CGPointMake(self.config.yAxisLeftMargin - 1 - self.config.yAxisMarkWidth, pointY) lineColor:self.config.axisMarkColor lineWidth:1];
        
        
        // 判断是不是小数
        
        NSString* yLabel = [NSString stringWithFormat:self.config.isPureFloatShow ? @"%.2f" : @"%.0f", self.config.yMin + avgValue * i];
        CGSize yLabelSize = [yLabel sizeWithAttributes:attr];
        CGFloat yLabelSizeW = self.config.yAxisLeftMargin - self.config.yAxisMarkWidth - self.config.yAxisMarkAndLabelMargin - self.config.yAxisLabelLeftMargin;
        if(yLabelSizeW > 0)
            yLabelSize.width = yLabelSizeW;
        
        CGRect labelRect = CGRectMake(self.config.yAxisLeftMargin - self.config.yAxisMarkWidth - self.config.yAxisMarkAndLabelMargin - yLabelSize.width, pointY - yLabelSize.height * 0.5, yLabelSize.width, yLabelSize.height);
        
        //        [[UIColor blackColor] set];
        //        CGContextFillRect(context, labelRect);
        if(labelRect.size.height <= self.config.yAxisMargin)
            [yLabel drawInRect:labelRect withAttributes:attr];
    }
    
    
    //////////////// 画原点上的y轴 ///////////////////////
    
    [self.config drawLine:context startPoint:CGPointMake(self.config.yAxisLeftMargin - 1, startPointY) endPoint:CGPointMake(self.config.yAxisLeftMargin - 1, endPointY) lineColor:self.config.yAxisColor lineWidth:1];
}






@end
