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
#import "MTDelegateCollectionView.h"
#import "UIView+MBHud.h"
#import "NSObject+API.h"

@class MTBaseDataModel;
@class MTDelegateTableView;
@protocol MTDelegateProtocol;

@interface MTViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MTDelegateProtocol, WKScriptMessageHandler, NSCopying>

@property (nonatomic,copy) void (^block)(id);

@property (nonatomic,copy) BOOL (^gobackBlock)(void);

@property (nonatomic,strong) NSString* order;

/**判断视图的可见性*/
@property(nonatomic,assign) BOOL isVisible;

/**判断视图的是否已加载*/
@property (nonatomic,assign, readonly) BOOL isViewDidLoad;

/**是否第一次请求成功*/
@property (nonatomic,assign) BOOL isFirstRequestSuccess;

/**懒加载，默认不添加到父级*/
@property (nonatomic, strong) MTDelegateTableView *mtBase_tableView;
@property (nonatomic, strong) MTDelegateCollectionView *mtBase_collectionView;
@property (nonatomic, strong, readonly) UIScrollView *listView;

/**空数据*/
@property (nonatomic, strong) NSDictionary* emptyData;

/**结束刷新黑名单*/
@property (nonatomic,strong) NSDictionary* endRefreshBlackList;

/**想要pop到的Controller*/
@property (nonatomic,weak) UIViewController* popToController;

/**清除代理*/
-(void)clearTableViewDelegate;

/**返回页面*/
-(void)goBack;



@end
