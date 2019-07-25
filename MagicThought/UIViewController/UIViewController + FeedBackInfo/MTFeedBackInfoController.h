//
//  MTFeedBackInfoController.h
//  SimpleProject
//
//  Created by monda on 2019/6/17.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTViewController.h"



@interface MTFeedBackInfoController : MTViewController

@property (nonatomic,strong) UIImageView* imgView;

@property (nonatomic,strong) UILabel* titleLabel;

@property (nonatomic,strong) UILabel* subTitleLabel;

@property (nonatomic,strong) UIButton* enterBtn;


+(instancetype)ControllerWithInfo:(NSDictionary*)info ClickBlock:(void (^)(id))block;


@end


