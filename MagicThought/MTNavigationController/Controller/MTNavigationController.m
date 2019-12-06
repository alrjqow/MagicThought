//
//  MTNavigationController.m
//  DaYiProject
//
//  Created by monda on 2018/8/1.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTNavigationController.h"
#import "UINavigationBar+Config.h"

@interface MTNavigationController ()<UIGestureRecognizerDelegate>

/*-----------------------------------全屏侧屏滑动-----------------------------------*/

/*!用来保存系统自带侧滑返回代理 */
@property (nonatomic,strong) id<UIGestureRecognizerDelegate>  interactivePopGestureRecognizerDelegate;

/*!用来保存系统全屏滑动手势*/
@property (nonatomic,strong) UIPanGestureRecognizer*  fullScreenPopGestureRecognizer;

@end

@implementation MTNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDefault];
}

-(void)setupDefault
{
    [super setupDefault];
    
    if(!self.navigationBar.ignoreTranslucentBarTintColor)
        self.navigationBar.ignoreTranslucentBarTintColor = [UIColor whiteColor];
    self.navigationBar.bottomLine.backgroundColor = [UIColor blackColor];
    
    self.delegate = self;
}

#pragma mark - 成员方法

-(void)back
{
    if([self.topViewController isKindOfClass:NSClassFromString(@"MTViewController")])
    {
        [self.topViewController performSelector:@selector(goBack)];
        return;
    }
        
    if (self.presentingViewController && self.viewControllers.count == 1)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self popViewControllerAnimated:YES];
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
    self.interactivePopGestureRecognizer.enabled = (delegate == self && !self.isFullScreenPop && self.enableSlideBack);
    self.fullScreenPopGestureRecognizer.enabled = (delegate == self && self.isFullScreenPop);
    [super setDelegate:delegate];
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
    if (self.viewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count > 0)
    {        
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(navigationController.viewControllers.count < 2)
        self.interactivePopGestureRecognizer.delegate = self.interactivePopGestureRecognizerDelegate;
}


@end
