//
//  MTTextField.h
//  DaYiProject
//
//  Created by monda on 2018/8/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTDelegateProtocol.h"
#import "MTTextFieldVerifyModel.h"

@interface MTTextField : UITextField

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@property (nonatomic,weak) MTTextFieldVerifyModel* verifyModel;

-(BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)didBeginEditing;
- (void)didEndEditing;
-(void)didTextValueChange;

@end


