//
//  UIView+Delegate.m
//  MDKit
//
//  Created by monda on 2019/5/15.
//  Copyright © 2019 monda. All rights reserved.
//

#import "UIView+Delegate.h"

@implementation UIView (Delegate)


#pragma mark - MDExchangeDataProtocol代理

-(void)whenGetResponseObject:(NSObject *)object{}

-(void)setSuperResponseObject:(NSObject*)object{}

-(NSDictionary *)giveSomeThingToYou
{
    return nil;
}

-(void)giveSomeThingToMe:(id)obj WithOrder:(NSString *)order{}

-(Class)classOfResponseObject
{
    return [NSObject class];
}



@end

