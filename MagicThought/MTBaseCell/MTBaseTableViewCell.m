//
//  MTBaseTableViewCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/8.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseTableViewCell.h"

@interface MTBaseTableViewCell ()
{
    MTBaseCellModel* _contentModel;
}


@end

@implementation MTBaseTableViewCell

-(void)whenGetResponseObject:(MTBaseCellModel *)contentModel
{
    self.contentModel = contentModel;
}

-(void)setContentModel:(MTBaseCellModel *)contentModel
{
    _contentModel = contentModel;
    
    self.baseContentModel = contentModel;
    
    self.accessoryType = contentModel.isArrow ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    self.textLabel.baseContentModel = contentModel.title;
    self.detailTextLabel.baseContentModel = contentModel.content;
    self.imageView.baseContentModel = contentModel.img;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])
    {
        
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
            if(!CGRectEqualToRect(CGRectZero, self.contentModel.accessoryBounds))
                subView.bounds = self.contentModel.accessoryBounds;
            if(self.contentModel.accessoryMarginRight > 0)
                subView.maxX = self.width - self.contentModel.accessoryMarginRight;
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
        
        if(!self.contentModel || self.contentModel.sepLineWidth < 0)
            break;
        
        arr[i].width = self.contentModel.isCloseSepLine ? 0 : self.contentModel.sepLineWidth;
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
    
    self.button = [UIButton new];
    self.button2 = [UIButton new];
    self.imageView2 = [UIImageView new];
    self.detailTextLabel2 = [UILabel new];
    
    [self addSubview:self.button];
    [self addSubview:self.button2];
    [self addSubview:self.imageView2];
    [self addSubview:self.detailTextLabel2];
}

-(void)setContentModel:(MTBaseCellModel *)contentModel
{
    [super setContentModel:contentModel];
        
    self.button.baseContentModel = contentModel.btnTitle;
    self.button2.baseContentModel = contentModel.btnTitle2;
    self.detailTextLabel2.baseContentModel = contentModel.content2;
    self.imageView2.baseContentModel = contentModel.img2;
}


@end

