//
//  MTCollectionBaseCell.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDragCollectionViewCell.h"
#import "MTBaseViewContentModel.h"

@interface MTCollectionBaseCell : MTDragCollectionViewCell

@property (nonatomic,strong) MTBaseViewContentModel* model;

@property (nonatomic,strong) UILabel* textLabel;

@property (nonatomic,strong) UIImageView* imgView;

@end

