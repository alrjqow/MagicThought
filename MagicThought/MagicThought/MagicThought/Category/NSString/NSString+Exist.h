//
//  NSString+Exist.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Exist)

/*!
 判断字符串是否为空(空格、空字符也算空),若为空，返回false；不为空，返回Yes
 */
-(BOOL) isExist;

+(BOOL) isEmpty:(NSString*)str;

@end
