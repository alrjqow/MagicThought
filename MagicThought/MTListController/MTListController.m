//
//  MTListController.m
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTListController.h"

#import "MTBaseDataModel.h"
#import "MJExtension.h"
#import "NSObject+ReuseIdentifier.h"
#import "MTDelegateViewDataModel.h"
#import "NSString+Exist.h"

@interface MTListController ()

@property (nonatomic,strong) MTDelegateViewDataModel* dataModel;

@end

@implementation MTListController


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
    
    self.listView.frame = self.view.bounds;
    [self.listView addTarget:self];
}

-(void)setupSubview
{
    [super setupSubview];
    
    [self.view addSubview:self.listView];
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
    
    
    [self.listView reloadDataWithDataList:dataList  SectionList:sectionList EmptyData:emptyData];
}

#pragma mark - 重载方法

- (void)whenEndRefreshing:(BOOL)isSuccess Model:(MTBaseDataModel *)model
{
    [super whenEndRefreshing:isSuccess Model:model];
    
    if(isSuccess && [self.endRefreshBlackList objectForKey:model.url])
        return;
    
    [self.listView.mj_header endRefreshing];
    
    if(![self isKindOfClass:NSClassFromString(@"MTHeaderFooterRefreshListController")])
        [self.listView.mj_footer endRefreshing];
}

#pragma mark - 点击事件


#pragma mark - 成员方法


#pragma mark - 代理与数据源


#pragma mark - 懒加载

-(MTDelegateViewDataModel *)dataModel
{    
    if(!_dataModel && [self.dataModelClassName isExist])
    {
        Class c = NSClassFromString(self.dataModelClassName);
                
        if(![c isSubclassOfClass:[MTDelegateViewDataModel class]])
            return nil;
     
        _dataModel = [c modelForController:self];
    }
    
    return _dataModel;
}

-(NSString *)dataModelClassName
{
    return nil;
}

@end
