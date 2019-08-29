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
#import "MTTenScrollController.h"

#import "MTDelegateCollectionViewCell.h"
#import "UIView+Frame.h"
#import "MTCloud.h"
#import "NSObject+ReuseIdentifier.h"
#import "UIView+ViewController.h"

@interface MTTenScrollContentCell : MTDelegateCollectionViewCell

@property (nonatomic,weak) MTTenScrollModel* model;

@property (nonatomic,weak) MTTenScrollModel* subModel;

@property (nonatomic,weak) UIView* preView;

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
    
    if([MTCloud shareCloud].currentViewController.navigationController)
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


#pragma mark - 代理
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTTenScrollContentCell* cell0 = (MTTenScrollContentCell*)cell;
    MTTenScrollModel* subModel = cell0.subModel;
     MTTenScrollView* subTenScrollView = subModel.tenScrollView;
    
    if(self.model.tenScrollView.offsetY > self.model.tenScrollViewMaxOffsetY && (subModel.tenScrollView.contentSize.height >= subModel.tenScrollHeight))
            subTenScrollView.offsetY = subModel.tenScrollViewMaxOffsetY;
    
    MTTenScrollModel* subModel2 = [subModel getSubModel:subModel];
    subModel2.tenScrollView.offsetY = 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.model didContentViewEndScrollWithDecelerate:decelerate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.model didContentViewEndScrollWithDecelerate:false];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{    
    [self.model contentViewWillBeginDragging];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.model contentViewDidScroll];
}

#pragma mark - 手势代理


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
    preView.hidden = false;
    
    UIViewController* vc = preView.viewController;
    
    if([vc isKindOfClass:[MTTenScrollController class]])
    {
       [((MTTenScrollController*)vc).tenScrollModel setValue:@(self.indexPath.row) forKey:@"superIndex"];
        self.subModel = ((MTTenScrollController*)vc).tenScrollModel;
    }
    
    [self addSubview:preView];
    if(self.preView != preView)
    {
        self.preView.hidden = YES;
        self.preView = preView;
    }
}


@end
