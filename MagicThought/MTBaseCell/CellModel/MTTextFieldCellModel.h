//
//  MTTextFieldCellModel.h
//  QXProject
//
//  Created by monda on 2019/12/6.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCell.h"
#import "MTTextFieldVerifyModel.h"

@interface MTTextFieldCellModel : MTBaseCellModel

@property (nonatomic,assign) CGFloat textFieldMargin;

@property (nonatomic,assign) CGFloat placeholderSize;

@property (nonatomic,weak) MTTextFieldVerifyModel* verifyModel;

@end
