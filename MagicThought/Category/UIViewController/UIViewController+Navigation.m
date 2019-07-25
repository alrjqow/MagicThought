//
//  UIViewController+Navigation.m
//  MDKit
//
//  Created by monda on 2019/5/27.
//  Copyright © 2019 monda. All rights reserved.
//

#import "UIViewController+Navigation.h"
#import "MTCloud.h"

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
