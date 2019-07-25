//
//  UIView+Shadow.m
//  MyTool
//
//  Created by 王奕聪 on 2017/3/2.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIView+Shadow.h"
#import "MTViewModel.h"
#import "MTConst.h"
#import <objc/runtime.h>

@interface UIView ()

@property(nonatomic,weak) UIView* shadowView;

@property(nonatomic,strong) NSMutableArray<MTViewModel*>* shadowSubview;

@end

@implementation UIView (Shadow)

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTShadowHideNotification  object:nil];
//}

-(void)addSubviewInShadow:(UIView *)view Action:(SEL)action
{
    if(!self.shadowView)
    {
        UIView* view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        view.hidden = YES;        
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [self addSubview:view];
        self.shadowView = view;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openShadow:) name:MTShadowHideNotification object:nil];
    }
    
    if(!self.shadowSubview)
        self.shadowSubview = [NSMutableArray array];

    if(action)
        [self.shadowSubview addObject:[MTViewModel modelWithView:view Sel:NSStringFromSelector(action)]];

        
    [self addSubview:view];
}

-(void)tap:(UITapGestureRecognizer*)tap
{
    [self openShadow:@{@"obj":@(MAXFLOAT)}];
}

-(void)openShadow:(id)obj
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = false;
    id object;
    if([obj isKindOfClass:[NSNotification class]])
        object = ((NSNotification*)obj).userInfo[@"obj"];
    else
        object = obj[@"obj"];
    
    __weak typeof (self) weakSelf = self;
    static BOOL hidden;
    [UIView animateWithDuration:0.1 animations:^{
        if(weakSelf.shadowView.hidden)
        {
            weakSelf.shadowView.hidden = false;
            weakSelf.shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        }else
        {
            hidden = YES;
            weakSelf.shadowView.backgroundColor =  [UIColor colorWithWhite:0 alpha:0];
        }
       
    } completion:^(BOOL finished) {
        if(hidden)
        {
            weakSelf.shadowView.hidden = YES;
            hidden = false;
        }
    }];
    
    for(MTViewModel* model in self.shadowSubview)
        [model.view performSelector:NSSelectorFromString(model.sel) withObject:object];
}



static const void* kShadowView = "shadowView";
static const void* kShadowSubview = "shadowSubview";

-(void)setShadowSubview:(NSMutableArray<UIView *> *)shadowSubview
{
    objc_setAssociatedObject(self, kShadowSubview, shadowSubview, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray<UIView *> *)shadowSubview
{
    return objc_getAssociatedObject(self, kShadowSubview);
}

-(void)setShadowView:(UIView *)shadowView
{
    objc_setAssociatedObject(self, kShadowView, shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)shadowView
{
    return objc_getAssociatedObject(self, kShadowView);
}

@end
