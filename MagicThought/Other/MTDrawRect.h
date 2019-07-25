//
//  MTDrawRect.h
//  8kqw
//
//  Created by 王奕聪 on 2017/4/19.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBorderStyle.h"
#import "MTGraphicType.h"

@interface MTDrawRect : NSObject

+(void)drawRectWithGraphicType:(MTGraphicType)type WithBorderStyle:(MTBorderStyle*)style;

@end
