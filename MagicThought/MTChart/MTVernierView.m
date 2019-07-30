//
//  MTVernierView.m
//  WSLineChart
//
//  Created by monda on 2019/7/11.
//  Copyright © 2019 zws. All rights reserved.
//

#import "MTVernierView.h"



@implementation MTVernierView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    if(self.config)
        rect.size.width = self.config.pointSelectedRadius;
    [super setFrame:rect];
}

-(void)setConfig:(MTLineChartViewConfig *)config
{
    _config = config;
    
    CGRect rect = self.frame;
    rect.size.width = self.config.pointSelectedRadius;
    self.frame = rect;
}

-(void)drawRect:(CGRect)rect
{
     [super drawRect:rect];
    
    NSInteger i = self.config.currentIndex;
//    NSLog(@"currentIndex: %zd",i);
    CGFloat startY = self.config.yAxisOrigin - (((NSNumber *)self.config.yValueArray[i]).floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight + self.config.currentPointOffset;
    
    CGPoint currentPoint = CGPointMake(self.frame.size.width * 0.5, startY);

    //////////////// 选中点 ///////////////////////
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:currentPoint radius:(self.config.pointRadius+ self.config.pointRingRadiusOffset + self.config.pointSelectedRingRadiusOffset) * self.config.pointSelectedZoomScale startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self.config.pointSelectedRingColor set];
    [bezierPath fill];
    
    
    bezierPath = [UIBezierPath bezierPathWithArcCenter:currentPoint radius:(self.config.pointRadius + self.config.pointRingRadiusOffset) * self.config.pointSelectedZoomScale startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self.config.pointRingColor set];
    [bezierPath fill];
    
    bezierPath = [UIBezierPath bezierPathWithArcCenter:currentPoint radius:self.config.pointRadius * self.config.pointSelectedZoomScale startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self.config.pointColor set];
    [bezierPath fill];
}

@end



@implementation VernierLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //////////////// 游标 ///////////////////////
    
    CGPoint startPoint = CGPointMake(0, self.config.yAxisOrigin - self.config.yAxisHeight - 1);
    CGPoint endPoint = CGPointMake(0, self.frame.size.height);
    UIColor* lineColor = self.config.youBiaoColor;
    
    self.config.isYouBiaoWeak ? [self.config drawWeakLine:context startPoint:startPoint endPoint:endPoint lineColor:lineColor lineWidth:1] : [self.config drawLine:context startPoint:startPoint endPoint:endPoint lineColor:lineColor lineWidth:1];
    
}

@end
