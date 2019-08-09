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

@property (nonatomic,strong) UIPanGestureRecognizer* pan;

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
//    self.bounces = false;
    
    self.pagingEnabled = YES;
    
//    [self.panGestureRecognizer requireGestureRecognizerToFail:[MTCloud shareCloud].currentViewController.navigationController.interactivePopGestureRecognizer];
    
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    self.pan = pan;
//    [pan requireGestureRecognizerToFail:self.panGestureRecognizer];
//    [self addGestureRecognizer:pan];
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, self.width);
    [self addTarget:self EmptyData:nil DataList:nil SectionList:nil];
}

-(void)didPan:(UIPanGestureRecognizer*)pan
{
    NSLog(@"xxx ==== %lf",[pan translationInView:self].x);
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if(otherGestureRecognizer != self.model.superTenScrollView.model.contentView.panGestureRecognizer)
//        return false;
//
//    CGFloat offsetX = [self.panGestureRecognizer velocityInView:self].x;
////    NSLog(@"%lf",offsetX);
//
////    CGFloat currentIndex0 = self.contentOffset.x / self.width;
//
////    if(self.model.superTenScrollView)
////    {
////        NSLog(@"qqqqq ===== %lf",offsetX);
////    }
////    else
////        NSLog(@"aaaaa");
//
//
//
//    return false;
//}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
    //    NSLog(@"%lf",offsetX);

    //    CGFloat currentIndex0 = self.contentOffset.x / self.width;

    static CGFloat preOffsetX = -1;
    if(!self.model.superTenScrollView)
    {
        if([self.model.currentView isKindOfClass:[MTTenScrollView class]])
        {
            MTTenScrollModel* subModel = ((MTTenScrollView*)self.model.currentView).model;
            MTTenScrollContentView* subContentView = subModel.contentView;
            CGFloat offsetX = [subContentView.panGestureRecognizer translationInView:subContentView].x;
            
            NSInteger superCurrentIndex = self.model.currentIndex;
            NSInteger superMaxIndex = self.model.dataList.count - 1;
            
            CGFloat currentIndex0 = subContentView.offsetX / self.width;
            CGFloat minIndex = floor(currentIndex0);
            CGFloat maxIndex = ceil(currentIndex0);
            
            NSLog(@"%lf",offsetX);
//            if(minIndex == 0 && (offsetX > 0) && (superCurrentIndex > 0))
//                return YES;
//
            if ((maxIndex == (self.model.dataList.count - 1)) && (offsetX < 0) && (superCurrentIndex < superMaxIndex))
            {
                
                NSLog(@"max ==== %lf", offsetX);
                if(preOffsetX == 0)
                    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(superCurrentIndex + 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
//                return YES;
            }
            
            preOffsetX = offsetX;
        }
        return false;
    }
    
    
//    if(self.model.superTenScrollView)
//    {
//        CGFloat offsetX = [self.panGestureRecognizer velocityInView:self].x;
////        NSLog(@"qqqqq ===== %lf",offsetX);
//
//        NSInteger superCurrentIndex = self.model.superTenScrollView.model.currentIndex;
//        NSInteger superMaxIndex = self.model.superTenScrollView.model.dataList.count - 1;
//
//        CGFloat currentIndex0 = self.contentOffset.x / self.width;
//
//        CGFloat minIndex = floor(currentIndex0);
//        CGFloat maxIndex = ceil(currentIndex0);
//
//        if(minIndex == 0 && (offsetX > 0) && (superCurrentIndex > 0))
//            return YES;
//
//        if ((maxIndex == (self.model.dataList.count - 1)) && (offsetX < 0) && (superCurrentIndex < superMaxIndex))
//        {
//            NSLog(@"max ==== %lf", offsetX);
//            return YES;
//        }
//    }

    return false;
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
    if(self.model.superTenScrollView)
    {
        CGFloat currentIndex0 = self.contentOffset.x / self.width;
        NSLog(@"%.2lf ===== %zd", currentIndex0, self.model.currentIndex);
    }
//    return YES;
    if(gestureRecognizer != self.panGestureRecognizer)
        return YES;
    /**
     1、快滑 、前进的
     4.00 ===== 4
     4.76 ===== 4
     
     2、快滑 、后退的
     4.00 ===== 4
     4.67 ===== 4
     
     3、慢滑 、前进的
     4.00 ===== 4
     4.95 ===== 4
     
     4、慢滑 、后退的
     4.00 ===== 4
     4.93 ===== 4
     
     */
    
    CGFloat currentIndex0 = self.contentOffset.x / self.width;
    NSInteger currentIndex = self.model.currentIndex;
    NSInteger superCurrentIndex = self.model.superTenScrollView.model.currentIndex;
    CGFloat offsetX = [((UIPanGestureRecognizer*)gestureRecognizer) translationInView:self].x;
    
    
    
//    if(self.model.superTenScrollView)
//    {
////        NSLog(@"qqqq");
//        return YES;
//    }
//    else
//    {
//
////        NSLog(@"zzzz");
//        return YES;
//    }
    if(self.model.currentIndex == (self.model.dataList.count - 2))
    {
        if(self.model.superTenScrollView)
        {
//            NSLog(@"1111111 ===== %@ ====== %lf ====== %lf", ((offsetX <= 0) && ceil(currentIndex0) == (self.model.dataList.count - 1)) ? @"No" : @"Yes", ceil(currentIndex0), offsetX);
            
            if(ceil(currentIndex0) == (self.model.dataList.count - 1))
                return fabs(currentIndex0 - currentIndex) < 0.78;
            
            return YES;
        }
        
    }

    
   
    
    
    
    BOOL canPan = (currentIndex == 0 && (superCurrentIndex > 0)) || (currentIndex == (self.model.dataList.count - 1) && (superCurrentIndex < (self.model.superTenScrollView.model.dataList.count - 1)));
    if(canPan)
    {
        if(!self.model.superTenScrollView)
        {
            NSLog(@"222222 ===== %@ ======= %lf ======= %lf", offsetX >= 0 ? @"Yes" : @"No", offsetX, ceil(currentIndex0));
        }
        
        return offsetX >= 0;
    }
    
    if(!self.model.superTenScrollView)
    {
//        NSLog(@"333333");
    }
    
    
    return YES;
}



#pragma mark - 懒加载

-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    model.contentView = self;
    if(model.superTenScrollView)
    {
        
//        [self.panGestureRecognizer requireGestureRecognizerToFail:model.contentView.panGestureRecognizer];
//        [self.pan requireGestureRecognizerToFail:model.superTenScrollView.model.contentView.panGestureRecognizer];
    }
    
    [self reloadDataWithDataList:(NSArray*)model.bandCount(model.dataList.count).band(@"MTTenScrollContentCell")];
}

