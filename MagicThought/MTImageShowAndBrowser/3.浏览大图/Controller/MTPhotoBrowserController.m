//
//  MTPhotoBrowserController.m
//  8kqw
//
//  Created by 王奕聪 on 2016/12/21.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import "MTPhotoBrowserController.h"
#import "MTPhotoBrowser.h"
#import "MTPhotoBrowserViewModel.h"

#import "MTCloud.h"

@interface MTPhotoBrowserController ()

@property (nonatomic,weak) MTPhotoBrowserViewModel* model;

@end

@implementation MTPhotoBrowserController


+(instancetype)photoBrowserControllerWithModel:(MTPhotoBrowserViewModel*)model;
{
    MTPhotoBrowserController* vc = [MTPhotoBrowserController new];
    vc.model = model;
    
    return vc;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:!self.model.isShowNavigationBar animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated:false];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self setValue:self.model.navigationBarColor forKey:@"ignoreTranslucentBarTintColor"];
        
    [MTPhotoBrowser shareBrowser].frame = self.view.bounds;
    [self.view addSubview:[MTPhotoBrowser shareBrowser]];
    
    [self.model reloadPhotoBrowser];
}

-(void)setupNavigationItem
{
    [self setValue:[UIColor whiteColor] forKey:@"navigationBarTitleColor"];
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
