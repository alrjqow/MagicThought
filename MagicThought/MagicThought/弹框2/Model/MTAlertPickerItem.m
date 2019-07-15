//
//  MTAlertPickerItem.m
//  SimpleProject
//
//  Created by monda on 2019/6/12.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTAlertPickerItem.h"

@implementation MTAlertPickerItem

+(instancetype)itemWithOrder:(NSString *)order Title:(NSString *)title
{
    MTAlertPickerItem* item = [super itemWithOrder:order Title:title];
    item.selectedWord = mt_WordStyleMake(12, title, hex(0x2976f4));
    item.word = mt_WordStyleMake(12, title, hex(0x333333));
        
    return item;
}

@end
