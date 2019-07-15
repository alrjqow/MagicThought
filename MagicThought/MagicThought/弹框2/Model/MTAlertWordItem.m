//
//  MTAlertWordItem.m
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTAlertWordItem.h"

@implementation MTAlertWordItem

+(instancetype)itemWithOrder:(NSString*)order Title:(NSString*)title
{
    MTAlertWordItem* item = [self itemWithOrder:order];
    item.word = mt_WordStyleMake(15, title, hex(0x222222));
    
    return item;
}


-(void)setIsCancel:(BOOL)isCancel
{
    _isCancel = isCancel;
    
    if(isCancel)
        self.word = mt_WordStyleMake(15, @"取消", hex(0x2976f4));
}

@end


@implementation MTAlertWordCancelItem

-(instancetype)init
{
    if(self = [super init])
    {
        self.isCancel = YES;
    }
    
    return self;
}

@end
