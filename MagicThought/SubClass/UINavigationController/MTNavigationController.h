//
//  MTNavigationController.h
//  DaYiProject
//
//  Created by monda on 2018/8/1.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MTDelegateProtocol;

@interface MTNavigationController : UINavigationController<UINavigationControllerDelegate>

/*-----------------------------------代理模式-----------------------------------*/

@property (nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@property (nonatomic,strong) NSString* order;

-(void)back;

/*-----------------------------------状态栏变更，图片浏览用-----------------------------------*/

@property (nonatomic,assign) BOOL setupStatusBar;

-(void)addStatusBarToDefault:(BOOL)isDefault;


/*-----------------------------------全屏侧屏滑-----------------------------------*/

/*!该属性用于设置侧滑还是全屏滑，默认全屏滑*/
@property(nonatomic,assign) BOOL isFullScreenPop;


@end


