//
//  MTBorderStyle.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/9.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTBorderStyle.h"
#import <MJExtension.h>


@implementation MTBorderStyle

+(NSArray *)mj_ignoredPropertyNames
{
    return @[@"corners", @"weak", @"fill", @"masksToBounds", @"viewSize"];
}

-(ViewSize)viewSize
{
    __weak __typeof(self) weakSelf = self;
       ViewSize viewSize = ^(CGFloat viewWidth, CGFloat viewHeight){
                      
           weakSelf.borderViewSize = CGSizeMake(viewWidth, viewHeight);
           return weakSelf;
       };
       
       return viewSize;
}

-(Corners)corners
{
    __weak __typeof(self) weakSelf = self;
    Corners corners = ^(UIRectCorner borderCorners){
        
        weakSelf.borderCorners = borderCorners;
        return weakSelf;
    };
    
    return corners;
}

-(Weak)weak
{
    __weak __typeof(self) weakSelf = self;
    Weak weak = ^(BOOL borderWeak){
        
        weakSelf.borderWeak = borderWeak;
        return weakSelf;
    };
    
    return weak;
}

-(Fill)fill
{
    __weak __typeof(self) weakSelf = self;
    Fill fill = ^(UIColor* fillColor){
        
        weakSelf.fillColor = fillColor;
        return weakSelf;
    };
    
    return fill;
}

-(MasksToBounds)masksToBounds
{
    __weak __typeof(self) weakSelf = self;
      MasksToBounds masksToBounds = ^{
          
          weakSelf.borderMasksToBounds = YES;
          return weakSelf;
      };
      
      return masksToBounds;
}

-(instancetype)init
{
    if(self = [super init])
    {
        self.borderCorners = UIRectCornerAllCorners;        
    }
    
    return self;
}

MTBorderStyle* mt_BorderStyleMake(CGFloat borderWidth, CGFloat borderRadius,UIColor* borderColor)
{
    MTBorderStyle* border = [MTBorderStyle new];
    border.borderWidth = borderWidth;
    border.borderRadius = borderRadius;
    border.borderColor = borderColor;
    
    return border;
}

@end


@implementation MTShadowStyle

MTShadowStyle* mt_ShadowStyleMake(CGFloat shadowOpacity, CGFloat shadowRadius, UIColor* shadowColor, CGSize shadowOffset)
{
    MTShadowStyle* shadowStyle = [MTShadowStyle new];
    shadowStyle.shadowOpacity = shadowOpacity;
    shadowStyle.shadowRadius = shadowRadius;
    shadowStyle.shadowColor = shadowColor;
    shadowStyle.shadowOffset = shadowOffset;
    
    return shadowStyle;
}

@end


