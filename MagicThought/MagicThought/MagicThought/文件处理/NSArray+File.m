//
//  NSArray+File.m
//  8kqw
//
//  Created by 王奕聪 on 2017/3/23.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "NSArray+File.h"
#import "MTFileManager.h"
#import "NSString+Exist.h"

@implementation NSArray (File)

- (BOOL)writeToDirectory:(NSString *)directory File:(NSString*)file atomically:(BOOL)useAuxiliaryFile
{
    if(![file isExist]) return false;
    if(![MTFileManager createDirectoryAtPath:directory])
        return false;
    
    return [self writeToFile:[directory stringByAppendingPathComponent:file] atomically:useAuxiliaryFile];
}

@end
