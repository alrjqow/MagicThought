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
#import "NSString+Exist.h"


@implementation MTBaseCollectionReusableView

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

-(void)setupDefault
{
    [super setupDefault];
    
    _textLabel = [UILabel new];
    [self addSubview:self.textLabel];
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.centerY;
}

-(Class)classOfResponseObject
{
    return [NSObject class];
}

@end
