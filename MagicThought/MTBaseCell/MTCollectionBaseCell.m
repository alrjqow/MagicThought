//
//  MTCollectionBaseCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTCollectionBaseCell.h"
#import "UIView+Frame.h"

@implementation MTCollectionBaseCell


-(void)whenGetResponseObject:(NSDictionary *)object
{
    NSDictionary* dict = (NSDictionary*)object;
    
    self.imgView.image = [UIImage imageNamed:dict[@"img"]];
    self.textLabel.text = dict[@"title"];
}


-(void)setupDefault
{
    [super setupDefault];
    
    //    self.isDragEnable = YES;
    
    self.textLabel = [UILabel new];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.imgView = [UIImageView new];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.imgView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.width = 50;
    self.imgView.height = 50;
    self.imgView.centerX = self.contentView.centerX;
    
    [self.textLabel sizeToFit];
    self.textLabel.width = self.contentView.width;
    self.textLabel.y = self.imgView.maxY + 15;
}


@end
