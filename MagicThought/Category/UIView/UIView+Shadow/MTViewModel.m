//
//  MTViewModel.m
//  MyTool
//
//  Created by 王奕聪 on 2017/3/2.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTViewModel.h"

@implementation MTViewModel


+(instancetype)modelWithView:(UIView*)view Sel:(NSString*)sel
{
    MTViewModel* model = [MTViewModel new];
    model.view = view;
    model.sel = sel;
    
    return model;
}

@end
