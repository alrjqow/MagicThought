//
//  MTListController.m
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTListController.h"

@interface MTListController () @end

@implementation MTListController


#pragma mark - 生命周期

-(void)setupDefault
{
    [super setupDefault];
    
    self.listView.frame = self.view.bounds;    
}

-(void)setupSubview
{
    [super setupSubview];
    
    [self.view addSubview:self.listView];
}


#pragma mark - 网络回调

#pragma mark - 点击事件

#pragma mark - 成员方法

#pragma mark - 代理与数据源



#pragma mark - 懒加载



@end
