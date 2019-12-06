//
//  MTAlertSheetItem.m
//  SimpleProject
//
//  Created by monda on 2019/6/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTAlertSheetItem.h"
#import "NSObject+ReuseIdentifier.h"

@implementation MTAlertSheetItem

-(instancetype)init
{
    if(self = [super init])
    {
        self.marginBottom = 1;
        self.itemHeight = 56;
    }
    
    return self;
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

-(instancetype)init
{
    if(self = [super init])
    {
        self.isCancel = YES;
    }
    
    return self;
}

@end


