//
//  MTBaseAlertController.h
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTViewController.h"

typedef NS_ENUM(NSInteger, MTBaseAlertType)
{
    MTBaseAlertTypeDefault,
    MTBaseAlertTypeUp,
};

@interface MTBaseAlertController : MTViewController

@property (nonatomic,assign) MTBaseAlertType type;

@property (nonatomic,strong) UIView* alertView;

@property (nonatomic,strong, readonly) UIView* blackView;

@property (nonatomic,weak) UIViewController<MTDelegateProtocol>* modalController;

@property (nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@property (nonatomic,assign) CGFloat animateTime;

/**在此名单中, 执行 dismissWithEvent 会判断是否自动 dismiss,仅当点击某个alert选项时触发*/
@property (nonatomic,strong) NSDictionary* existEventList;

/**用来弹出*/
-(void)alert;

/**用来消失*/
-(void)dismiss;



@end


