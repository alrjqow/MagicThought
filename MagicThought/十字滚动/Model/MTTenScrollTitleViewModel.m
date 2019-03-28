//
//  MTTenScrollTitleViewModel.m
//  DaYiProject
//
//  Created by monda on 2018/12/20.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollTitleViewModel.h"

#import "MTDefine.h"
#import "MTWordStyle.h"
#import "UIColor+ColorfulColor.h"

@implementation MTTenScrollTitleViewModel

#pragma mark - 生命周期

-(instancetype)init
{
    if(self = [super init])
    {
        self.margin = 20;
        self.padding = 25;
        self.titleViewHeight = 44;
    }
    
    return self;
}

#pragma mark - 懒加载

-(MTWordStyle *)normalStyle
{
    if(!_normalStyle)
    {
        _normalStyle = mt_WordStyleMake(14, @"", [UIColor blackColor]);
    }
    
    return _normalStyle;
}

-(MTWordStyle *)selectedStyle
{
    if(!_selectedStyle)
    {
        _selectedStyle = mt_WordStyleMake(18, @"", hex(0x2976f4)).bold(YES);
    }
    
    return _selectedStyle;
}

-(UIColor *)bottomLineColor
{
    if(!_bottomLineColor)
    {
        _bottomLineColor = hex(0x2976f4);        
    }
    
    return _bottomLineColor;
}

-(UIColor *)titleViewBgColor
{
    if(!_titleViewBgColor)
    {
        _titleViewBgColor = [UIColor whiteColor];
    }
    
    return _titleViewBgColor;
}

@end
