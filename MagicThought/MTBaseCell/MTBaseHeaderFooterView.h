//
//  MTBaseHeaderFooterView.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateHeaderFooterView.h"
#import "MTBaseViewContentModel.h"

@interface MTBaseHeaderFooterView : MTDelegateHeaderFooterView

@property (nonatomic,strong) MTBaseViewContentModel* model;

@end

@interface MTSubBaseHeaderFooterView : MTBaseHeaderFooterView

@property (nonatomic,strong) UIButton* btn;

@end



