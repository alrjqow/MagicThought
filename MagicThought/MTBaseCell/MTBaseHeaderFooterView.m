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
#import "NSString+Exist.h"
#import "VKCssProtocol.h"

@implementation MTBaseHeaderFooterView

-(void)whenGetResponseObject:(NSObject *)object
{
    if([object isKindOfClass:[NSString class]])
    {
        MTBaseViewContentModel* model = self.model;
        if(!model)
            model = [MTBaseViewContentModel new];
                    
        model.title = (NSString*)object;
        self.model = model;
    }
    else if([object isKindOfClass:[MTBaseViewContentModel class]])
        self.model = (MTBaseViewContentModel*)object;
}

-(void)setModel:(MTBaseViewContentModel *)model
{
    _model = model;
        
    if([model.titleCssClass isExist])
        self.textLabel.CssClass(model.titleCssClass);
    else
        [self.textLabel setWordWithStyle: self.model.titleWord];
        
    if([self.model.title isExist])
        self.textLabel.text = self.model.title;
    [self setNeedsLayout];
}

-(void)setupDefault
{
    [super setupDefault];
        
    self.clipsToBounds = YES;
    self.textLabel.numberOfLines = 0;
}

-(Class)classOfResponseObject
{
    return [NSObject class];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
                
    [self.textLabel sizeToFit];    
    self.textLabel.centerY = self.contentView.centerY;
}

@end


@implementation MTSubBaseHeaderFooterView


-(void)whenGetResponseObject:(NSObject *)object
{
    [self setSuperResponseObject:object];
    self.btn.bindClick(object.mt_click);
}

-(void)setupDefault
{
    [super setupDefault];
        
    self.btn = [UIButton new];
        
    [self addSubview:self.btn];
}

@end

