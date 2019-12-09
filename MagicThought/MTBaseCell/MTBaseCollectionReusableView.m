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
        MTViewContentModel* model = self.model;
        if(!model)
            model = self.classOfResponseObject.new;
        
        if([model isKindOfClass:[MTViewContentModel class]])
        {
            model.title = (NSString*)object;
            self.model = model;
        }        
    }
    else if([object isKindOfClass:self.classOfResponseObject])
        self.model = (MTViewContentModel*)object;
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.textLabel = (UILabel*)[UILabel new].bindTag(@"title");
    self.detailTextLabel = (UILabel*)[UILabel new].bindTag(@"content");
    self.imageView = (UIImageView*)[UIImageView new].bindTag(@"img");
    
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    [self addSubview:self.imageView];        
}

-(void)setModel:(MTViewContentModel *)model
{
    _model = model;
    
    self.textLabel.contentModel = model;
    self.detailTextLabel.contentModel = model;
    self.imageView.contentModel = model;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.centerY;
}

-(Class)classOfResponseObject
{
    return [MTViewContentModel class];
}

@end



@implementation MTBaseSubCollectionReusableView

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
