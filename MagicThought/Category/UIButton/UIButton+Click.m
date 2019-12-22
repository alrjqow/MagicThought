//
//  UIButton+Click.m
//  QXProject
//
//  Created by monda on 2019/12/4.
//  Copyright © 2019 monda. All rights reserved.
//

#import "UIButton+Click.h"
#import "NSObject+ReuseIdentifier.h"

@implementation UIButton (Click)

-(BindClick)bindClick
{
    if(!self.tag)
    {
        self.tag = 1;
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [super bindClick];
}

-(void)buttonClick
{
    if(self.mt_click)
        self.mt_click(self.mt_order);
}

- (void)clearClick
{
    self.tag = 0;
    [self removeTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTarget:(nullable id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
