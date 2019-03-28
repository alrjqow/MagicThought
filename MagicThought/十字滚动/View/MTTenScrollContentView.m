//
//  MTTenScrollContentView.m
//  DaYiProject
//
//  Created by monda on 2018/12/4.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollContentView.h"
#import "MTTenScrollModel.h"

#import "MTDelegateCollectionViewCell.h"
#import "UIView+Frame.h"
#import "NSObject+ReuseIdentifier.h"

@interface MTTenScrollContentCell : MTDelegateCollectionViewCell

@property (nonatomic,weak, readonly) UIView* preView;

@end


@interface MTTenScrollContentView ()<MTDelegateProtocol,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) MTTenScrollContentCell* currentCell;
@property (nonatomic,weak) MTTenScrollContentCell* willDisplayCell;

@end


@implementation MTTenScrollContentView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout* layout0 = [UICollectionViewFlowLayout new];
    layout0.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if(self = [super initWithFrame:frame collectionViewLayout:layout0])
    {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.backgroundColor = [UIColor clearColor];
        
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        
        self.pagingEnabled = YES;
        [self addTarget:self EmptyData:nil DataList:nil SectionList:nil];
    }
    
    return self;
}

-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    model.contentView = self;
    [self reloadDataWithDataList:(NSArray*)model.bandCount(model.dataList.count).band(@"MTTenScrollContentCell")];
}

#pragma mark - 成员方法

-(void)preViewReuse
{
    NSInteger index = self.contentOffset.x / self.width;
    self.model.currentIndex = index;
    
    if(self.currentCell == self.willDisplayCell)
        return;
    
    if(index == self.currentCell.indexPath.row)
        self.willDisplayCell.preView.tag = 0;
    else
    {
        self.currentCell.tag = 0;
        self.currentCell = self.willDisplayCell;
    }
}

-(void)afterEndScroll
{
    [self preViewReuse];
    [self.model didContentViewEndScroll];
}

#pragma mark - 代理
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTTenScrollContentCell* cell0 = (MTTenScrollContentCell*)cell;
    cell0.preView.tag = 1;
    if(!self.currentCell)
        self.currentCell = cell0;
    
    self.willDisplayCell = cell0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate)
        return;
    
    [self afterEndScroll];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self afterEndScroll];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.model contentViewDidScroll];    
}

@end




@interface MTTenScrollContentCell ()

@property (nonatomic,weak) MTTenScrollModel* model;


@end

@implementation MTTenScrollContentCell

- (void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:[MTTenScrollModel class]])
        return;
    
    self.model = (MTTenScrollModel*)object;
}

-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    self.preView.tag = 0;
    [self.preView removeFromSuperview];
    
    _preView = [model getViewByIndex:self.indexPath.row];
    self.preView.frame = self.contentView.bounds;
    [self addSubview:self.preView];
}


@end
