//
//  MTBaseAlertCollectionController.m
//  SimpleProject
//
//  Created by monda on 2019/6/14.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseAlertCollectionController.h"

#import "MTConst.h"
#import "UIView+Frame.h"
#import "UIView+Circle.h"

@interface MTBaseAlertCollectionController ()

@end

@implementation MTBaseAlertCollectionController

#pragma mark - 生命周期

-(void)setupSubview
{
    [super setupSubview];
    
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth_mt(), self.alertView.height);
    
    [self.alertView addSubview:self.collectionView];
}

#pragma mark - 网络回调

#pragma mark - 网络请求


#pragma mark - 重载方法

#pragma mark - 点击事件


#pragma mark - 成员方法

-(void)loadData
{
    [self.collectionView reloadDataWithDataList:self.dataList ];
}

#pragma mark - 代理与数据源


#pragma mark - 懒加载


-(MTDragCollectionView *)collectionView
{
    if(!_collectionView)
    {
        _collectionView = [[MTDragCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 25, 0, 25);
        [_collectionView addTarget:self];        
    }
    
    return _collectionView;
}


@end
