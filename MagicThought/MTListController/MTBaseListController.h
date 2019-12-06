//
//  MTBaseListController.h
//  QXProject
//
//  Created by monda on 2019/12/4.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTViewController.h"
#import "MTDelegateTableView.h"
#import "MTDelegateCollectionView.h"

@interface MTBaseListController : MTViewController

/**懒加载，默认不添加到父级*/
@property (nonatomic, strong) MTDelegateTableView *mtBase_tableView;
@property (nonatomic, strong) MTDelegateCollectionView *mtBase_collectionView;
/**默认为 mtBase_tableView*/
@property (nonatomic, strong, readonly) UIScrollView *listView;

/**空数据*/
@property (nonatomic, strong) NSDictionary* emptyData;

@end


