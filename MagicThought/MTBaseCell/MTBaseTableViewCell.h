//
//  MTBaseTableViewCell.h
//  SimpleProject
//
//  Created by monda on 2019/5/8.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateTableViewCell.h"
#import "MTBaseCellModel.h"


@interface MTBaseTableViewCell : MTDelegateTableViewCell

@property (nonatomic,strong) MTBaseCellModel* model;

/**右箭头*/
@property (nonatomic,weak, readonly) UIView* arrowView;

@end


@interface MTNoSepLineBaseCell : MTBaseTableViewCell @end


@interface MTBaseSubTableViewCell : MTBaseTableViewCell

@property (nonatomic,strong) UIButton* button;

@property (nonatomic,strong) UIButton* button2;

@property (nonatomic,strong) UIImageView* imageView2;

@property (nonatomic,strong) UILabel* detailTextLabel2;

@end





