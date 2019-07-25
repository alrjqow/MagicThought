//
//  MTBaseHeaderFooterView.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseHeaderFooterView.h"
#import "MTWordStyle.h"
#import "UIView+Frame.h"
#import "UILabel+Word.h"

@implementation MTBaseHeaderFooterView

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

-(void)btnClick{}

-(void)setupDefault
{
    [super setupDefault];
    
    self.word = mt_WordStyleMake(12, @"", [UIColor blackColor]);
    self.clipsToBounds = YES;
    self.textLabel.numberOfLines = 0;
}

-(Class)classObj
{
    return [NSObject class];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
            
    [self.textLabel setWordWithStyle: self.word];
    [self.textLabel sizeToFit];    
    self.textLabel.centerY = self.contentView.centerY;
}




@end

@implementation MTSubBaseHeaderFooterView

-(void)setupDefault
{
    [super setupDefault];
        
    self.btn = [UIButton new];
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btn];
}


@end

