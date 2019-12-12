//
//  MTBaseCollectionReusableView.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateCollectionReusableView.h"
#import "MTViewContentModel.h"
#import "UIView+MTBaseViewContentModel.h"
#import "UIView+Frame.h"

@interface MTBaseCollectionReusableView : MTDelegateCollectionReusableView

@property (nonatomic,strong) MTViewContentModel* model;

@property (nonatomic,strong) UILabel* textLabel;

@property (nonatomic,strong) UILabel* detailTextLabel;

@property (nonatomic,strong) UIImageView* imageView;

@end

@interface MTBaseSubCollectionReusableView : MTBaseCollectionReusableView

@property (nonatomic,strong) UIButton* button;

@property (nonatomic,strong) UIButton* button2;

@property (nonatomic,strong) UIImageView* imageView2;

@property (nonatomic,strong) UILabel* detailTextLabel2;

@end
