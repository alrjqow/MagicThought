//
//  MTTenScrollContentView.m
//  DaYiProject
//
//  Created by monda on 2018/12/4.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollContentView.h"
#import "MTTenScrollModel.h"
#import "MTTenScrollView.h"


#import "MTDelegateCollectionViewCell.h"
#import "UIView+Frame.h"
#import "MTCloud.h"
#import "NSObject+ReuseIdentifier.h"

@interface MTTenScrollContentCell : MTDelegateCollectionViewCell

@property (nonatomic,weak) MTTenScrollModel* model;

@property (nonatomic,weak, readonly) UIView* preView;



@end


@interface MTTenScrollContentView ()<MTDelegateProtocol,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@end


@implementation MTTenScrollContentView


-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout* layout0 = [UICollectionViewFlowLayout new];
    layout0.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:frame collectionViewLayout:layout0];
    return self;
}

-(void)setupDefault
{
    [super setupDefault];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    
    self.bounces = false;
    
    self.pagingEnabled = YES;
    
    [self.panGestureRecognizer requireGestureRecognizerToFail:[MTCloud shareCloud].currentViewController.navigationController.interactivePopGestureRecognizer];
    
    [self addTarget:self EmptyData:nil DataList:nil SectionList:nil];
}

#pragma mark - 成员方法

#pragma mark - 懒加载

-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    model.contentView = self;
    [self reloadDataWithDataList:(NSArray*)model.bandCount(model.dataList.count).band(@"MTTenScrollContentCell")];
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    self.model.superTenScrollView.model.contentView.scrollEnabled = scrollEnabled;
    [super setScrollEnabled:scrollEnabled];
}

#pragma mark - 代理
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [self.model didContentViewEndScrollWithDecelerate:decelerate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self.model didContentViewEndScrollWithDecelerate:false];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{    
    [self.model contentViewWillBeginDragging];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.model contentViewDidScroll];
}

#pragma mark - 手势代理

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
        return YES;
    
    if(![self.model.currentView isKindOfClass:[MTTenScrollView class]])
        return YES;
    
    MTTenScrollModel* subModel = ((MTTenScrollView*)self.model.currentView).model;
    MTTenScrollContentView* subContentView = subModel.contentView;
    
    CGFloat minOffsetX = 0;
    CGFloat maxOffsetX = subContentView.width * subModel.maxIndex;
    CGFloat offsetX = subContentView.offsetX;
    CGFloat velX = [subContentView.panGestureRecognizer velocityInView:subContentView].x;
    
    
    
    NSLog(@"%lf === %lf === %lf === %lf === %lf",self.bounds.origin.x,velX, offsetX, minOffsetX, maxOffsetX);
    
    if((offsetX > minOffsetX) && (offsetX < maxOffsetX))
        return false;
    
    if((offsetX <= minOffsetX) && velX < 0)
        return false;
    
    if((offsetX >= maxOffsetX) && velX > 0)
        return false;
    
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end




@interface MTTenScrollContentCell ()<UIGestureRecognizerDelegate>


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
    
    UIView* preView = [model getViewByIndex:self.indexPath.row];        
    preView.frame = self.contentView.bounds;
    [self addSubview:preView];
}


@end
