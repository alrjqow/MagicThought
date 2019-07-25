//
//  MTHeaderFooterRefreshTableViewController.h
//  MDKit
//
//  Created by monda on 2019/5/17.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTHeaderRefreshTableViewController.h"
#import "MTRefreshAutoNormalFooter.h"
#import "MTPageInfoModel.h"


@interface MTHeaderFooterRefreshTableViewController : MTHeaderRefreshTableViewController

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) MTRefreshAutoNormalFooter* mj_footer;

@property (nonatomic,copy) MTFooterRefreshBlock mj_footer_Block;

@property (nonatomic,strong) MTPageInfoModel* infoModel;

@property (nonatomic,assign, readonly) BOOL isRemoveMJHeader;

@property (nonatomic,strong) NSMutableArray* itemArr;

@end



