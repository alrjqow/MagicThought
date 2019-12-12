//
//  MTBaseView.m
//  QXProject
//
//  Created by monda on 2019/12/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseView.h"

@implementation MTBaseView

-(void)whenGetResponseObject:(MTViewContentModel *)object
{
    self.model = object;
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
    
    self.textLabel = [UILabel new];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel = [UILabel new];
    self.imageView = [UIImageView new];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    [self addSubview:self.imageView];
}


-(Class)classOfResponseObject
{
    return [MTViewContentModel class];
}

@end

@implementation MTBaseSubView

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

