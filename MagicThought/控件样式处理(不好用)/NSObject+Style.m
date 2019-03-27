//
//  NSObject+Style.m
//  DaYiProject
//
//  Created by monda on 2018/11/23.
//  Copyright © 2018 monda. All rights reserved.
//

#import "NSObject+Style.h"
#import "MTStyleProtocol.h"
#import "NSString+Exist.h"
#import "MTCloud.h"
#import "objc/runtime.h"

@implementation NSObject (Style)

static const void *mtStyleIdentifierKey = @"mtStyleIdentifierKey";
-(void)setMt_styleIdentifier:(NSString *)mt_styleIdentifier
{
    objc_setAssociatedObject(self, mtStyleIdentifierKey, mt_styleIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 
    if([mt_styleIdentifier isExist])
        [[MTCloud shareCloud].style configStyleWithObject:self];    
}

-(NSString *)mt_styleIdentifier
{
    return objc_getAssociatedObject(self, mtStyleIdentifierKey);
}

@end
