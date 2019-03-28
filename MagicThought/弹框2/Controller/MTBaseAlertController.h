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

@property (nonatomic,strong) NSDictionary* existAfterEvent;

/**用来弹出*/
-(void)alert;

/**用来消失*/
-(void)dismiss;

/**是否自动dismiss*/
-(void)isDismissWithEvent:(NSString*)eventOrder;

@end


