//
//  UIButton+HighLight.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIButton+HighLight.h"

@implementation UIButton (HighLight)

-(void)noHighLight
{
     [self addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}

-(void)resetHighLight
{
    [self removeTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
}

@end
