//
//  MTAlertWordItem.m
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTAlertWordItem.h"

@implementation MTAlertWordItem

-(void)setupDefault
{
    [super setupDefault];
        
    self.wordStyle = self.isCancel ? mt_WordStyleMake(15, @"取消", hex(0x2976f4)) : mt_WordStyleMake(15, @"", hex(0x222222));
}

@end


@implementation MTAlertWordCancelItem

-(BOOL)isCancel
{
    return YES;
}

@end



@implementation MTAlertPickerItem

-(void)setupDefault
{
    [super setupDefault];
    
    self.wordStyle = mt_WordStyleMake(12, @"", hex(0x333333));
    self.selected = MTBaseViewContentModel.new(mt_WordStyleMake(12, @"", hex(0x2976f4)));
}

@end
