//
//  MTPopButtonItem.m
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTPopButtonItem.h"
#import "MTWordStyle.h"

@implementation MTPopButtonItem

@end

 MTPopButtonItem* MTPopButtonItemMakeCustom(MTWordStyle* word, UIColor* backgroundColor, NSString* order)
{
    MTPopButtonItem *item = [MTPopButtonItem new];
    item.word = word;
    item.backgroundColor = backgroundColor;
    item.order = order;
    item.isCustom = YES;
    
    return item;
}


MTPopButtonItem* MTPopButtonItemMake(NSString* title, BOOL isHighlight, NSString* order)
{
    MTPopButtonItem *item = [MTPopButtonItem new];
    item.word = mt_WordStyleMake(0, title, nil);
    item.highlight = isHighlight;
    item.order = order;
    
    return item;
}

MTPopButtonItem* MTPopButtonItemMakeWithHandler(NSString* title, MTPopButtonItemType type, MTPopButtonItemHandler handler)
{
    MTPopButtonItem *item = [MTPopButtonItem new];
    
    item.word = mt_WordStyleMake(0, title, nil);
    item.handler = handler;
    
    switch (type)
    {
        case MTPopButtonItemTypeNormal:
        {
            break;
        }
        case MTPopButtonItemTypeHighlight:
        {
            item.highlight = YES;
            break;
        }
        case MTPopButtonItemTypeDisabled:
        {
            item.disabled = YES;
            break;
        }
        default:
            break;
    }
    
    return item;
}
