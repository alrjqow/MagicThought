//
//  MTBaseCell.h
//  SimpleProject
//
//  Created by monda on 2019/5/8.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateTableViewCell.h"
#import "MTBaseCellModel.h"


@interface MTBaseCell : MTDelegateTableViewCell

@property (nonatomic,strong) MTBaseCellModel* model;

/**右箭头*/
@property (nonatomic,weak, readonly) UIView* arrowView;

@end


@interface MTNoSepLineBaseCell : MTBaseCell @end


@interface MTSubBaseCell : MTBaseCell

@property (nonatomic,strong) UILabel* detailTextLabel2;

@end





