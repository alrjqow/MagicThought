//
//  MTBaseHeaderFooterView.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateHeaderFooterView.h"


@class MTWordStyle;
@interface MTBaseHeaderFooterView : MTDelegateHeaderFooterView

@property (nonatomic,strong) MTWordStyle* word;

-(void)btnClick;

@end

@interface MTSubBaseHeaderFooterView : MTBaseHeaderFooterView

@property (nonatomic,strong) UIButton* btn;

@end



