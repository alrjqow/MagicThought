//
//  UINavigationController+TransitionConfig.m
//  QXProject
//
//  Created by monda on 2019/12/6.
//  Copyright © 2019 monda. All rights reserved.
//

#import "UINavigationController+TransitionConfig.h"
#import "UIViewController+TransitionConfig.h"
#import "UINavigationBar+Config.h"
#import "UIColor+ColorfulColor.h"
#import "objc/runtime.h"

@implementation UINavigationController (TransitionConfig)

static CGFloat mtPopDuration = 0.12;
static int mtPushDisplayCount = 0;

- (CGFloat)mtPopProgress {
    CGFloat all = 60 * mtPopDuration;
    int current = MIN(all, mtPushDisplayCount);
    return current / all;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL needSwizzleSelectors[4] = {
            NSSelectorFromString(@"_updateInteractiveTransition:"),
            @selector(popToViewController:animated:),
            @selector(popToRootViewControllerAnimated:),
            @selector(pushViewController:animated:)
        };
        
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [[NSString stringWithFormat:@"mt_%@", NSStringFromSelector(selector)] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)mt_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(![self isKindOfClass:NSClassFromString(@"MTNavigationController")] || [NSStringFromClass([self class]) containsString:@"TZ"])
    {
        [self mt_pushViewController:viewController animated:animated];
        return;
    }
    
    self.enableSlideBack = viewController.enableSlideBack;
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(transitionNeedDisplay:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        mtPushDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:mtPopDuration];
    [CATransaction begin];
    [self mt_pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (NSArray<UIViewController *> *)mt_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(![self isKindOfClass:NSClassFromString(@"MTNavigationController")])
        return [self mt_popToViewController:viewController animated:animated];
    
    self.enableSlideBack = viewController.enableSlideBack;
    // pop 的时候直接改变 barTintColor、tintColor
        
    if(![NSStringFromClass([self class]) containsString:@"TZ"])
    {
        [self.navigationBar updateForTitleColor:viewController.navigationBarTitleColor];
        self.navigationBar.ignoreTranslucentBarTintColor = viewController.ignoreTranslucentBarTintColor;
    }
    
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(transitionNeedDisplay:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        mtPushDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:mtPopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self mt_popToViewController:viewController animated:animated];
    [CATransaction commit];
    return vcs;
}

- (NSArray<UIViewController *> *)mt_popToRootViewControllerAnimated:(BOOL)animated {
    
    if(![self isKindOfClass:NSClassFromString(@"MTNavigationController")])
        return [self mt_popToRootViewControllerAnimated:animated];
    
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(transitionNeedDisplay:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        mtPushDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:mtPopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self mt_popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return vcs;
}

// change navigationBar barTintColor smooth before push to current VC finished or before pop to current VC finished
- (void)transitionNeedDisplay:(CADisplayLink*)displayLink {
    
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        mtPushDisplayCount += 1;
        CGFloat popProgress = [self mtPopProgress];
        UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:popProgress];
    }
    else
    {
        [displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - 手势返回

- (void)mt_updateInteractiveTransition:(CGFloat)percentComplete {
    
    if(![self isKindOfClass:NSClassFromString(@"MTNavigationController")])
        return;
    
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:percentComplete];
        
    [self mt_updateInteractiveTransition:percentComplete];
}

- (void)updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress
{
    if([fromVC isKindOfClass:[UITabBarController class]] || [fromVC isKindOfClass:[UINavigationController class]])
        return;
    
    if([NSStringFromClass([fromVC class]) containsString:@"TZ"])
        return;
    
    
    // change navBarTintColor
    self.navigationBar.ignoreTranslucentBarTintColor = [UIColor middleColor:fromVC.ignoreTranslucentBarTintColor toColor:toVC.ignoreTranslucentBarTintColor percent:progress];
    
    // change navBar _UIBarBackground alpha
    self.navigationBar.backgroundAlpha = [UIColor middleAlpha: fromVC.navigationBarAlpha toAlpha :toVC.navigationBarAlpha percent:progress];
}

#pragma mark - 自定义转场

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive] == YES) {
        
        if (@available(iOS 10.0, *)) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}

// deal the gesture of return break off
- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIViewController *vc = [context viewControllerForKey:key];
        
        self.navigationBar.backgroundAlpha = vc.navigationBarAlpha;
    };
    
    // after that, cancel the gesture of return
    if ([context isCancelled] == YES) {
        double cancelDuration = 0;
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    } else {
        // after that, finish the gesture of return
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}


#pragma mark - 隐藏与显示

/**隐藏*/
-(void)navigationBarHide{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    kfa.values = @[@(0), @(-20)];
    kfa.duration = 0.25;
    kfa.removedOnCompletion = false;
    kfa.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *kfa2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    kfa2.values = @[@(1),@(0)];
    kfa2.duration = 0.32;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[kfa, kfa2];
    //保留动画执行完的状态
    group.removedOnCompletion = false;
    group.fillMode = kCAFillModeForwards;
    //时长
    group.duration = 0.32;
    
    
    self.navigationBar.tag = -1;
    [self.navigationBar.layer addAnimation:group forKey:@"navigationBarHide"];
    [self.navigationBar.layer removeAnimationForKey:@"navigationBarShow"];
    
    self.view.userInteractionEnabled = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
        self.view.userInteractionEnabled = YES;
    });
}

/**显示*/
-(void)navigationBarShow{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    kfa.values = @[@(-20), @(0)];
    kfa.removedOnCompletion = false;
    kfa.fillMode = kCAFillModeForwards;
    kfa.duration = 0.25;
    
    CAKeyframeAnimation *kfa2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    kfa2.values = @[@(0), @(1)];
    kfa2.duration = 0.32;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[kfa, kfa2];
    //保留动画执行完的状态
    group.removedOnCompletion = false;
    group.fillMode = kCAFillModeForwards;
    //时长
    group.duration = 0.32;
    
    self.navigationBar.tag = 0;
    [self.navigationBar.layer addAnimation:group forKey:@"navigationBarShow"];
    [self.navigationBar.layer removeAnimationForKey:@"navigationBarHide"];
    
    self.view.userInteractionEnabled = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.view.userInteractionEnabled = YES;
    });
}

#pragma mark - 懒加载

-(void)setEnableSlideBack:(BOOL)enableSlideBack
{
    self.interactivePopGestureRecognizer.enabled = enableSlideBack;
}

-(BOOL)enableSlideBack
{
    return self.interactivePopGestureRecognizer.enabled;
}

@end
