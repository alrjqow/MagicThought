//
//  MTDrawRect.m
//  8kqw
//
//  Created by 王奕聪 on 2017/4/19.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTDrawRect.h"

@implementation MTDrawRect

+(void)drawRectWithGraphicType:(MTGraphicType)type WithBorderStyle:(MTBorderStyle*)style
{
    if(type == MTGraphicTypeDefault) return;
    
    switch (type) {
        case MTGraphicTypeRoundRect:
            [self drawRoundRect:style];
            break;
            
        default:
            break;
    }
}

+(void)drawRoundRect:(MTBorderStyle*)style
{    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect drawRect = style.borderRect;
    CGContextSetLineWidth(context, style.borderWidth);
    
    
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:style.borderRadius];
    CGContextAddPath(context, bezierPath.CGPath);
    
    CGContextSetStrokeColorWithColor(context, style.borderColor.CGColor);
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, style.fillColor.CGColor);    
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:style.borderRadius];
    CGContextAddPath(context, bezierPath2.CGPath);
    
    CGContextFillPath(context);

    
}

@end
