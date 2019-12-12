//
//  UIView+MTBaseViewContentModel.h
//  QXProject
//
//  Created by monda on 2019/12/12.
//  Copyright © 2019 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTBaseViewContentModel;
@interface UIView (MTBaseViewContentModel)

/**view 的状态*/
@property (nonatomic,assign) NSUInteger viewState;

@property (nonatomic,strong) MTBaseViewContentModel* baseContentModel;

@end

