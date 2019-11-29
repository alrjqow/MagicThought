//
//  MTAppDelegate.h
//  QXProject
//
//  Created by monda on 2019/11/29.
//  Copyright © 2019 monda. All rights reserved.
//

#import "NSObject+CommonProtocol.h"

@interface MTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly, strong) UIViewController* rootViewController;

/**重写 rootViewController, 改变 windowNum 值实现窗口切换*/
@property (nonatomic,assign) NSInteger windowNum;

//设置第三方库信息
- (void)configThirdPartyLibrary;

  //配置网路请求
- (void)configNetwork;

/**去登录*/
-(void)goToLogin;

+ (instancetype)sharedDefault;

@end

#define AppDelegate_mt [MTAppDelegate sharedDefault]
