//
//  MTBaseHeaderFooterView.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateHeaderFooterView.h"
#import "MTViewContentModel.h"
#import "UIView+MTBaseViewContentModel.h"
#import "UIView+Frame.h"

@interface MTBaseHeaderFooterView : MTDelegateHeaderFooterView

@property (nonatomic,strong) MTViewContentModel* contentModel;

@property (nonatomic,strong) UIImageView* imageView;

@end

@interface MTBaseSubHeaderFooterView : MTBaseHeaderFooterView

@property (nonatomic,strong) UIButton* button;

@property (nonatomic,strong) UIButton* button2;

@property (nonatomic,strong) UIImageView* imageView2;

@property (nonatomic,strong) UILabel* detailTextLabel2;

@end



