//
//  UIViewController+Modal.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/26.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIViewController+Modal.h"
#import "MTShadowController.h"

@implementation UIViewController (Modal)

- (void)presentViewControllerWithShadow:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion
{
    MTShadowController* vc = [MTShadowController new];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:false completion:^{
        
        viewControllerToPresent.view.backgroundColor = [UIColor clearColor];
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
        
        [vc presentViewController:viewControllerToPresent animated:flag completion:completion];
        
    }];
}

@end

