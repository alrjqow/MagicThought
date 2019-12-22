//
//  MTHeaderRefreshListController.m
//  MDKit
//
//  Created by monda on 2019/5/17.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTHeaderRefreshListController.h"

@interface MTHeaderRefreshListController ()

@end

@implementation MTHeaderRefreshListController

#pragma mark - 懒加载

-(void)setupSubview
{
    [super setupSubview];
    
    self.listView.mj_header = self.mj_header;
    self.listView.mj_header.refreshingBlock = self.mj_Block;
}

-(MTHeaderRefreshBlock)mj_Block
{
    if(!_mj_Block)
    {
        __weak __typeof(self) weakSelf = self;
        _mj_Block = ^{
            
            [weakSelf.listView.mj_header endRefreshing];
        };
    }
    
    return _mj_Block;
}

-(MTRefreshGifHeader *)mj_header
{
    if(!_mj_header)
    {        
        _mj_header = [MTRefreshGifHeader headerWithRefreshingBlock:nil];
    }
    
    return _mj_header;
}


@end
