//
//  MTBaseAlertController.m
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTBaseAlertController.h"

#import "MTDefine.h"
#import "MTConst.h"

#import "MTCloud.h"

#import "MTGraphicType.h"

#import "UIColor+ColorfulColor.h"
#import "UIView+Frame.h"


@interface MTBaseAlertController ()

@property (nonatomic,assign) BOOL isDismiss;

@end

@implementation MTBaseAlertController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.modalController)
        [MTCloud shareCloud].currentViewController = self.modalController;
}

-(void)setupDefault
{
    [super setupDefault];
        
    self.view.backgroundColor = [UIColor clearColor];
    
    self.blackView.frame = self.view.bounds;
    self.blackView.backgroundColor = rgba(0, 0, 0, 0.3);
    self.blackView.alpha = self.type == MTGraphicTypeDefault;
    
    self.animateTime = 0.25;
    self.isDismiss = YES;
}

-(void)initSubview
{
    [super initSubview];
    
    [self.view addSubview:self.blackView];
    if(self.alertView)
        [self.view addSubview:self.alertView];
}

-(void)layoutSubView
{
    [super layoutSubView];
    
    if(self.type == MTBaseAlertTypeUp)
        self.alertView.y = self.view.height;
}


#pragma mark - 弹出

-(void)alert
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    switch (self.type) {
        case MTBaseAlertTypeUp:
        {
                [self.modalController.navigationController presentViewController:self animated:false completion:^{
                    [UIView animateWithDuration:self.animateTime animations:^{
                        self.blackView.alpha = 1;
                        self.alertView.y = self.view.height - self.alertView.height;
                    }];
                }];            
            break;
        }
            
        default:
        {
            [self.modalController ? self.modalController : mt_rootViewController()  presentViewController:self animated:YES completion:nil];
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
            [self animateDismiss];
            break;
        }
                        
        default:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }            
    }
}

-(void)isDismissWithEvent:(NSString*)eventOrder
{
    self.isDismiss = [self.existAfterEvent objectForKey:eventOrder] == nil;
    [self dismiss];
}

-(void)animateDismiss
{
    [UIView animateWithDuration:self.animateTime animations:^{
        self.blackView.alpha = 0;
        self.alertView.y = self.view.height;
    } completion:^(BOOL finished) {
        if(self.isDismiss)
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
