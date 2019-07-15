//
//  MTAlertStyle.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/11.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTAlertStyle.h"

@implementation MTAlertStyle


MTAlertStyle* mt_AlertStyleMake(NSString* title, NSString* subTitle,NSString* leftStatement,NSString* rightStatement,MTAlertType type)
{
    MTAlertStyle* style = [MTAlertStyle new];
    style.title = title;
    style.subTitle = subTitle;
    style.leftStatement = leftStatement;
    style.rightStatement = rightStatement;
    style.type = type;
    
    return style;
}

@end
