//
//  MTImagePlayViewModel.m
//  QXProject
//
//  Created by 王奕聪 on 2020/1/7.
//  Copyright © 2020 monda. All rights reserved.
//

#import "MTImagePlayViewModel.h"

@interface MTImagePlayViewModel ()

@property (nonatomic,weak) UICollectionView* collectionView;

@property(nonatomic,strong) NSTimer* timer;

@property (nonatomic,assign) NSInteger tag;



/**数量与倍数*/
@property(nonatomic,assign) NSInteger dataCount;
@property(nonatomic,assign) NSInteger dataTimes;

/**是否关闭自动滚动*/
@property (nonatomic,assign) BOOL isStopTimer;

/**滚动间隔*/
@property(nonatomic,assign) CGFloat scrollTime;

/**是否滚动有限*/
@property (nonatomic,assign) BOOL isScrollLimit;

@end

@implementation MTImagePlayViewModel

-(void)setupDefault
{
    [super setupDefault];
    
    self.dataTimes = 100;
    self.scrollTime = 3.0;
    
    [self.collectionView addTarget:self];        
}

#pragma mark - 设置计时器
-(void)setupTimer
{
    if(self.isStopTimer)
        return;
    
    [self stopTimer];
    if(self.dataCount <= 1) return;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTime target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)nextPage
{
    self.collectionView.tag ++;
    if(self.isScrollLimit && self.collectionView.tag >= self.dataCount)
        self.collectionView.tag = 0;
        
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.collectionView.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    _currentPage = self.collectionView.tag % self.dataCount;
}

-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 滚动完重置位置

-(void)resetPosition
{
    if(self.isScrollLimit)
        return;
    
    NSInteger row = self.dataCount > 1 ? self.dataCount * self.dataTimes * 0.5 + self.currentPage : 0;
    self.collectionView.tag = row;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - collectionView数据源
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.isScrollLimit)
        return self.dataCount;
    return self.dataCount > 1 ? self.dataCount * self.dataTimes : self.dataCount;
}

#pragma mark - 代理_处理当拖拽开始与结束时,停止与开启定时器

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        _currentPage = scrollView.tag % self.dataCount;
        [self resetPosition];
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentPage = scrollView.tag % self.dataCount;
    [self resetPosition];
    [self setupTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetPosition];
}

#pragma mark - 代理

-(void)doSomeThingForMe:(id)obj withOrder:(NSString *)order
{
    if([order isEqualToString:@"MTDataSourceReloadDataAfterOrder"])
    {
           self.tag = 1;           
           [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.collectionView.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
           [self setupTimer];
    }
    else if([order isEqualToString:@"layoutSubviews"])
    {
        if(self.tag)
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.collectionView.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
            self.tag = 0;
        }
    }
}

- (void)didSetDataList:(NSArray*)dataList
{
    NSArray* arr = (NSArray*)[dataList getDataByIndex:0];
    if([arr isKindOfClass:[NSArray class]])
        self.dataCount = arr.count;
    else
        self.dataCount = 0;
    
    if(!self.isScrollLimit)
        self.collectionView.tag = self.dataCount > 1 ? self.dataCount * self.dataTimes * 0.5 : 0;
}

#pragma mark - 其他

-(void)dealloc
{
    [self stopTimer];
}

-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:[UICollectionView class]])
        return;
    
    self.collectionView = (UICollectionView*)object;
}





@end
