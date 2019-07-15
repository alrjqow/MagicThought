//
//  MTBaseCollectionReusableView.h
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateCollectionReusableView.h"


@class MTWordStyle;
@interface MTBaseCollectionReusableView : MTDelegateCollectionReusableView

@property (nonatomic,strong) UILabel* textLabel;

@property (nonatomic,strong) MTWordStyle* word;

@end

