//
//  MTAlertItem.m
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTAlertItem.h"

@implementation MTAlertItem

-(instancetype)initWithOrder:(NSString*)order
{
    if(self = [self init])
    {
        _eventOrder = order;
    }
    
    return self;
}

+(instancetype)itemWithOrder:(NSString*)order
{
    return [[self alloc] initWithOrder:order];
}

@end
