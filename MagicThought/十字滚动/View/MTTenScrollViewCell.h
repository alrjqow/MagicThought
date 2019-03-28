//
//  MTTenScrollViewCell.h
//  DaYiProject
//
//  Created by monda on 2018/12/25.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTDelegateTableViewCell.h"


@class MTTenScrollModel;
@interface MTTenScrollViewCell : MTDelegateTableViewCell

@property (nonatomic,weak) MTTenScrollModel* model;

@end

