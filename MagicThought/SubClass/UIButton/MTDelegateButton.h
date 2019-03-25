//
//  MTDelegateButton.h
//  8kqw
//
//  Created by 八块钱网 on 2017/6/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"

@interface MTDelegateButton : UIButton

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@end
