//
//  UINavigationBar+Config.m
//  test
//
//  Created by monda on 2018/3/29.
//  Copyright © 2018年 monda. All rights reserved.
//

#import "UINavigationBar+Config.h"
#import "UIViewController+TransitionConfig.h"
#import "MTConst.h"
#import "objc/runtime.h"

@interface UINavigationController (Transition)

- (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;

@end

@implementation UINavigationBar (Config)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[4] = {
            @selector(layoutSubviews),
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

-(void)mt_layoutSubviews
{
    [self mt_layoutSubviews];

    self.shadowImage = [UIImage new];
    
    [self addSubview:self.bottomLine];
    [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
}

-(UIView *)bottomLine
{
    UIView* bottomLine = objc_getAssociatedObject(self, _cmd);
    
    if(!bottomLine)
    {
        bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth_mt(), 0.5)];
        bottomLine.backgroundColor = [UIColor clearColor];
        
        objc_setAssociatedObject(self, _cmd, bottomLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return bottomLine;
}

#pragma mark - 懒加载

-(void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
    objc_setAssociatedObject(self, @selector(backgroundAlpha), @(backgroundAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //必须要支持透明，否则不能设置透明度
    self.translucent = YES;
    //    self.globalAlpha = YES;
    
    UIView *barBackgroundView = self.subviews.firstObject;

    // sometimes we can't change _UIBarBackground alpha
    for (UIView *view in barBackgroundView.subviews)
        view.alpha = backgroundAlpha;
    
    self.bottomLine.alpha = backgroundAlpha;        
}

-(CGFloat)backgroundAlpha
{
    return ((NSNumber*)objc_getAssociatedObject(self, _cmd)).floatValue;
}

-(void)setGlobalAlpha:(BOOL)globalAlpha
{
    objc_setAssociatedObject(self, @selector(globalAlpha), @(globalAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //修改导航条背景图片
    [self setBackgroundImage:globalAlpha ? [UIImage new] : nil forBarMetrics:UIBarMetricsDefault];
}

-(BOOL)globalAlpha
{
    return ((NSNumber*)objc_getAssociatedObject(self, _cmd)).boolValue;
}

-(void)setIgnoreTranslucentBarTintColor:(UIColor *)ignoreTranslucentBarTintColor
{
    self.globalAlpha = (ignoreTranslucentBarTintColor != nil);
    self.backgroundView.backgroundColor = ignoreTranslucentBarTintColor;
}

-(UIColor *)ignoreTranslucentBarTintColor
{
    return self.backgroundView.backgroundColor;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, @selector(backgroundView), backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)backgroundView {
    
    UIView* view = (UIView *)objc_getAssociatedObject(self, _cmd);
    
    if(!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kNavigationBarHeight_mt())];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // _UIBarBackground is first subView for navigationBar
        self.backgroundView = view;
    }
    
    //    [self.subviews.firstObject insertSubview:view atIndex:0];
    return view;
}

- (void)updateForTitleColor:(UIColor *)titleColor {
    
    if(!titleColor)
        return;

    NSDictionary *titleTextAttributes = self.titleTextAttributes;
    if (titleTextAttributes == nil) {
        self.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
        return;
    }
    NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    self.titleTextAttributes = newTitleTextAttributes;
}

@end






