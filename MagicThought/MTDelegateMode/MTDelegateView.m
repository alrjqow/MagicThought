//
//  MTDelegateView.m
//  8kqw
//
//  Created by 王奕聪 on 2016/12/24.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateView.h"

@implementation MTDelegateView


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupDefault];
    }
    
    return self;
}

-(void)dealloc
{
    [self whenDealloc];
}

@end



