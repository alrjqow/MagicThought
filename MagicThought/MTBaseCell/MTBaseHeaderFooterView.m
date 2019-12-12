//
//  MTBaseHeaderFooterView.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseHeaderFooterView.h"

@implementation MTBaseHeaderFooterView

-(void)whenGetResponseObject:(NSObject *)object
{
    if([object isKindOfClass:[NSString class]])
    {
        MTViewContentModel* model = self.model;
        if(!model)
        {
            if([self.classOfResponseObject isSubclassOfClass:[MTViewContentModel class]])
                model = self.classOfResponseObject.new;
            else
            {
                model = [MTViewContentModel new];
                MTBaseViewContentModel* title = [MTBaseViewContentModel new];
                model.title = title;
            }
        }
        
        model.title.text = (NSString*)object;
        self.model = model;
    }
    else if([object isKindOfClass:self.classOfResponseObject])
        self.model = (MTViewContentModel*)object;
}

-(void)setModel:(MTViewContentModel *)model
{
    _model = model;
    
    self.baseContentModel = model;
    
    self.textLabel.baseContentModel = model.title;
    self.detailTextLabel.baseContentModel = model.content;
    self.imageView.baseContentModel = model.img;
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.clipsToBounds = YES;
    self.textLabel.numberOfLines = 0;
    
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
}

-(Class)classOfResponseObject
{
    return [MTViewContentModel class];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.contentView.centerY;
}

@end


@implementation MTBaseSubHeaderFooterView




-(void)setupDefault
{
    [super setupDefault];
    
    self.button = [UIButton new];
    self.button2 = [UIButton new];
    self.imageView2 = [UIImageView new];
    self.detailTextLabel2 = [UILabel new];
    
    [self addSubview:self.button];
    [self addSubview:self.button2];
    [self addSubview:self.imageView2];
    [self addSubview:self.detailTextLabel2];
    
}

-(void)setModel:(MTViewContentModel *)model
{
    [super setModel:model];
    
    self.button.baseContentModel = model.btnTitle;
    self.button2.baseContentModel = model.btnTitle2;
    self.detailTextLabel2.baseContentModel = model.content2;
    self.imageView2.baseContentModel = model.img2;
}

@end

