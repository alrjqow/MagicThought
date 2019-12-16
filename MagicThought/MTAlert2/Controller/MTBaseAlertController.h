//
//  MTBaseAlertController.h
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTBaseListController.h"
#import "UIView+MTBaseViewContentModel.h"

typedef NS_ENUM(NSInteger, MTBaseAlertType)
{
    MTBaseAlertTypeDefault,
    MTBaseAlertTypeUp,
};

@interface MTBaseAlertController : MTBaseListController

@property (nonatomic,assign) MTBaseAlertType type;

@property (nonatomic,strong) UIView* alertView;

@property (nonatomic,strong, readonly) UIView* blackView;

@property (nonatomic,assign) CGFloat animateTime;

/**用来弹出*/
-(void)alert;

/**用来消失*/
-(void)dismiss;



@end


