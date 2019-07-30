//
//  MTXAxisView.m
//  WSLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "MTXAxisView.h"


@interface MTXAxisView ()



@end



@implementation MTXAxisView

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
    
    self.config.MTXAxisViewWidth = frame.size.width;
}

-(void)setConfig:(MTLineChartViewConfig *)config
{
    _config = config;
    
    config.MTXAxisViewWidth = self.frame.size.width;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment: NSTextAlignmentCenter];
    NSDictionary *attr = @{NSParagraphStyleAttributeName: style, NSFontAttributeName : [UIFont systemFontOfSize:self.config.axisLabelFontSize], NSForegroundColorAttributeName:self.config.axisLabelFontColor};
    
    //////////////// 画原点上的x轴 ///////////////////////
    
    [self.config drawLine:context
               startPoint:CGPointMake(self.config.isXAxisOriginLeftSpace ? 0 : self.config.xAxisLeftSpace, 1)
                 endPoint:CGPointMake(self.frame.size.width - self.config.xAxisRightSpace + 1, 1)
                lineColor:self.config.xAxisColor
                lineWidth:1];
    
    for (int i = 0; i < self.config.xTitleArray.count; i++) {
        
        if(self.config.xAxisMarkShowIndexArray.count)
        {
            NSInteger index = [self.config.xAxisMarkShowIndexArray indexOfObject:@(i)];
            
            if(index >= self.config.xAxisMarkShowIndexArray.count || index < 0)
                continue;
        }
        
        
        NSString *title = self.config.xTitleArray[i];
        
        CGSize labelSize = [title sizeWithAttributes:attr];
        
        //画垂直X轴的竖线
        CGFloat shuXianX = i * self.config.xAxisMargin + self.config.xAxisLeftSpace;
        [self.config drawLine:context
                   startPoint:CGPointMake(shuXianX, 1)
                     endPoint:CGPointMake(shuXianX, self.config.xAxisMarkWidth + 1)
                    lineColor:self.config.axisMarkColor
                    lineWidth:1];
        
        //画X轴文字
        CGRect titleRect = CGRectMake(shuXianX - labelSize.width / 2,self.frame.size.height - self.config.axisLabelFontSize,labelSize.width,self.config.axisLabelFontSize);
        
        if(self.config.isJustifyAlign)
        {
            if(i == 0)
                titleRect.origin.x = shuXianX;
            else if(i == self.config.xTitleArray.count - 1)
                titleRect.origin.x -= labelSize.width / 2;
        }
        
        if(self.config.isLabelScaleAutoHide)
        {
            if(titleRect.size.width <= self.config.xAxisMargin)
                [title drawInRect:titleRect withAttributes:attr];
        }
        else
            [title drawInRect:titleRect withAttributes:attr];
    }
}


@end
