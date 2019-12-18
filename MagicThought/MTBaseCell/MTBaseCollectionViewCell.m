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
    self.contentModel = object;
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

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    [super setContentModel:contentModel];
        
    self.button.baseContentModel = contentModel.btnTitle;
    self.button2.baseContentModel = contentModel.btnTitle2;
    self.detailTextLabel2.baseContentModel = contentModel.content2;
    self.imageView2.baseContentModel = contentModel.img2;
}

@end
