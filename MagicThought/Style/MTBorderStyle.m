//
//  MTBorderStyle.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/9.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTBorderStyle.h"

@implementation MTBorderStyle

MTBorderStyle* mt_BorderStyleMake(CGFloat borderWidth, CGFloat borderRadius,UIColor* borderColor)
{
    MTBorderStyle* border = [MTBorderStyle new];
    border.borderWidth = borderWidth;
    border.borderRadius = borderRadius;
    border.borderColor = borderColor;
    
    return border;
}

MTBorderStyle* mt_BorderStyleAppend(MTBorderStyle* style, CGRect borderRect,UIColor* fillColor)
{
    style.borderRect = borderRect;
    style.fillColor = fillColor;
    
    return style;
}

@end
