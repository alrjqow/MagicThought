//
//  MTTakePhotoPreseterModel.h
//  DaYiProject
//
//  Created by monda on 2018/8/24.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTBaseAlertController.h"
#import "MTDelegateProtocol.h"

@interface MTTakePhotoPreseterModel : NSObject<MTDelegateProtocol>

/**完成图片选择后*/
@property(nonatomic,strong) void(^completion)(void);

/**最大添加图片数*/
@property(nonatomic,assign) CGFloat maxCount;

/**展示列数*/
@property(nonatomic,assign) NSInteger columnNumber;

/**拍照按钮是否放在里面*/
@property(nonatomic,assign) BOOL allowCameraIn;

/**是否只允许拍照*/
@property(nonatomic,assign) BOOL onlyCamera;

@property (nonatomic,strong) MTBaseAlertController* alertController;

-(void)dismissAlertController;

@end


