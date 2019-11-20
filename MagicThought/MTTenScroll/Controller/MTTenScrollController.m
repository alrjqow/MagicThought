//
//  MTTenScrollController.m
//  Demo
//
//  Created by monda on 2019/8/19.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTTenScrollController.h"

@interface MTTenScrollController ()



@end

@implementation MTTenScrollController

#pragma mark - 生命周期

#pragma mark - 网络回调

#pragma mark - 网络请求


#pragma mark - 重载方法

#pragma mark - 点击事件


#pragma mark - 成员方法


#pragma mark - 代理与数据源


#pragma mark - 懒加载

-(MTTenScrollView *)tenScrollView
{
    if(!_tenScrollView)
    {
        _tenScrollView = [MTTenScrollView new];
        _tenScrollView.mt_tenScrollModel = self.tenScrollModel;
        _tenScrollView.delegate = self;
//        _tenScrollView.bounces = false;
    }
    
    return _tenScrollView;
}

-(MTTenScrollViewX *)tenScrollViewX
{
    if(!_tenScrollViewX)
    {
        _tenScrollViewX = [MTTenScrollViewX new];
        _tenScrollViewX.mt_tenScrollModel = self.tenScrollModel;
        _tenScrollViewX.delegate = self;
//        _tenScrollView.bounces = false;
    }
    
    return _tenScrollViewX;
}

-(UIScrollView *)listView
{
    return self.tenScrollView;
}

-(MTTenScrollModel *)tenScrollModel
{
    if(!_tenScrollModel)
    {
        _tenScrollModel = [MTTenScrollModel new];
        _tenScrollModel.delegate = self;
    }
    
    return _tenScrollModel;
}

@end




#pragma mark - MTTenScrollTableViewController


@interface MTTenScrollTableViewController ()

@end

@implementation MTTenScrollTableViewController

#pragma mark - 生命周期

#pragma mark - 网络回调

#pragma mark - 网络请求


#pragma mark - 重载方法

#pragma mark - 点击事件


#pragma mark - 成员方法


#pragma mark - 代理与数据源


#pragma mark - 懒加载


-(MTDelegateTenScrollView *)delegateTenScrollView
{
    if(!_delegateTenScrollView)
    {
        _delegateTenScrollView = [MTDelegateTenScrollView new];
    }
    
    return _delegateTenScrollView;
}

-(MTDelegateTenScrollViewX *)delegateTenScrollViewX
{
    if(!_delegateTenScrollViewX)
    {
        _delegateTenScrollViewX = [MTDelegateTenScrollViewX new];
    }
    
    return _delegateTenScrollViewX;
}

-(UIScrollView *)listView
{
    return self.delegateTenScrollView;
}


@end
