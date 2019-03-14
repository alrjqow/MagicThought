//
//  UIColor+ColorfulColor.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIColor+ColorfulColor.h"

@implementation UIColor (ColorfulColor)

+(UIColor*)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue
{
    return [self colorWithR:red G:green B:blue A:1.0];
}


+(UIColor*)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [self colorWithRed: 1.0*(red)/255 green:1.0*(green)/255 blue:1.0*(blue)/255 alpha:alpha];
}

+(UIColor*)colorWithHex:(NSUInteger)hex
{
    return [self colorWithHex:hex WithAlpha:1.0];
}

+(UIColor*)colorWithHex:(NSUInteger)hex WithAlpha:(CGFloat)a
{
    return  [self colorWithRed:(((hex) & 0xFF0000) >> 16) / 255.0 green:(((hex) & 0xFF00) >> 8) / 255.0 blue:((hex) & 0xFF) / 255.0 alpha:a];
}




@end



@implementation UIView (ColorfulColor)

-(void)createJianBianBackgroundColorWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor
{    
    [self createJianBianBackgroundColorWithStartColor:startColor endColor:endColor startPoint:CGPointMake(0,CGRectGetMidY(self.bounds)) endPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds))];
}


-(void)createJianBianBackgroundColorWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[self createJianBianImageWithStartColor:startColor endColor:endColor startPoint:startPoint endPoint:endPoint]];
    
    [self insertSubview:imgView atIndex:0];
}

-(UIImage*)createJianBianImageWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor
{
    return [self createJianBianImageWithStartColor:startColor endColor:endColor startPoint:CGPointMake(0,CGRectGetMidY(self.bounds)) endPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds))];
}

-(UIImage*)createJianBianImageWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = self.bounds;
    CGPathAddRect(path, nil, rect);
    //警示：原来还有这种玩法
    //    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    //    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    //    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    //    CGRect pathRect = CGPathGetBoundingBox(path);
    
    
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end



