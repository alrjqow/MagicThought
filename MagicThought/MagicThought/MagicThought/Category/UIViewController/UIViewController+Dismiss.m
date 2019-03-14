//
//  UIViewController+Dismiss.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/27.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIViewController+Dismiss.h"
#import <objc/runtime.h>
#import "MTCloud.h"

@implementation UIViewController (Dismiss)

//+(void)load
//{    
//    /** 获取原始setBackgroundColor方法 */
//    Method originalM = class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:));
//    
//    /** 获取自定义的pb_setBackgroundColor方法 */
//    Method exchangeM = class_getInstanceMethod([self class], @selector(mt_dismissViewControllerAnimated:completion:));
//    
//    /** 交换方法 */
//    method_exchangeImplementations(originalM, exchangeM);
//}
//
//- (void)mt_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion
//{
//    [self mt_dismissViewControllerAnimated:flag completion:completion];
//    
//    if([self.presentingViewController isKindOfClass:NSClassFromString(@"MTShadowController")])
//        [self.presentingViewController mt_dismissViewControllerAnimated:false completion:nil];    
//}

@end


@implementation UIViewController (Navigation)

-(void)push
{
    [[MTCloud shareCloud].currentViewController.navigationController pushViewController:self animated:false];
}
-(void)pushWithAnimate
{
    [[MTCloud shareCloud].currentViewController.navigationController pushViewController:self animated:YES];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:false];
}
-(void)popWithAnimate
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popToRoot
{
    [[MTCloud shareCloud].currentViewController.navigationController popToRootViewControllerAnimated:false];
}
-(void)popToRootWithAnimate
{
    [[MTCloud shareCloud].currentViewController.navigationController popToRootViewControllerAnimated:YES];
}

@end
