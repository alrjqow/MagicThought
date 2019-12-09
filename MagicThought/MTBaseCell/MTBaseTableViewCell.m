//
//  MTBaseTableViewCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/8.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseTableViewCell.h"
#import "UIView+Frame.h"

@interface MTBaseTableViewCell ()
{
    MTBaseCellModel* _model;
}


@end

@implementation MTBaseTableViewCell

-(void)whenGetResponseObject:(MTBaseCellModel *)model
{
    self.model = model;
}

-(void)setModel:(MTBaseCellModel *)model
{
    _model = model;
    
    self.accessoryType = model.isArrow ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    self.textLabel.contentModel = model;
    self.detailTextLabel.contentModel = model;
    self.imageView.contentModel = model;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.bindTag(@"title");
        self.detailTextLabel.bindTag(@"content");
        self.imageView.bindTag(@"img");
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSMutableArray<UIView*>* arr = [NSMutableArray array];
    for(UIView* subView in self.subviews)
    {
        //寻找分割线
        if([subView isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")])
            [arr addObject:subView];
        
        //寻找箭头
        if([subView isKindOfClass:[UIButton class]] && self.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
        {
            _arrowView = subView;
            if(!CGRectEqualToRect(CGRectZero, self.model.accessoryBounds))
                subView.bounds = self.model.accessoryBounds;
            if(self.model.accessoryMarginRight > 0)
                subView.maxX = self.width - self.model.accessoryMarginRight;
        }
    }
    
    
    //设置分割线
    for(NSInteger i = 0; i < arr.count; i++)
    {
        if(i == 0 && arr.count > 1)
        {
            arr[i].width = 0;
            continue;
        }
        
        if(!self.model || self.model.sepLineWidth < 0)
            break;
        
        arr[i].width = self.model.isCloseSepLine ? 0 : self.model.sepLineWidth;
        arr[i].centerX = self.width * 0.5;
        arr[i].centerY = self.contentView.height - arr[i].halfHeight;
    }
    
}

-(Class)classOfResponseObject
{
    return [MTBaseCellModel class];
}

@end


@implementation MTNoSepLineBaseCell

-(CGFloat)sepLineWidth
{
    return 0;
}


@end


@implementation MTBaseSubTableViewCell

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

-(void)setModel:(MTBaseCellModel *)model
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

