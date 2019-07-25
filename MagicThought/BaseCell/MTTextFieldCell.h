//
//  MTTextFieldCell.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCell.h"


@class MTTextField;
@class MTTextFieldVerifyModel;
@interface MTTextFieldCell : MTBaseCell<UITextFieldDelegate>

@property (nonatomic,assign) CGFloat textFieldMargin;

@property (nonatomic,strong) MTTextField* textField;

@property (nonatomic,weak) MTTextFieldVerifyModel* verifyModel;

@property (nonatomic,assign) CGFloat placeholderSize;

@end



