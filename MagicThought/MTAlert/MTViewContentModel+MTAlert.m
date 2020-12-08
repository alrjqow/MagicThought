//
//  MTViewContentModel+MTAlert.m
//  QXProject
//
//  Created by monda on 2020/12/1.
//  Copyright © 2020 monda. All rights reserved.
//

#import "MTViewContentModel+MTAlert.h"
#import "MTWindow.h"
#import "MTConst.h"
#import "UIView+Frame.h"
#import "UIView+MTBackground.h"
#import "UIView+Delegate.h"
#import "NSObject+ReuseIdentifier.h"

#import <MJExtension.h>

@implementation NSObject (MTAlert)

-(void (^)(id))alertViewWithObject
{
    __weak __typeof(self) weakSelf = self;
    void (^alert)(id object) = ^(id object){
        
        [weakSelf setAlertViewWithObject:object];
    };
    
    return alert;
}

-(void)setAlertViewWithObject:(NSObject*)object
{
    NSArray* array = (NSArray*)object;
    if(![array isKindOfClass:[NSArray class]])
        return;
    
    MTAlertConfig* config;
    for (NSObject* subObject in array) {
        if([subObject isKindOfClass:[MTAlertConfig class]])
            config = (MTAlertConfig*)subObject;
    }
    
    if(!config)
        config = MTAlertConfig.new;
    [self AlertView:config];
}

-(void)AlertView:(MTAlertConfig*)config
{
    NSString* mt_reuseIdentifier = self.mt_reuseIdentifier;
    if(!mt_reuseIdentifier && [self isKindOfClass:[NSString class]])
        mt_reuseIdentifier = (NSString*)self;
    
    Class c = NSClassFromString(mt_reuseIdentifier);
    if(![c isSubclassOfClass:[UIView class]])
        return;
    
    UIView* view = c.new;
    NSObject* obj = self;
    
    
    if(![self isKindOfClass:view.classOfResponseObject])
    {
        if([self isKindOfClass:[NSDictionary class]] && [view.classOfResponseObject isSubclassOfClass:[NSObject class]])
        {
            NSObject* model = [view.classOfResponseObject mj_objectWithKeyValues:self];
            if(!model)
                return;
            
            obj = [model copyBindWithObject: self];
            [self resetMtclickWithObject:obj View:view Config:config];
            [view whenGetResponseObject:obj];
        }
        else if([self isKindOfClass:[NSString class]])
            [self bindMtclickWithObject:self View:view Config:config];
        else
            return;
    }
    else
    {
        [self resetMtclickWithObject:obj View:view Config:config];
        [view whenGetResponseObject:obj];
    }
    
    [self showView:view Config:config];
}

-(void)resetMtclickWithObject:(NSObject*)obj View:(UIView*)view Config:(MTAlertConfig*)config
{
    MTClick mtClick = obj.mt_click;
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(view) weakView = view;
    __weak __typeof(config) weakConfig = config;
    obj.bindClick(^(NSObject* data) {
        
        [weakSelf hideView:weakView Config:weakConfig];
        if(mtClick)
            mtClick(data);
    });
}

-(void)bindMtclickWithObject:(NSObject*)obj View:(UIView*)view Config:(MTAlertConfig*)config
{
    MTClick mtClick = obj.mt_click;
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(view) weakView = view;
    __weak __typeof(config) weakConfig = config;
    view.bindClick(^(NSObject* data) {
        
        [weakSelf hideView:weakView Config:weakConfig];
        if(mtClick)
            mtClick(data);
    });
}

-(void)showView:(UIView*)view Config:(MTAlertConfig*)config
{
    UIView* attachView = [MTWindow sharedWindow].attachView;
    [attachView showBackground];
    attachView.mt_BackgroundView.backgroundColor = rgba(0, 0, 0, config.configBackgroundViewAlpha);
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(view) weakView = view;
    __weak __typeof(config) weakConfig = config;
    attachView.mt_BackgroundView.bindClick(^(UITapGestureRecognizer* tapGestureRecognizer) {
        CGPoint point = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
        point = [weakView.layer convertPoint:point fromLayer:tapGestureRecognizer.view.layer];
        if([weakView.layer containsPoint:point])
            return;
        
        if(weakConfig.configCanBackgroundViewTouchDismiss)
            [weakSelf hideView:weakView Config:weakConfig];
    });
    
    CGSize size = [view layoutSubviewsForWidth:attachView.width Height:attachView.height];
    view.bounds = CGRectMake(0, 0, size.width, size.height);
    view.center = attachView.mt_BackgroundView.center;
    view.layer.transform = CATransform3DMakeScale(0.6, 0.6, 0.6);
    view.alpha = 0;
    [attachView.mt_BackgroundView addSubview:view];
    
    
    [UIView animateWithDuration:config.configAnimationDuration
                          delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        view.layer.transform = CATransform3DIdentity;
        view.alpha = 1;
    } completion:nil];
}

- (void)hideView:(UIView*)view Config:(MTAlertConfig*)config
{
    UIView* attachView = [MTWindow sharedWindow].attachView;
    [attachView hideBackground];
    
    [UIView animateWithDuration:config.configAnimationDuration delay:0 options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        view.layer.transform = CATransform3DMakeScale(0.6, 0.6, 0.6);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (finished)
            [view removeFromSuperview];
    }];
}


-(void)a:(id)b,...
{
    va_list list;
    va_start(list, b);
    
    
    while (YES) {
        id obj = va_arg(list, id);
        
        if(!obj)
            break;
    }
    
    va_end(list);
}

@end

@implementation MTAlertConfig

-(instancetype)init
{
    if(self = [super init])
    {
        self.configAnimationDuration = 0.2;
        self.configBackgroundViewAlpha = 0.48;
    }
    
    return self;
}

MTAlertConfig* mt_AlertConfigMake(NSTimeInterval configAnimationDuration, CGFloat  configBackgroundViewAlpha, BOOL configCanBackgroundViewTouchDismiss)
{
    MTAlertConfig* config = [MTAlertConfig new];
    if(configAnimationDuration >= 0)
        config.configAnimationDuration = configAnimationDuration;
    if(configBackgroundViewAlpha >= 0)
        config.configBackgroundViewAlpha = configBackgroundViewAlpha;
    config.configCanBackgroundViewTouchDismiss = configCanBackgroundViewTouchDismiss;
    
    return config;
}

@end
