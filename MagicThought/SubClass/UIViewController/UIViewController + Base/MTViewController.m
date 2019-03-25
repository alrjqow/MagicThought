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

-(void)initProperty{}

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
    [MTCloud shareCloud].currentViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    [self setupTabBarItem];
    [self setupNavigationItem];
    [self initSubview];
    [self layoutSubView];
}


#pragma mark - 网络请求

-(void)whenRequestFail:(MTBaseDataModel *)model
{
    [super whenRequestFail:model];
    [self whenEndRefreshing:false Model:model];
}

#pragma mark - 重载方法

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

- (void)initSubview{}

- (void)layoutSubView{}

/**加载数据*/
-(void)loadData{}

/**请求数据*/
-(void)startRequest{}

/**接收到通知后*/
-(void)afterReceiveNotification:(NSNotification *)info{}

-(void)whenEndRefreshing:(BOOL)isSuccess Model:(MTBaseDataModel *)model
{
    [self.view dismissIndicator];
}

#pragma mark - 点击事件


#pragma mark - 成员方法

-(void)clearTableViewDelegate
{
    self.mtBase_tableView.delegate = nil;
    self.mtBase_tableView.dataSource = nil;
}

#pragma mark - WKScriptMessageHandler代理

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    id scriptDelegate = [[MTCloud shareCloud] objectForKey:self];
    
    if([scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
        [scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

#pragma mark - 代理与数据源

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (id)copyWithZone:(NSZone *)zone{    
    return self;
}

#pragma mark - 懒加载

- (MTDelegateTableView *)mtBase_tableView
{
    if (_mtBase_tableView == nil) {
                
        _mtBase_tableView = [[MTDelegateTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mtBase_tableView.delegate = self;
        _mtBase_tableView.dataSource = self;
        _mtBase_tableView.backgroundColor = [UIColor clearColor];
        _mtBase_tableView.tableFooterView = [UIView new];
        _mtBase_tableView.showsVerticalScrollIndicator = false;
        _mtBase_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mtBase_tableView;
}

-(NSDictionary *)emptyData
{
    if(!_emptyData)
    {
        _emptyData = @{};
    }
    
    return _emptyData;
}

@end
