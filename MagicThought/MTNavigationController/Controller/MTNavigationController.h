//
//  MTNavigationController.h
//  DaYiProject
//
//  Created by monda on 2018/8/1.
//  Copyright © 2018 monda. All rights reserved.
//

#import "NSObject+CommonProtocol.h"

@interface MTNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic,strong) NSString* order;

-(void)back;

/*!该属性用于设置侧滑还是全屏滑，默认全屏滑*/
@property(nonatomic,assign) BOOL isFullScreenPop;

/*是否可侧滑返回*/
@property (nonatomic,assign) BOOL enableSlideBack;

@end


