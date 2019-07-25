//
//  MTLockViewConfig.m
//  手势解锁
//
//  Created by monda on 2018/3/19.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTLockViewConfig.h"
#import "UIColor+ColorfulColor.h"
#import "MTConst.h"

@implementation MTLockViewConfig


-(instancetype)init
{
    if(self = [super init])
    {
        self.circleConnectLineWidth = 2;
        self.edgeWidth = 1.f;
        self.circleRadio = 0.4f;
        self.trangleLength = 10.f;
        self.circleRadius = 30;
        self.edgeMargin = 30;
        
        self.isEdgeFill = YES;
        
        self.normalLineColor = hex(0xFFB035);
        self.errorLineColor = rgba(254,82,92,1);
        
        _outCircleColors = @[[UIColor clearColor],hexa(0xFF6600, 0.5),rgb(254,82,92)];
        _inCircleColors = @[rgb(242,242,242),hex(0xFF6600),rgb(254,82,92)];
        _trangleColors = @[[UIColor clearColor],rgb(34,178,246),rgb(254,82,92)];
    }
    
    return self;
}


-(void)setupDefault
{
    self.circleConnectLineWidth = 1;
    self.edgeWidth = 1.f;
    self.circleRadio = 0.4f;
    self.trangleLength = 10.f;
    self.circleRadius = 30;
    self.edgeMargin = 30;
    
    self.normalLineColor = rgba(34,178,246,1);
    self.errorLineColor = rgba(254,82,92,1);
    
    _outCircleColors = @[rgb(241,241,241),rgb(34,178,246),rgb(254,82,92)];
    _inCircleColors = @[[UIColor clearColor],rgb(34,178,246),rgb(254,82,92)];
    _trangleColors = @[[UIColor clearColor],rgb(34,178,246),rgb(254,82,92)];
}


-(void)setTrangleColors:(NSArray<UIColor *> *)trangleColors
{
    NSMutableArray* arr = [_trangleColors mutableCopy];
    for(int i = 0; i < trangleColors.count; i++)
    {
        if(!trangleColors[i]) continue;
        if(i >= _trangleColors.count) break;
        
        arr[i] = trangleColors[i];
    }
    
    _trangleColors = [arr copy];
}

-(void)setOutCircleColors:(NSArray<UIColor *> *)outCircleColors
{
    NSMutableArray* arr = [_outCircleColors mutableCopy];
    for(int i = 0; i < outCircleColors.count; i++)
    {
        if(!outCircleColors[i]) continue;
        if(i >= _outCircleColors.count) break;
        
        arr[i] = outCircleColors[i];
    }
    
    _outCircleColors = [arr copy];
}

-(void)setInCircleColors:(NSArray<UIColor *> *)inCircleColors
{
    NSMutableArray* arr = [_inCircleColors mutableCopy];
    for(int i = 0; i < inCircleColors.count; i++)
    {
        if(!inCircleColors[i]) continue;
        if(i >= _inCircleColors.count) break;
        
        arr[i] = inCircleColors[i];
    }
    
    _inCircleColors = [arr copy];
}

@end
