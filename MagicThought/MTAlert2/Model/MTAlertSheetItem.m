//
//  MTAlertSheetItem.m
//  SimpleProject
//
//  Created by monda on 2019/6/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTAlertSheetItem.h"

@implementation MTAlertSheetItem

-(void)setupDefault
{
    [super setupDefault];
    
    self.marginBottom = 1;
    self.itemHeight = 56;
}

-(void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    
    [self setupItemHeight];
}

-(void)setMarginBottom:(CGFloat)marginBottom
{
    _marginBottom = marginBottom;
    
    [self setupItemHeight];
}

-(void)setupItemHeight
{
    if((self.marginBottom + self.itemHeight) > 0)
        self.bindHeight(self.marginBottom + self.itemHeight);
}


@end


@implementation MTAlertSheetCancelItem

-(BOOL)isCancel
{
    return YES;
}

@end


