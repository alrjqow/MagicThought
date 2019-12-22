//
//  MTBaseListController.m
//  QXProject
//
//  Created by monda on 2019/12/4.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseListController.h"
#import "MTBaseDataModel.h"
#import "MTDelegateViewDataModel.h"
#import "NSString+Exist.h"

@interface MTBaseListController ()

@property (nonatomic,strong) MTDelegateViewDataModel* dataModel;

@end

@implementation MTBaseListController

#pragma mark - 生命周期

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    [self startRequest];
}

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


#pragma mark - 懒加载

- (MTDelegateTableView *)mtBase_tableView
{
    if (_mtBase_tableView == nil) {
                
        _mtBase_tableView = [[MTDelegateTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mtBase_tableView.backgroundColor = [UIColor clearColor];
        _mtBase_tableView.showsVerticalScrollIndicator = false;
        _mtBase_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mtBase_tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight_mt(), 0);
        //防止分页漂移
        _mtBase_tableView.estimatedRowHeight = 0;
        _mtBase_tableView.estimatedSectionHeaderHeight = 0;
        _mtBase_tableView.estimatedSectionFooterHeight = 0;
        [_mtBase_tableView addTarget:self];
//        在设置代理前设置tableFooterView，上边会出现多余间距，谨记谨记
        _mtBase_tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *))
            _mtBase_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _mtBase_tableView;
}

-(MTDragCollectionView *)mtBase_collectionView
{
    if(!_mtBase_collectionView)
    {
        _mtBase_collectionView = [[MTDragCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _mtBase_collectionView.backgroundColor = [UIColor clearColor];
        _mtBase_collectionView.showsVerticalScrollIndicator = false;
        _mtBase_collectionView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight_mt(), 0);
        
        [_mtBase_collectionView addTarget:self];
        if (@available(iOS 11.0, *))
            _mtBase_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    return _mtBase_collectionView;
}

-(UIScrollView *)listView
{
    return self.mtBase_tableView;
}

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

-(void)setEmptyData:(NSObject *)emptyData
{
    _realEmptyData = emptyData;
    [self loadData];
}

-(NSObject *)emptyData
{
    return self.realEmptyData;
}

-(void)setDataList:(NSArray *)dataList
{
    _realDataList = dataList;
    [self loadData];
}

-(NSArray *)dataList
{
    return self.realDataList;
}

-(void)setTenScrollDataList:(NSArray *)tenScrollDataList
{
    _realTenScrollDataList = tenScrollDataList;
    [self loadData];
}

-(NSArray *)tenScrollDataList
{
    return self.realTenScrollDataList;
}

-(void)setSectionList:(NSArray *)sectionList
{
    _realSectionList = sectionList;
    [self loadData];
}

-(NSArray *)sectionList
{
    return self.realSectionList;
}

@end
