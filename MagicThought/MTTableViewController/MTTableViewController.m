//
//  MTTableViewController.m
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTTableViewController.h"

#import "MTBaseDataModel.h"
#import "MJExtension.h"
#import "NSObject+ReuseIdentifier.h"

@interface MTTableViewController ()
{
    NSArray * _modelList;
}


@end

@implementation MTTableViewController


#pragma mark - 生命周期

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    [self startRequest];
}


-(void)setupDefault
{
    [super setupDefault];
    
    [self.mtBase_tableView addTarget:self];
}

-(void)setupSubview
{
    [super setupSubview];
    
    self.mtBase_tableView.frame = self.view.bounds;
    [self.view addSubview:self.mtBase_tableView];
}


#pragma mark - 网络回调

#pragma mark - 网络请求

-(void)loadData
{
    NSArray* dataList;
    NSArray* sectionList;
    NSObject* emptyData;
    
    if([self respondsToSelector:@selector(dataList)])
        dataList = self.dataList;
    
    if([self respondsToSelector:@selector(sectionList)])
        sectionList = self.sectionList;
    
    if([self respondsToSelector:@selector(emptyData)])
        emptyData = self.emptyData;
    
    if(!dataList)
        dataList = self.dataModel.dataList;
    if(!sectionList)
        sectionList = self.dataModel.sectionList;
    if(!emptyData)
        emptyData = self.dataModel.emptyData;
    
    
    [self.mtBase_tableView reloadDataWithDataList:dataList  SectionList:sectionList EmptyData:emptyData];
}

#pragma mark - 重载方法

- (void)whenEndRefreshing:(BOOL)isSuccess Model:(MTBaseDataModel *)model
{
    [super whenEndRefreshing:isSuccess Model:model];
    
    if(isSuccess && [self.endRefreshBlackList objectForKey:model.url])
        return;
    
    [self.mtBase_tableView.mj_header endRefreshing];
    
    if(![self isKindOfClass:NSClassFromString(@"MTHeaderFooterRefreshTableViewController")])
        [self.mtBase_tableView.mj_footer endRefreshing];
}

#pragma mark - 点击事件


#pragma mark - 成员方法


#pragma mark - 代理与数据源

-(NSArray *)dataList
{
    if(!_modelList)
    {
        NSArray* arr = [NSClassFromString(self.modelClassName) mj_objectArrayWithKeyValuesArray:self.keyValueList];
    arr.band(self.keyValueList.mt_reuseIdentifier).bandHeight(self.keyValueList.mt_itemHeight);
        _modelList = arr;
    }
    
    return _modelList;
    
}

#pragma mark - 懒加载


-(MTDelegateViewDataModel *)dataModel
{
    if(!_dataModel)
    {
        _dataModel = [MTDelegateViewDataModel modelForController:self];
    }
    
    return _dataModel;
}

@end