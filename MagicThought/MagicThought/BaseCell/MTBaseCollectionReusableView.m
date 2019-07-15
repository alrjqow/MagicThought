//
//  MTBaseCollectionReusableView.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCollectionReusableView.h"
#import "MTWordStyle.h"
#import "UIView+Frame.h"
#import "UILabel+Word.h"



@implementation MTBaseCollectionReusableView


-(void)whenGetResponseObject:(NSObject *)object
{
    if([object isKindOfClass:[MTWordStyle class]])
    {
        self.word = (MTWordStyle*)object;
        return;
    }
    
    if([object isKindOfClass:[NSString class]])
        self.word.wordName = (NSString*)object;
}


-(void)setupDefault
{
    [super setupDefault];
    
    self.word = mt_WordStyleMake(12, @"", [UIColor blackColor]);
    self.textLabel = [UILabel new];
    
    [self addSubview:self.textLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textLabel setWordWithStyle:self.word];
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.centerY;
}


-(Class)classObj
{
    return [NSObject class];
}

@end
