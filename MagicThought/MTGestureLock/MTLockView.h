//
//  MTLockView.h
//  手势解锁
//
//  Created by monda on 2018/3/19.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTDelegateView.h"


extern NSString*  MTLockViewAfterGetGestureResultOrder;
@class MTLockViewConfig;
@interface MTLockView : MTDelegateView


@property (nonatomic,strong) MTLockViewConfig* model;



@end
