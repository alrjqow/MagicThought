//
//  MTLockNode.h
//  手势解锁
//
//  Created by 王奕聪 on 2018/3/17.
//  Copyright © 2018年 王奕聪. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MTLockViewConfig;

/**
 *  单个圆的各种状态
 */
typedef enum{
    MTLockNodeStateNormal = 0,
    MTLockNodeStateSelected,
    MTLockNodeStateError
}MTLockNodeState;


@interface MTLockNode : UIButton

/**模型对象*/
@property (nonatomic,strong) MTLockViewConfig* model;

/**所处的状态*/
@property (nonatomic, assign) MTLockNodeState circleState;

/** 角度 */
@property (nonatomic,assign) CGFloat angle;


@end

