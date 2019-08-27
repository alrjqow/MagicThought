//
//  MTTenScrollViewCell.m
//  DaYiProject
//
//  Created by monda on 2018/12/25.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollViewCell.h"
#import "MTTenScrollContentView.h"
#import "MTTenScrollTitleView.h"
#import "MTTenScrollModel.h"

#import "UIView+Frame.h"

@interface MTTenScrollViewCell ()

@property (nonatomic,strong) MTTenScrollContentView* collectionView;

@property (nonatomic,strong) MTTenScrollTitleView* titleView;

@end

@implementation MTTenScrollViewCell

-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:[MTTenScrollModel class]])
        return;
    
    self.model = (MTTenScrollModel*)object;
}

-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    self.collectionView.model = self.model;
    self.titleView.model = self.model;
}

#pragma mark - 生命周期

-(void)setupDefault
{
    [super setupDefault];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.titleView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    self.titleView.frame = CGRectMake(0, 0, self.contentView.width, self.model.titleViewModel.titleViewHeight);
    
    self.collectionView.frame = CGRectMake(0, self.titleView.maxY, self.contentView.width, self.height - self.titleView.maxY);
}

#pragma mark - 懒加载

-(MTTenScrollContentView *)collectionView
{
    if(!_collectionView)
    {
        _collectionView = [MTTenScrollContentView new];        
    }
    
    return _collectionView;
}

-(MTTenScrollTitleView *)titleView
{
    if(!_titleView)
    {
        _titleView = [MTTenScrollTitleView new];        
    }
    
    return _titleView;
}

@end
