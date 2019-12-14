//
//  MTBaseCollectionViewCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCollectionViewCell.h"

@implementation MTBaseCollectionViewCell

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
    
    self.isDragEnable = false;
    
    self.textLabel = [UILabel new];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel = [UILabel new];
    self.imageView = [UIImageView new];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    [self addSubview:self.imageView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = 50;
    self.imageView.height = 50;
    self.imageView.centerX = self.contentView.centerX;
    
    [self.textLabel sizeToFit];
    self.textLabel.width = self.contentView.width;
    self.textLabel.y = self.imageView.maxY + 15;
}

-(Class)classOfResponseObject
{
    return [MTViewContentModel class];
}

@end


@implementation MTBaseSubCollectionViewCell

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
