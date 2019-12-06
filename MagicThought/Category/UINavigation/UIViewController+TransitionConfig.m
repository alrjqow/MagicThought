//
//  UIViewController+TransitionConfig.m
//  QXProject
//
//  Created by monda on 2019/12/6.
//  Copyright © 2019 monda. All rights reserved.
//

#import "UIViewController+TransitionConfig.h"
#import "UINavigationBar+Config.h"
#import "UIColor+ColorfulColor.h"
#import "objc/runtime.h"

@implementation UIViewController (TransitionConfig)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[4] = {
            @selector(viewWillAppear:),
            @selector(viewDidAppear:),
            @selector(dismissViewControllerAnimated:completion:)
            //            @selector(viewWillDisappear:),
            //            @selector(viewDidDisappear:)
        };
        
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"mt_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

-(void)mt_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if(self.enableDismiss)
        [self mt_dismissViewControllerAnimated:flag completion:completion];
    else
        self.enableDismiss = YES;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion EnableDismiss:(BOOL)enableDismiss
{
    self.enableDismiss = enableDismiss;
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)mt_viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar updateForTitleColor:[NSStringFromClass([self class]) containsString:@"TZ"] ? [UIColor whiteColor] : self.navigationBarTitleColor];
    
    [self mt_viewWillAppear:animated];
}


- (void)mt_viewDidAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.backgroundAlpha = self.navigationBarAlpha;
    [self mt_viewDidAppear:animated];
}



#pragma mark - 懒加载

-(void)setEnableSlideBack:(BOOL)enableSlideBack
{
    objc_setAssociatedObject(self, @selector(enableSlideBack), @(enableSlideBack), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)enableSlideBack
{
    id enableSlideBack = objc_getAssociatedObject(self, _cmd);
    if(!enableSlideBack)
        return YES;
    
    return [enableSlideBack boolValue];
}

-(void)setEnableDismiss:(BOOL)enableDismiss
{
    objc_setAssociatedObject(self, @selector(enableDismiss), @(enableDismiss), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)enableDismiss
{
    id enableDismiss = objc_getAssociatedObject(self, _cmd);
    if(!enableDismiss)
        return YES;
    
    return [enableDismiss boolValue];
}

// navigationBar _UIBarBackground alpha
-(void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha
{
    objc_setAssociatedObject(self, @selector(navigationBarAlpha), @(navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)navigationBarAlpha
{
    NSNumber* alpha= (NSNumber*)objc_getAssociatedObject(self, _cmd);
    return !alpha ? 1 : alpha.floatValue;
}

-(void)setIgnoreTranslucentBarTintColor:(UIColor *)ignoreTranslucentBarTintColor
{
    objc_setAssociatedObject(self, @selector(ignoreTranslucentBarTintColor), ignoreTranslucentBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)ignoreTranslucentBarTintColor
{
    static UIColor* defaultColor;
    if(!defaultColor)
        defaultColor = self.navigationController.navigationBar.ignoreTranslucentBarTintColor;
    
    UIColor* color= (UIColor*)objc_getAssociatedObject(self, _cmd);
    
    return color ? color : defaultColor;
}

-(void)setNavigationBarTitleColor:(UIColor *)navigationBarTitleColor
{
    objc_setAssociatedObject(self, @selector(navigationBarTitleColor), navigationBarTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.navigationController.navigationBar updateForTitleColor:navigationBarTitleColor];
}

-(UIColor *)navigationBarTitleColor
{
    static UIColor* defaultColor;
    if(!defaultColor)
        defaultColor = [self.navigationController.navigationBar.titleTextAttributes
                        objectForKey:NSForegroundColorAttributeName];
    
    UIColor* color =  objc_getAssociatedObject(self, _cmd);
    
    return color ? color : defaultColor;
}




- (void)changeDefaultColor:(UIColor*)defaultColor ToTitleColor:(UIColor *)titleColor Percent:(CGFloat)percent;
{
    self.navigationBarTitleColor = [UIColor middleColor:defaultColor toColor:titleColor percent:percent];
}

@end
