//
//  MTBaseCell.h
//  SimpleProject
//
//  Created by monda on 2019/5/8.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateTableViewCell.h"


#define MTBaseCellAlertOrder @"MTBaseCellAlertOrder"

@interface MTBaseCell : MTDelegateTableViewCell

/**分割线长度*/
@property (nonatomic,assign) CGFloat sepLineWidth;


/**右箭头的右边距*/
@property (nonatomic,assign) CGFloat accessoryMarginRight;
/**右箭头的尺寸*/
@property (nonatomic,assign) CGRect accessoryBounds;
/**右箭头*/
@property (nonatomic,weak, readonly) UIView* arrow;



@end


@interface MTNoSepLineBaseCell : MTBaseCell @end

@interface MTSubBaseCell : MTBaseCell

@property (nonatomic,strong) UILabel* detailTextLabel2;

@end




