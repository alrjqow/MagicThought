//
//  MTTenScrollController.h
//  Demo
//
//  Created by monda on 2019/8/19.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTViewController.h"
#import "MTTenScrollView.h"
#import "MTTenScrollModel.h"
#import "MTTableViewController.h"

@interface MTTenScrollController : MTTableViewController

@property (nonatomic,strong) MTTenScrollView* tenScrollView;

@property (nonatomic,strong) MTTenScrollModel* tenScrollModel;

@end


@interface MTTenScrollTableViewController : MTTableViewController

@property (nonatomic,strong) MTDelegateTenScrollTableView* tenScrollTableView;


@end




