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

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    [super setContentModel:contentModel];
        
    self.button.baseContentModel = contentModel.btnTitle;
    self.button2.baseContentModel = contentModel.btnTitle2;
    self.detailTextLabel2.baseContentModel = contentModel.content2;
    self.imageView2.baseContentModel = contentModel.img2;
}

@end

