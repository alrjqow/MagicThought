//
//  MTTenScrollView.h
//  DaYiProject
//
//  Created by monda on 2018/12/26.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTDelegateTableView.h"


@class MTTenScrollModel;
@interface MTTenScrollView : MTDelegateTableView

@property (nonatomic,strong) MTTenScrollModel* model;

@end



@interface MTDelegateTenScrollTableView : MTDelegateTableView

@property (nonatomic,weak) MTTenScrollModel* model;

@end
