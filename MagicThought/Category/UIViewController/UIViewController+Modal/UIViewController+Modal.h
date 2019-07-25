//
//  UIViewController+Modal.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/26.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Modal)

- (void)presentViewControllerWithShadow:( UIViewController * _Nonnull )viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;

@end



