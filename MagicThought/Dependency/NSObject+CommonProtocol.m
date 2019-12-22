//
//  NSObject+CommonProtocol.m
//  MDKit
//
//  Created by monda on 2019/6/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "NSObject+CommonProtocol.h"
#import <objc/runtime.h>

@implementation NSObject (CommonProtocol)

- (void)setupDefault {}

-(void)whenDealloc{}

-(void)setMt_delegate:(id<MTDelegateProtocol>)mt_delegate
{
    objc_setAssociatedObject(self, @selector(mt_delegate), mt_delegate, OBJC_ASSOCIATION_ASSIGN);
}

-(id<MTDelegateProtocol>)mt_delegate
{
    return objc_getAssociatedObject(self, _cmd);
}

-(id)valueForUndefinedKey:(NSString *)key{return nil;}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
