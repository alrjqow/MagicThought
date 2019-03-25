//
//  MTViewController.h
//  8kqw
//
//  Created by 王奕聪 on 2017/3/28.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "MTDelegateTableView.h"
#import "UIView+MBHud.h"
#import "NSObject+API.h"

@class MTBaseDataModel;
@class MTDelegateTableView;
@protocol MTDelegateProtocol;

@interface MTViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MTDelegateProtocol, WKScriptMessageHandler, NSCopying>

@property (nonatomic,copy) void (^block)(id);

@property (nonatomic,copy) BOOL (^gobackBlock)(void);

@property (nonatomic,copy) void (^mj_Block)(void);

@property (nonatomic,strong) NSString* order;

/**判断视图的可见性*/
@property(nonatomic,assign) BOOL isVisible;

/**判断视图的是否已加载*/
@property (nonatomic,assign, readonly) BOOL isViewDidLoad;

/**是否第一次请求成功*/
@property (nonatomic,assign) BOOL isFirstRequestSuccess;

/**懒加载，默认不添加到父级*/
@property (nonatomic, strong) MTDelegateTableView *mtBase_tableView;

/**空数据*/
@property (nonatomic, strong) NSDictionary* emptyData;

/*-----------------------------------viewDidLoad-----------------------------------*/

/**初始化*/
-(void)initProperty;

/**初始化属性*/
-(void)setupDefault;

/**初始化tabBar的item*/
-(void)setupTabBarItem;

/**初始化导航栏item*/
-(void)setupNavigationItem;

- (void)initSubview;

- (void)layoutSubView;


/*-------------------------------------------------------------------------------*/



/*-----------------------------------成员方法-----------------------------------*/

/**清除代理*/
-(void)clearTableViewDelegate;

/*-------------------------------------------------------------------------------*/


/*-----------------------------------网络请求-----------------------------------*/

/**当结束刷新*/
-(void)whenEndRefreshing:(BOOL)isSuccess Model:(MTBaseDataModel*)model;

/**加载数据*/
-(void)loadData;

/**请求数据*/
-(void)startRequest;

/*-------------------------------------------------------------------------------*/



/*-----------------------------------接收到通知-----------------------------------*/

/**接收到通知后*/
-(void)afterReceiveNotification:(NSNotification *)info;

/*-------------------------------------------------------------------------------*/



/*-----------------------------------当销毁时-----------------------------------*/

-(void)whenDealloc;

/*----------------------------------------------------------------------------*/

@end
