//
//  MTHeaderRefreshTableViewController.m
//  MDKit
//
//  Created by monda on 2019/5/17.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTHeaderRefreshTableViewController.h"

@interface MTHeaderRefreshTableViewController ()

@end

@implementation MTHeaderRefreshTableViewController

#pragma mark - 懒加载

-(void)setupSubview
{
    [super setupSubview];
    
    self.mtBase_tableView.mj_header = self.mj_header;
}

-(MTHeaderRefreshBlock)mj_Block
{
    if(!_mj_Block)
    {
        __weak __typeof(self) weakSelf = self;
        _mj_Block = ^{
            
            [weakSelf.mtBase_tableView.mj_header endRefreshing];
        };
    }
    
    return _mj_Block;
}

-(MTRefreshGifHeader *)mj_header
{
    if(!_mj_header)
    {
        __weak __typeof(self) weakSelf = self;
        _mj_header = [MTRefreshGifHeader headerWithRefreshingBlock:^{
            
            weakSelf.mj_Block();
        }];
    }
    
    return _mj_header;
}


@end
