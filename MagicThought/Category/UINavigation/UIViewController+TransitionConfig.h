//
//  UIViewController+TransitionConfig.h
//  QXProject
//
//  Created by monda on 2019/12/6.
//  Copyright © 2019 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TransitionConfig)

/*是否可侧滑返回*/
@property (nonatomic,assign) BOOL enableSlideBack;

/*是否可 Dismiss*/
@property (nonatomic,assign) BOOL enableDismiss;

/**设置导航栏标题属性*/
@property (nonatomic,strong) UIColor* navigationBarTitleColor;

/**设置导航栏透明度*/
@property (nonatomic,assign) CGFloat navigationBarAlpha;

/**设置导航栏背景色*/
@property (nonatomic,strong) UIColor* ignoreTranslucentBarTintColor;

/**更新标题颜色*/
- (void)changeDefaultColor:(UIColor*)defaultColor ToTitleColor:(UIColor *)titleColor Percent:(CGFloat)percent;

/**在 modal 出控制器后，dismiss modal的控制器时是否同时 dismsiss 自己*/
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion EnableDismiss:(BOOL)enableDismiss;

@end


