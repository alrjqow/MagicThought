//
//  MTTextField.h
//  DaYiProject
//
//  Created by monda on 2018/8/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "UIView+Delegate.h"
#import "MTTextFieldVerifyModel.h"

@interface MTTextField : UITextField

@property (nonatomic,weak) MTTextFieldVerifyModel* verifyModel;

-(BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)didBeginEditing;
- (void)didEndEditing;
-(void)didTextValueChange;

@end


