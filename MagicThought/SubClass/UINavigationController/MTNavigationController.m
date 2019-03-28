//
//  MTNavigationController.m
//  DaYiProject
//
//  Created by monda on 2018/8/1.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTNavigationController.h"

/**转场*/
#import "UIViewControllerTransitionModel.h"
#import "MTInteractiveNavigationDelegate.h"

#import "MTDelegateProtocol.h"
#import "UINavigationBar+Config.h"
#import "UIDevice+DeviceInfo.h"
#import "UIView+Frame.h"

@interface MTNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView * statusBar;

@property (nonatomic, weak) UIView * statusBarSuperView;

@property (nonatomic,assign) BOOL isShow;

/*-----------------------------------全屏侧屏滑动-----------------------------------*/

/*!用来保存系统自带侧滑返回代理 */
@property (nonatomic,strong) id<UIGestureRecognizerDelegate>  interactivePopGestureRecognizerDelegate;

/*!用来保存系统全屏滑动手势*/
@property (nonatomic,strong) UIPanGestureRecognizer*  fullScreenPopGestureRecognizer;


/**转场*/
@property (nonatomic,strong) MTInteractiveNavigationDelegate* interactiveDelegate;

@end

@implementation MTNavigationController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self addStatusBarToDefault:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addStatusBarToDefault:false];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!self.navigationBar.ignoreTranslucentBarTintColor)
        self.navigationBar.ignoreTranslucentBarTintColor = [UIColor whiteColor];
    self.navigationBar.bottomLine.backgroundColor = [UIColor blackColor];
    
    self.delegate = self;
}

#pragma mark - 成员方法

-(void)back
{
    [self popViewControllerAnimated:YES];
}

-(void)addStatusBarToDefault:(BOOL)isDefault
{
    if(!self.setupStatusBar)
        return;
    if(isDefault)
    {
        self.statusBar.y = 0;
        [self.statusBarSuperView addSubview:self.statusBar];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
        
        return;
    }
    
    self.statusBar.y = [UIDevice isHairScreen] ? -44 : -20;
    [self.navigationBar addSubview:self.statusBar];
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count > 0)
    {
        self.isShow = YES;
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    [self configPushTransitionWithViewController:viewController];
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - 配置转场

-(void)configPushTransitionWithViewController:(UIViewController*)viewController
{
    if(!viewController.mt_transitionModel.pushTransition && !viewController.mt_transitionModel.popTransition)
    {
        self.delegate = self;
        if(viewController.mt_transitionModel)
            self.isFullScreenPop = viewController.mt_transitionModel.edges == UIRectEdgeNone;
    }
    else
    {
        self.delegate = (!viewController.mt_transitionModel.pushTransition && viewController.mt_transitionModel.popTransition) ? self : self.interactiveDelegate;
        [self.interactiveDelegate addPanGestureRecognizerWithController:viewController];
    }
}



#pragma mark - 初始化

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if(self = [super initWithRootViewController:rootViewController])
    {
        self.interactivePopGestureRecognizerDelegate = self.interactivePopGestureRecognizer.delegate;
        [self.view addGestureRecognizer:self.fullScreenPopGestureRecognizer];
    }
    return self;
}

#pragma mark - 懒加载

-(void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    self.interactivePopGestureRecognizer.enabled = (delegate == self && !self.isFullScreenPop);
    self.fullScreenPopGestureRecognizer.enabled = (delegate == self && self.isFullScreenPop);
    [super setDelegate:delegate];
}

-(MTInteractiveNavigationDelegate *)interactiveDelegate
{
    if(!_interactiveDelegate)
    {
        _interactiveDelegate = [MTInteractiveNavigationDelegate new];
        _interactiveDelegate.navigationController = self;
    }
    
    return _interactiveDelegate;
}

-(void)setSetupStatusBar:(BOOL)setupStatusBar
{
    _setupStatusBar = setupStatusBar;
    
    if(!setupStatusBar)
        return;
    
    // 将状态栏添加到自定义的导航栏上
    self.statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    self.statusBarSuperView = self.statusBar.superview;
}

-(void)setIsFullScreenPop:(BOOL)isFullScreenPop
{
    _isFullScreenPop = isFullScreenPop;
    
    self.interactivePopGestureRecognizer.enabled = !isFullScreenPop;
    self.fullScreenPopGestureRecognizer.enabled = isFullScreenPop;
}

-(UIPanGestureRecognizer *)fullScreenPopGestureRecognizer
{
    if(!_fullScreenPopGestureRecognizer)
    {
        _fullScreenPopGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizerDelegate action:@selector(handleNavigationTransition:)];
        _fullScreenPopGestureRecognizer.delegate = self;
        _fullScreenPopGestureRecognizer.enabled = false;
    }
    
    return _fullScreenPopGestureRecognizer;
}


#pragma mark - 手势代理

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}


#pragma mark - 代理


-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(navigationController.childViewControllers.count < 2)
        self.interactivePopGestureRecognizer.delegate = self.interactivePopGestureRecognizerDelegate;
    
    
    [self configPushTransitionWithViewController:viewController];
    if(!viewController.mt_transitionModel.pushTransition && viewController.mt_transitionModel.popTransition)
        self.delegate = self.interactiveDelegate;
    else if(self.visibleViewController.mt_transitionModel.pushTransition && !self.visibleViewController.mt_transitionModel.popTransition)
    {
        self.delegate = self;
        self.isFullScreenPop = false;
        viewController.mt_transitionGestureRecognizer.enabled = false;
    }
    
    if(self.isShow && viewController == self.childViewControllers[0])
    {
        self.isShow = false;
        
        if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        {
            [self.mt_delegate doSomeThingForMe:self withOrder:@"MTNavigationControllerDidShowRootViewControllerOrder"];
            return;
        }
    }
    
    
    if([viewController isKindOfClass:NSClassFromString(@"PhotoDetailController")] || [viewController isKindOfClass:NSClassFromString(@"MTPhotoBrowserController")])
    {
        if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        {
            [self.mt_delegate doSomeThingForMe:self withOrder:@"MTNavigationControllerDidShowPhotoBrowserControllerOrder"];
            return;
        }
    }
}


@end
