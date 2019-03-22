//
//  MTImagePlayView.m
//  8kqw
//
//  Created by 王奕聪 on 2017/4/7.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTImagePlayView.h"
#import "MTConst.h"
#import "MTImagePlayViewCell.h"
#import "MTDelegateProtocol.h"
#import "UIView+Frame.h"
#import "UIColor+ColorfulColor.h"

@interface MTImagePlayView()<UICollectionViewDelegate,UICollectionViewDataSource,MTDelegateProtocol>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property(nonatomic,strong) NSTimer* timer;

@property(nonatomic,assign) NSInteger itemCount;

@end

@implementation MTImagePlayView

-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;

    self.flowLayout.scrollDirection = scrollDirection;
}

-(void)setImageURLs:(NSArray<NSString *> *)imageURLs
{
    _imageURLs = imageURLs;
    
    [self stopTimer];
    
    self.itemCount = imageURLs.count > 0 ? imageURLs.count : 1;
    self.pagePoint.numberOfPages = self.itemCount;
    self.pagePoint.hidden = self.itemCount <= 1;
    
    [self.collectionView reloadData];
    NSInteger row = self.itemCount > 1 ? self.itemCount * itemTimes * 0.5 : 0;
    if(self.isScrollLimit)
        row = 0;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self setupTimer];
}


-(void)setupDefault
{
    [super setupDefault];
    
    [self setupSubView];
    [self setupTimer];
}

#define ImagePlayViewCell @"MTImagePlayViewCell"
-(void)setupSubView
{
    self.scrollTime = 3.0;
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [collectionView registerClass:[MTImagePlayViewCell class] forCellWithReuseIdentifier:ImagePlayViewCell];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:collectionView];
    _collectionView = collectionView;
    self.flowLayout = layout;
    
    UIPageControl *pagePoint = [UIPageControl new];
    pagePoint.hidden = YES;
    [self addSubview:pagePoint];
    self.pagePoint = pagePoint;
    
    CGPoint center = self.center;
    center.y = self.height * 0.85;
    self.pagePoint.center = center;
}

-(void)setupTimer
{
    if(self.isStopTimer)
        return;
    
    [self stopTimer];
    if(self.itemCount <= 1) return;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTime target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)nextPage
{
    CGPoint  offset = self.collectionView.contentOffset;
    offset.x += self.width;
    
    if(self.isScrollLimit && (offset.x >= self.itemCount * self.width))
        offset.x = 0;
        
    [self.collectionView setContentOffset:offset animated:YES];
    self.pagePoint.currentPage = (self.pagePoint.currentPage + 1) % self.itemCount;
}

-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)dealloc
{
    [self stopTimer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.flowLayout.itemSize = self.frame.size;
    self.collectionView.frame = self.bounds;
}


static NSInteger itemTimes = 100;
#pragma mark - collectionView数据源
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.isScrollLimit)
        return self.itemCount;
    return self.itemCount > 1 ? self.itemCount * itemTimes : self.itemCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.playViewDelegate respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)])
        return [self.playViewDelegate collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    MTImagePlayViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImagePlayViewCell forIndexPath:indexPath];
    cell.delegate = self;
    
    cell.imgURL = self.imageURLs.count > 0 ? self.imageURLs[indexPath.row % self.itemCount] : nil;
    return cell;
}

-(void)resetPosition
{
    NSInteger  index = self.collectionView.contentOffset.x / self.frame.size.width;
//    NSLog(@"%zd",index);
    NSInteger num = index % self.itemCount;
    self.pagePoint.currentPage = num;
    
    if(self.isScrollLimit)
        return;
    
    NSInteger row = self.itemCount > 1 ? self.itemCount * itemTimes * 0.5 +num : 0;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetPosition];
    [self setupTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetPosition];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.imageURLs.count) return;
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
        [self.mt_delegate doSomeThingForMe:self withOrder: MTImagePlayViewOrder withItem:@(indexPath.row % self.itemCount)];
}




@end
