//
//  NSObject+MJExtension.m
//  QXProject
//
//  Created by monda on 2019/12/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "NSObject+MJExtension.h"
#import <MJExtension.h>
#import "NSString+Exist.h"

@implementation UIColor(MJExtension)

+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    if(![keyValues isKindOfClass:[UIColor class]])
        return nil;
    
    return keyValues;
}

@end

@implementation UIImage(MJExtension)

+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    if([keyValues isKindOfClass:[NSString class]] && [keyValues isExist])
        return [UIImage imageNamed:keyValues];
    
    if([keyValues isKindOfClass:[UIImage class]])
        return keyValues;
    
    return nil;
}

@end

@implementation MTWordStyle(MJExtension)

+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    if(![keyValues isKindOfClass:[MTWordStyle class]])
        return nil;
    
    return keyValues;
}

@end

@implementation MTBorderStyle(MJExtension)

+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    if(![keyValues isKindOfClass:[MTBorderStyle class]])
        return nil;
    
    return keyValues;
}

@end
