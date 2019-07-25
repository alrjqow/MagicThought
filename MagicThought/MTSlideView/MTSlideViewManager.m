//
//  MTSlideViewManager.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/6.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTSlideViewManager.h"
#import "MTSlideHeader.h"
#import "MTSlideView.h"
#import "UIView+ViewController.h"
#import "UIView+Frame.h"


@implementation MTSlideViewManager




+ (void)associateHead:(MTSlideHeader *)head
           withScroll:(MTSlideView *)scroll
           completion:(void(^)())completion {
    [self associateHead:head withScroll:scroll contentChangeAni:YES completion:completion selectEnd:nil];
}


+ (void)associateHead:(MTSlideHeader *)head
           withScroll:(MTSlideView *)scroll
     contentChangeAni:(BOOL)ani
           completion:(void(^)())completion
            selectEnd:(void(^)(NSInteger index))selectEnd {
    
    NSInteger showIndex;
    showIndex = head.showIndex?head.showIndex:scroll.showIndex;
    head.showIndex = scroll.showIndex = showIndex;
    
    head.selectedIndex = ^(NSInteger index) {
        [scroll setContentOffset:CGPointMake(index*scroll.width, 0) animated:ani];
    };
    [head defaultAndCreateView];
    head.delegate = scroll;
    
    scroll.scrollEnd = ^(NSInteger index) {
        [head setSelectIndex:index];
        //在点击之后调用
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.animationEnd = ^(NSInteger index) {
        //在动画结束后调用
        [head animationEnd];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.offsetScale = ^(CGFloat scale) {
        [head changePointScale:scale];
    };
    
    if (completion) {
        completion();
    }
    [scroll createView];
    
    UIView *view = head.nextResponder?head:scroll;
    UIViewController *currentVC = [view viewController];
    currentVC.automaticallyAdjustsScrollViewInsets = NO;
}

@end
