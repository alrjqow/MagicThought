//
//  MTTenScrollController.h
//  Demo
//
//  Created by monda on 2019/8/19.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTTenScrollView.h"
#import "MTTenScrollModel.h"
#import "MTListController.h"

@interface MTTenScrollController : MTListController

@property (nonatomic,strong) MTTenScrollView* tenScrollView;
@property (nonatomic,strong) MTTenScrollViewX* tenScrollViewX;

@property (nonatomic,strong) MTTenScrollModel* tenScrollModel;

@end


@interface MTTenScrollTableViewController : MTListController

@property (nonatomic,strong) MTDelegateTenScrollView* delegateTenScrollView;
@property (nonatomic,strong) MTDelegateTenScrollViewX* delegateTenScrollViewX;

@end




