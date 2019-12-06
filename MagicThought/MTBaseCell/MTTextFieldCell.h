//
//  MTTextFieldCell.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCell.h"
#import "MTTextFieldCellModel.h"
#import "MTTextField.h"

@interface MTTextFieldCell : MTBaseCell<UITextFieldDelegate>

@property (nonatomic,strong) MTTextField* textField;

@end





