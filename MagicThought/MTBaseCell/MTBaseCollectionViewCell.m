//
//  MTBaseCollectionViewCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCollectionViewCell.h"
#import "UIView+Frame.h"

@implementation MTBaseCollectionViewCell

-(void)whenGetResponseObject:(MTViewContentModel *)object
{
    self.model = object;
}

-(void)setModel:(MTViewContentModel *)model
{
    _model = model;
    
    self.textLabel.contentModel = model;
     self.detailTextLabel.contentModel = model;
     self.imageView.contentModel = model;
}

-(void)setupDefault
{
    [super setupDefault];
    
    //    self.isDragEnable = YES;
    
    self.textLabel = (UILabel*)[UILabel new].bindTag(@"title");
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel = (UILabel*)[UILabel new].bindTag(@"content");
    self.imageView = (UIImageView*)[UIImageView new].bindTag(@"img");
    
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
    
    self.button = (UIButton*)[UIButton new].bindTag(@"btn");
    self.button2 = (UIButton*)[UIButton new].bindTag(@"btn2");
    self.imageView2 = (UIImageView*)[UIImageView new].bindTag(@"img2");
    self.detailTextLabel2 = (UILabel*)[UILabel new].bindTag(@"content2");
    
    [self addSubview:self.button];
    [self addSubview:self.button2];
    [self addSubview:self.imageView2];
    [self addSubview:self.detailTextLabel2];
}

-(void)setModel:(MTViewContentModel *)model
{
    [super setModel:model];
    
    [model setValue:@(self.button.state) forKey:@"btnState"];
    [model setValue:@(self.button2.state) forKey:@"btn2State"];
        
    self.button.contentModel = model;
    self.button2.contentModel = model;
    self.detailTextLabel2.contentModel = model;
    self.imageView2.contentModel = model;
}

@end
