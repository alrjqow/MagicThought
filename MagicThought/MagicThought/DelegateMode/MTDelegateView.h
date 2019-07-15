//
//  MTDelegateView.h
//  8kqw
//
//  Created by 王奕聪 on 2016/12/24.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "UIView+Delegate.h"

@interface MTDelegateView : UIView

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;



@end



