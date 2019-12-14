//
//  MTViewController.m
//  8kqw
//
//  Created by 王奕聪 on 2017/3/28.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTViewController.h"
#import "MBProgressHUD.h"
#import "MTCloud.h"
#import "MJRefresh.h"

#import "MTBaseDataModel.h"
#import "UIViewController+Navigation.h"

@interface MTViewController ()

@end

@implementation MTViewController


#pragma mark - 生命周期

-(instancetype)init
{
    if(self = [super init])
    {
        [self initProperty];
    }
    
    return self;
}

-(void)dealloc
{
    [self whenDealloc];
}

/*当销毁时*/
-(void)whenDealloc{}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.isVisible = YES;
    [self.view bringSubviewToFront:[MBProgressHUD HUDForView:self.view]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isVisible = false;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self.view.superview isKindOfClass:NSClassFromString(@"MTTenScrollContentCell")])
        return;
    if([self isKindOfClass:NSClassFromString(@"MTBaseAlertController")])
        return;
    if([self isKindOfClass:NSClassFromString(@"MTPhotoBrowserController")])
        return;
    
    [MTCloud shareCloud].currentViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    [self setupTabBarItem];
    [self setupNavigationItem];
    [self setupSubview];
}


#pragma mark - 网络请求

- (void)whenRequestFail:(MTBaseDataModel *)model
{
    [super whenRequestFail:model];
    [self whenEndRefreshing:false Model:model];
}

#pragma mark - 重载方法

-(void)initProperty{}

/**初始化属性*/
-(void)setupDefault
{
    _isViewDidLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

/**初始化tabBar的item*/
-(void)setupTabBarItem{}

/**初始化导航栏item*/
-(void)setupNavigationItem{}

- (void)setupSubview{}

-(void)navigationBarRightBtnClick{}

/**加载数据*/
-(void)loadData{}

/**请求数据*/
-(void)startRequest{}

/**接收到通知后*/
-(void)whenReceiveNotification:(NSNotification *)info{}

-(void)whenEndRefreshing:(BOOL)isSuccess Model:(MTBaseDataModel *)model
{
    if(isSuccess)
    {
        if([self.endRefreshBlackList objectForKey:model.url])
            return;
        [self.view dismissIndicator];
    }
    else
        [self.view showToast:model.msg];
}

#pragma mark - 点击事件


#pragma mark - 成员方法

-(void)goBack
{
    if (self.presentingViewController)
        [self dismissViewControllerAnimated:YES completion:nil];
    else if (self.navigationController.presentingViewController && self.navigationController.viewControllers.count == 1)
        [self dismissViewControllerAnimated:YES completion:nil];
    else if(self.popToController)
        [self.navigationController popToViewController:self.popToController animated:YES];
    else
        [self popWithAnimate];
}

#pragma mark - WKScriptMessageHandler代理

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    id scriptDelegate = [[MTCloud shareCloud] objectForKey:self];
    
    if([scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
        [scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}


#pragma mark - 懒加载

-(NSDictionary *)endRefreshBlackList
{
    if(!_endRefreshBlackList)
    {
        _endRefreshBlackList = @{};
    }
    
    return _endRefreshBlackList;
}

@end
