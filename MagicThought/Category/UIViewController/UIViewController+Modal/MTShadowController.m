//
//  MTShadowController.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/25.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTShadowController.h"

@interface MTShadowController ()

@end

@implementation MTShadowController

-(void)loadView
{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//    view.userInteractionEnabled = YES;
    
    
    
//    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
//    view1.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:view1];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    
    
    if([view.superview isKindOfClass:NSClassFromString(@"UITransitionView")])
        [self.presentedViewController dismissViewControllerAnimated:false completion:nil];
}

@end
