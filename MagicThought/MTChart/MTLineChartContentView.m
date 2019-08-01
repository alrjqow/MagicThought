//
//  MTLineChartContentView.m
//  WSLineChart
//
//  Created by monda on 2019/7/5.
//  Copyright © 2019 zws. All rights reserved.
//

#import "MTLineChartContentView.h"
#import "MTConst.h"

@interface MTLineChartContentView ()



@end

@implementation MTLineChartContentView

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
    
    self.config.xAxisViewWidth = frame.size.width;
}

-(void)setConfig:(MTLineChartViewConfig *)config
{
    _config = config;
    
    config.xMaxIndex = config.xTitleArray.count - 1;
    if(config.xMaxIndex < 0)
        config.xMaxIndex = 0;
}

-(void)setScreenLoc:(CGPoint)screenLoc
{
    _screenLoc = screenLoc;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ////////////// 画横向分割线 ///////////////////////
    CGFloat maxSepLineY = 0;
    for (int i = 1; i < self.config.numberOfYAxisElements + 1; i++) {
        
        CGFloat pointY = self.config.yAxisOrigin - self.config.yAxisMargin * i;
        if(i == self.config.numberOfYAxisElements)
            maxSepLineY = pointY;
        
        
        [self.config drawLine:context
                   startPoint:CGPointMake(self.config.isXAxisOriginLeftSpace ? 0 : self.config.xAxisLeftSpace, pointY)
                     endPoint:CGPointMake(self.frame.size.width - self.config.xAxisRightSpace, pointY)
                    lineColor:self.config.separatorColor
                    lineWidth:1];
    }
    
    //////////////// 大背景 ///////////////////////
    if(self.config.lineBgStartColor)
    {
        CGMutablePathRef bgPath = CGPathCreateMutable();
        CGPathMoveToPoint(bgPath, NULL, self.config.xAxisLeftSpace, self.frame.size.height);
        
        for (int i = 0; i < self.config.xTitleArray.count; i++) {
            
            CGFloat shuXianX = i * self.config.xAxisMargin + self.config.xAxisLeftSpace;
            CGFloat startY = self.config.yAxisOrigin - (((NSNumber *)self.config.yValueArray[i]).floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight;
            
            CGPoint startPoint = CGPointMake(shuXianX, startY);
            CGPathAddLineToPoint(bgPath, NULL, startPoint.x, startPoint.y);
            
            if(i == self.config.xTitleArray.count - 1)
                CGPathAddLineToPoint(bgPath, NULL, shuXianX, self.frame.size.height);
        }
        
        CGPathCloseSubpath(bgPath);
        if(self.config.lineBgStartColor && self.config.lineBgEndColor)
            [self.config drawLinearGradient:context path:bgPath startColor:self.config.lineBgStartColor.CGColor endColor:self.config.lineBgEndColor.CGColor];
        else
        {
            CGContextSetFillColorWithColor(context, self.config.lineBgStartColor.CGColor);//填充颜色
            CGContextAddPath(context, bgPath);
            CGContextDrawPath(context, kCGPathFillStroke);//绘制填充
            CGPathRelease(bgPath);
        }
    }
    
    //////////////// 画折线 ///////////////////////
    for (int i = 0; i < self.config.xTitleArray.count; i++) {
        
        CGFloat shuXianX = i * self.config.xAxisMargin + self.config.xAxisLeftSpace;
        CGFloat startY = self.config.yAxisOrigin - (((NSNumber *)self.config.yValueArray[i]).floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight;
        
        CGPoint startPoint = CGPointMake(shuXianX, startY);
        
        CGPoint endPoint;
        if(i < self.config.yValueArray.count - 1)
        {
            NSNumber *endValue = self.config.yValueArray[i+1];
            
            endPoint = CGPointMake(shuXianX + self.config.xAxisMargin, self.config.yAxisOrigin - (endValue.floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight);
        }
        else
            endPoint = startPoint;
        
        BOOL isWeakLine = false;
        if(self.config.weakLinePointIndexArray.count)
        {
            NSInteger index = [self.config.weakLinePointIndexArray indexOfObject:@(i)];
            
            if(index < self.config.weakLinePointIndexArray.count && index >= 0)
                isWeakLine = YES;
        }
        
        if(isWeakLine)
            [self.config drawWeakLine:context startPoint:startPoint endPoint:endPoint lineColor:self.config.lineColor lineWidth:1];
        else
            [self.config drawLine:context startPoint:startPoint endPoint:endPoint lineColor:self.config.lineColor lineWidth:1];
        
        //画点
        CGFloat normal[1]={1};
        CGContextSetLineDash(context,0,normal,0); //画实线
        CGContextSetShouldAntialias(context, YES ); //抗锯齿
        CGContextSetStrokeColorWithColor(context, self.config.lineColor.CGColor);
        CGContextSetFillColorWithColor(context, self.config.pointColor.CGColor);//填充颜色
        CGContextAddArc(context, startPoint.x, startPoint.y, self.config.pointRadius, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFillStroke);//绘制填充
    }
    
    
    
    //////////////// 选中点的详情文字 ///////////////////////
    
    CGFloat selectedPointX = self.config.currentIndex * self.config.xAxisMargin + self.config.xAxisLeftSpace;
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    //    style.lineSpacing = 6;
    NSDictionary *detailAttr = @{NSParagraphStyleAttributeName: style, NSFontAttributeName : [UIFont systemFontOfSize:self.config.detailFontSize], NSForegroundColorAttributeName : self.config.detailFontColor};
    //    NSString* detail = [NSString stringWithFormat:@"(%@,%.0lf)", self.config.xTitleArray[self.config.currentIndex], ((NSNumber*)self.config.yValueArray[self.config.currentIndex]).floatValue];
    NSString* detail = self.config.detailMsg(self.config.currentIndex);
    CGSize detailSize = [detail sizeWithAttributes:detailAttr];
    
    if(self.config.isPanning)
        return;
    CGFloat youBiaoMargin = 0;
    
    //画文字所在的位置  动态变化
    CGPoint drawPoint = CGPointZero;
    if(_screenLoc.x > (kScreenWidth_mt() - self.config.yAxisLeftMargin) / 2 ) {
        //游标靠右
        drawPoint.x = selectedPointX - self.config.pointSelectedRadius / 2 - youBiaoMargin - self.config.detailFontHMargin - detailSize.width;
    }
    else{
        drawPoint.x = selectedPointX + self.config.pointSelectedRadius / 2 + youBiaoMargin + self.config.detailFontHMargin;
    }
    
    NSNumber *drawPointYValue = self.config.yValueArray[self.config.currentIndex];
    
    drawPoint.y = self.config.yAxisOrigin - (drawPointYValue.floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight - detailSize.height - self.config.detailFontVMargin - youBiaoMargin - self.config.pointSelectedRadius / 2;
    
    
    CGFloat minDrawPointY = maxSepLineY + self.config.detailFontVMargin;
    //证明点比较靠上，移至下方
    if(drawPoint.y < minDrawPointY)
        drawPoint.y = self.config.yAxisOrigin - (drawPointYValue.floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight + self.config.detailFontVMargin + youBiaoMargin + self.config.pointSelectedRadius / 2;
    
    //画选中的数值
    CGFloat detailBgWidth = detailSize.width + 2 * self.config.detailFontHMargin;
    CGFloat detailBgHeight = detailSize.height + 2 * self.config.detailFontVMargin;
    CGPoint detailCenter = CGPointMake(drawPoint.x + detailSize.width * 0.5, drawPoint.y + detailSize.height * 0.5);
    CGRect detailRect = CGRectMake(detailCenter.x - detailBgWidth / 2, detailCenter.y - detailBgHeight / 2, detailBgWidth, detailBgHeight);
    
    if(detailRect.origin.y >= maxSepLineY)
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:detailRect cornerRadius:4];
        
        [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] set];
        [bezierPath fill];
        
        [detail drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y) withAttributes: detailAttr];
    }
    
}


@end
