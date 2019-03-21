//
//  MTDelegateHeaderFooterView.m
//  8kqw
//
//  Created by 王奕聪 on 2017/5/16.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateHeaderFooterView.h"

@implementation MTDelegateHeaderFooterView

-(void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= (self.marginBottom + self.marginTop);
    rect.origin.y += self.marginTop;
    rect.origin.x += self.marginLeft;
    rect.size.width -= (self.marginLeft + self.marginRight);
    
    [super setFrame:rect];
}


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        [self setupDefault];
    }
    
    return self;
}

-(void)setupDefault
{
    
}

-(void)whenGetResponseObject:(NSObject*)object
{
    
}

@end
