//
//  UIViewController+Dismiss.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/27.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Dismiss)


@end

@interface UIViewController (Navigation)

-(void)push;
-(void)pushWithAnimate;

-(void)pop;
-(void)popWithAnimate;

-(void)popToRoot;
-(void)popToRootWithAnimate;

@end
