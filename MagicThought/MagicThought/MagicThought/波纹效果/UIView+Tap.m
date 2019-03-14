//
//  UIView+Tap.m
//  8kqw
//
//  Created by 王奕聪 on 2017/4/20.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "UIView+Tap.h"
#import "MTFingerWaveView.h"

@implementation UIView (Tap)

-(void)openTapEffect
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tap];
}

- (void)onTap:(UITapGestureRecognizer*)sender {
    CGPoint center = [sender locationInView:sender.view];
    [MTFingerWaveView  showInView:self center:center];
}

@end
