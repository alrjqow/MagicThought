//
//  MTBaseCollectionReusableView.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateCollectionReusableView.h"
#import "MTBaseViewContentModel.h"

@interface MTBaseCollectionReusableView : MTDelegateCollectionReusableView

@property (nonatomic,strong) MTBaseViewContentModel* model;

@property (nonatomic,strong, readonly) UILabel* textLabel;

@end