#pragma mark - 成员方法

-(void)afterEndScroll
{
    
    self.model.currentIndex = self.contentOffset.x / self.width;
    self.model.tenScrollView.scrollEnabled = YES;
    self.model.currentView.scrollEnabled = YES;
    [self.model didContentViewEndScroll];
}

#pragma mark - 代理
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.model.superTenScrollView)
    {
//        NSLog(@"%lf",self.offsetX);
    }
    if(decelerate)
        return;
    
    [self afterEndScroll];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self afterEndScroll];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.model.tenScrollView.scrollEnabled = false;
    self.model.currentView.scrollEnabled = false;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat maxOffsetX = (self.model.dataList.count - 1) * self.width;
    
//    if(self.offsetX < 0)
//        self.offsetX = 0;
    
    if([self.model.currentView isKindOfClass:[MTTenScrollView class]])
    {
        MTTenScrollModel* subModel = ((MTTenScrollView*)self.model.currentView).model;
        MTTenScrollContentView* subContentView = subModel.contentView;
        if(subContentView.isRolling)
        {
            NSInteger superCurrentIndex = self.model.currentIndex;
            NSInteger superMaxIndex = self.model.dataList.count - 1;
            
            CGFloat currentIndex0 = subContentView.offsetX / subContentView.width;
            CGFloat minIndex = floor(currentIndex0);
            CGFloat maxIndex = ceil(currentIndex0);
            CGFloat offsetX = [subContentView.panGestureRecognizer translationInView:subContentView].x;
            
            NSLog(@"%lf",currentIndex0);
//            self.offsetX = self.model.currentIndex * self.width;
//            if(minIndex == 0 && (offsetX > 0) && (superCurrentIndex > 0))
//            {}
//            else
//                self.offsetX = self.model.currentIndex * self.width;
//            if()
            
            
//            if(minIndex == (subModel.dataList.count - 2))
//            {
//                if(self.model.superTenScrollView)
//                {
//                    //            NSLog(@"1111111 ===== %@ ====== %lf ====== %lf", ((offsetX <= 0) && ceil(currentIndex0) == (self.model.dataList.count - 1)) ? @"No" : @"Yes", ceil(currentIndex0), offsetX);
//
//                    if(ceil(currentIndex0) == (self.model.dataList.count - 1))
//                        return fabs(currentIndex0 - currentIndex) < 0.78;
//
//                    return YES;
//                }
//
//            }
            
            
            if ((currentIndex0 > (subModel.dataList.count - 1)) && (offsetX < 0) && (superCurrentIndex < superMaxIndex))
            {}
            else
                self.offsetX = self.model.currentIndex * self.width;
        }
        
//        if(self.offsetX > maxOffsetX)
//            self.offsetX = maxOffsetX;
//

        
//
     
//
//        NSLog(@"%lf",offsetX);
        
//        //                return YES;
//        //
        
//        {
//
//            NSLog(@"max ==== %lf", offsetX);
//            if(preOffsetX == 0)
//                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(superCurrentIndex + 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
//            //                return YES;
//        }
//
//        preOffsetX = offsetX;
    }
    [self.model contentViewDidScroll];
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
