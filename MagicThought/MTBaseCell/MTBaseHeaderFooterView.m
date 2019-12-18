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
        MTViewContentModel* contentModel = self.contentModel;
        if(!contentModel)
        {
            if([self.classOfResponseObject isSubclassOfClass:[MTViewContentModel class]])
                contentModel = self.classOfResponseObject.new;
            else
            {
                contentModel = [MTViewContentModel new];
                MTBaseViewContentModel* title = [MTBaseViewContentModel new];
                contentModel.title = title;
            }
        }
        
        contentModel.title.text = (NSString*)object;
        self.contentModel = contentModel;
    }
    else if([object isKindOfClass:self.classOfResponseObject])
        self.contentModel = (MTViewContentModel*)object;
}

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    _contentModel = contentModel;
    
    self.baseContentModel = contentModel;
    
    self.textLabel.baseContentModel = contentModel.title;
    self.detailTextLabel.baseContentModel = contentModel.content;
    self.imageView.baseContentModel = contentModel.img;
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

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    [super setContentModel:contentModel];
    
    self.button.baseContentModel = contentModel.btnTitle;
    self.button2.baseContentModel = contentModel.btnTitle2;
    self.detailTextLabel2.baseContentModel = contentModel.content2;
    self.imageView2.baseContentModel = contentModel.img2;
}

@end

