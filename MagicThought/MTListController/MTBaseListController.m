//
//  MTBaseListController.m
//  QXProject
//
//  Created by monda on 2019/12/4.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseListController.h"

@interface MTBaseListController ()

@end

@implementation MTBaseListController

#pragma mark - 懒加载

- (MTDelegateTableView *)mtBase_tableView
{
    if (_mtBase_tableView == nil) {
                
        _mtBase_tableView = [[MTDelegateTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mtBase_tableView.backgroundColor = [UIColor clearColor];
        _mtBase_tableView.tableFooterView = [UIView new];
        _mtBase_tableView.showsVerticalScrollIndicator = false;
        _mtBase_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //防止分页漂移
        _mtBase_tableView.estimatedRowHeight = 0;
        _mtBase_tableView.estimatedSectionHeaderHeight = 0;
        _mtBase_tableView.estimatedSectionFooterHeight = 0;
    }
    return _mtBase_tableView;
}

-(MTDelegateCollectionView *)mtBase_collectionView
{
    if(!_mtBase_collectionView)
    {
        _mtBase_collectionView = [[MTDelegateCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _mtBase_collectionView.backgroundColor = [UIColor clearColor];
        _mtBase_collectionView.showsVerticalScrollIndicator = false;
    }
    
    return _mtBase_collectionView;
}

-(UIScrollView *)listView
{
    return self.mtBase_tableView;
}

-(NSDictionary *)emptyData
{
    if(!_emptyData)
    {
        _emptyData = @{};
    }
    
    return _emptyData;
}

@end
