//
//  MTBaseView.h
//  QXProject
//
//  Created by monda on 2019/12/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateView.h"
#import "MTViewContentModel.h"
#import "UIView+MTBaseViewContentModel.h"
#import "UIView+Frame.h"

@interface MTBaseView : MTDelegateView

@property (nonatomic,strong) MTViewContentModel* contentModel;

@property (nonatomic,strong) UILabel* textLabel;

@property (nonatomic,strong) UILabel* detailTextLabel;

@property (nonatomic,strong) UIImageView* imageView;

@end


@interface MTBaseSubView : MTBaseView

@property (nonatomic,strong) UIButton* button;

@property (nonatomic,strong) UIButton* button2;

@property (nonatomic,strong) UIImageView* imageView2;

@property (nonatomic,strong) UILabel* detailTextLabel2;

@end
