//
//  MTBaseAlertController.m
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTBaseAlertController.h"

#import "MTConst.h"
#import "UIView+Frame.h"

@interface MTBaseAlertController ()

@property (nonatomic,assign) BOOL isDismiss;

@end

@implementation MTBaseAlertController

-(void)setupDefault
{
    [super setupDefault];
        
    self.view.backgroundColor = [UIColor clearColor];
    
    self.blackView.frame = self.view.bounds;
    self.blackView.backgroundColor = rgba(0, 0, 0, 0.3);
    self.blackView.alpha = self.type == MTBaseAlertTypeDefault;
    
    self.animateTime = 0.25;
    self.isDismiss = YES;
}

-(void)setupSubview
{
    [super setupSubview];
    
    [self.view addSubview:self.blackView];
    if(self.alertView)
    {
        if(self.type == MTBaseAlertTypeUp)
            self.alertView.y = self.view.height;
        [self.view addSubview:self.alertView];
    }
}


#pragma mark - 弹出

-(void)alert
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    switch (self.type) {
        case MTBaseAlertTypeUp:
        {
                [mt_rootViewController() presentViewController:self animated:false completion:^{
                    [UIView animateWithDuration:self.animateTime animations:^{
                        self.blackView.alpha = 1;
                        self.alertView.y = self.view.height - self.alertView.height;
                    }];
                }];            
            break;
        }
            
        default:
        {
            [mt_rootViewController()  presentViewController:self animated:YES completion:nil];
            break;
        }
    }
}

#pragma mark - 点击

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isVisible)
        return;
    
    if(self.type == MTBaseAlertTypeUp)
        [self dismiss];
}

#pragma mark - 消失

-(void)dismiss
{
    switch (self.type) {
        case MTBaseAlertTypeUp:
        {
            [self alertTypeUpDismiss];
            break;
        }
            
        default:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
    }
}

-(void)alertTypeUpDismiss
{
    [UIView animateWithDuration:self.animateTime animations:^{
        self.blackView.alpha = 0;
        self.alertView.y = self.view.height;
    } completion:^(BOOL finished) {
//        if(self.isDismiss)
            [self dismissViewControllerAnimated:false completion:nil];
        
        self.isDismiss = YES;
    }];
}

#pragma mark - 懒加载



#pragma mark - 生命周期

-(instancetype)init
{
    if(self = [super init])
    {
        _blackView = [UIView new];
    }
    
    return self;
}




@end
