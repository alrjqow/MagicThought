//
//  MTVideoController.h
//  photographDemo
//
//  Created by 王奕聪 on 2017/11/10.
//  Copyright © 2017年 Renford. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTDelegateProtocol;

@interface MTVideoController : UIViewController

@property(nonatomic,assign) CGFloat imageWidth;

@property(nonatomic,weak) id<MTDelegateProtocol> delegate;

@property(nonatomic,assign) CGFloat maxImagesCount;

/**录像时长*/
@property (nonatomic,assign) CGFloat recordSeconds;

/**是否开启录像*/
@property (nonatomic,assign) BOOL isOpenVideo;

@end
