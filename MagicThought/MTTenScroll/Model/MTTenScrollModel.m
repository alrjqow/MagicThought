//
//  MTTenScrollModel.m
//  DaYiProject
//
//  Created by monda on 2018/12/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollModel.h"
#import "MTTenScrollContentView.h"
#import "MTTenScrollTitleView.h"
#import "MTTenScrollView.h"
#import "MTConst.h"


#import "MTWordStyle.h"
#import "UIView+Frame.h"
#import "NSObject+ReuseIdentifier.h"
#import "NSObject+API.h"
#import "MTBaseDataModel.h"

NSString* MTTenScrollIdentifier = @"MTTenScrollIdentifier";

@interface MTTenScrollModel ()
{
    NSArray* _dataList;
}

@property (nonatomic, strong) NSMutableArray *objectArr;

/**需要固定的 tenScrollView 集合*/
@property (nonatomic,strong) NSMutableArray<MTTenScrollView*>* fixSubTenScrollViewArr;

/**相对于父控件它的索引*/
@property (nonatomic,assign) NSInteger superIndex;

/**即时索引*/
@property (nonatomic,assign) NSInteger immediateIndex;

/**ccontentView 上次的偏移值*/
@property (nonatomic,assign) CGFloat preOffsetX;
@property (nonatomic,assign) CGFloat preTitleOffsetX;

/**ccontentView 是否向左滚动*/
@property (nonatomic,assign) BOOL isLeft;

/**ccontentView 是否正在滚动*/
@property (nonatomic,assign) BOOL isContentViewScrolling;

/**titleView 是否向左滚动*/
@property (nonatomic,assign) BOOL isTitleLeft;

@property (nonatomic,weak) MTTenScrollModel* subModel;

/**标题固定滚动*/
@property (nonatomic,assign) BOOL titleViewFixScroll;
@property (nonatomic,assign) NSInteger titleViewFixScrollCount;
/**标题是否正在滚动*/
@property (nonatomic,assign) BOOL isTitleViewScrolling;
/**标题是否点击*/
@property (nonatomic,assign) BOOL isTitleViewTap;

/**锁*/
@property (nonatomic,assign) BOOL lock;



@end

@implementation MTTenScrollModel


-(instancetype)init
{
    if(self = [super init])
    {
        _currentIndex = -1;
        self.contentViewFixOffset = 100;
        self.objectArr = [NSMutableArray array];
        self.fixSubTenScrollViewArr = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - tenScrollView

-(void)tenScrollViewWillBeginDragging
{
    [self contentViewScrollEnabled:false];
}

-(void)tenScrollViewEndScroll
{
    [self contentViewScrollEnabled:YES];
}

-(void)contentViewScrollEnabled:(BOOL)scrollEnabled
{
    MTTenScrollModel* currentModel = self;
    currentModel.contentView.scrollEnabled = scrollEnabled;
    currentModel.titleView.scrollEnabled = scrollEnabled;
    
    while (currentModel) {
        
        MTTenScrollModel* superModel = [self getSuperModel:currentModel];
        superModel.contentView.scrollEnabled = scrollEnabled;
        superModel.titleView.scrollEnabled = scrollEnabled;
        
        currentModel = superModel;
    }
}

-(void)tenScrollViewDidScroll
{
    [self resetTenscrollViewOffset];
    [self fixTenScrollViewScroll];
}

-(void)resetTenscrollViewOffset
{
    if(self.tenScrollView.offsetY >= self.tenScrollViewMaxOffsetY)
        return;
    
    if(!self.fixSubTenScrollViewArr.count)
        return;
    
    for (MTTenScrollView* tenScrollView in self.fixSubTenScrollViewArr) {
        if(tenScrollView.model.superIndex != self.currentIndex)
            tenScrollView.offsetY = 0;
    }
    
    [self.fixSubTenScrollViewArr removeAllObjects];
}

-(void)fixTenScrollViewScroll
{
    MTTenScrollView* tenScrollView = self.tenScrollView;
    CGFloat offsetY = tenScrollView.offsetY;
    
    if(tenScrollView.isScrollTop)
    {
        offsetY = [self fixTenScrollViewScrollTop];
    }
    else
    {
        offsetY = [self fixTenScrollViewScrollDown];
    }
    
    tenScrollView.offsetY = offsetY;
}


-(CGFloat)fixTenScrollViewScrollTop
{
    MTTenScrollView* tenScrollView = self.tenScrollView;
    CGFloat offsetY = tenScrollView.offsetY;
    
    MTTenScrollModel* superModel = [self getSuperModel:self];
    MTTenScrollView* superTenScrollView = superModel.tenScrollView;
    
    MTTenScrollModel* superModel2 = [self getSuperModel:superModel];
    MTTenScrollView* superTenScrollView2 = superModel2.tenScrollView;
    
    MTTenScrollModel* subModel = [self getSubModel:self];
    MTTenScrollView* subTenScrollView = subModel.tenScrollView;
    
    MTTenScrollModel* subModel2 = [self getSubModel:subModel];
    MTTenScrollView* subTenScrollView2 = subModel2.tenScrollView;

//    NSLog(@"%@",NSStringFromClass(self.delegate.class));
//    if([NSStringFromClass(self.delegate.class) isEqualToString:@"TestController3"])
//        NSLog(@"%lf === %zd",offsetY, self.tenScrollViewMaxOffsetY);

    
    if(!self.isChangeTenScrollViewMaxOffsetY)
    {
        if(self.currentView.offsetY > 0) ////
        {
                offsetY = self.tenScrollViewMaxOffsetY;
                return offsetY;
        }
        
        //不能滚
        if(superTenScrollView.offsetY < superModel.tenScrollViewMaxOffsetY) ////
        {
            offsetY = 0;
        }
        else
        {
            //不能滚
            if(superModel2.isChangeTenScrollViewMaxOffsetY && (superTenScrollView2.offsetY < superModel2.tenScrollViewMaxOffsetY2))
            {                
                offsetY = 0;
            }
        }
        
        if(offsetY >= self.tenScrollViewMaxOffsetY) ////
        {
                offsetY = self.tenScrollViewMaxOffsetY;
                superModel.isChangeTenScrollViewMaxOffsetY = YES;
            if(superTenScrollView)
            {
                if((subModel.tenScrollViewMaxOffsetY < 1) && (superTenScrollView.offsetY >= superModel.tenScrollViewMaxOffsetY2))
                    self.isChangeTenScrollViewMaxOffsetY = YES;
            }
            else
            {
                if(subModel.tenScrollViewMaxOffsetY < 1)
                   self.isChangeTenScrollViewMaxOffsetY = YES;
            }
        }
    }
    else
    {
        if(offsetY > self.tenScrollViewMaxOffsetY2)
        {
            offsetY = self.tenScrollViewMaxOffsetY2;            
        }
        
        if(subTenScrollView.offsetY > subModel.tenScrollViewMaxOffsetY)
            offsetY = self.tenScrollViewMaxOffsetY2;
        
        if(subTenScrollView2.offsetY > 0)
            offsetY = self.tenScrollViewMaxOffsetY2;
        
    }

    if(!tenScrollView.bounces && offsetY < 0)
    {
        offsetY = 0;
    }
    
    return offsetY;
}

-(CGFloat)fixTenScrollViewScrollDown
{
    MTTenScrollView* tenScrollView = self.tenScrollView;
    CGFloat offsetY = tenScrollView.offsetY;
    
    MTTenScrollModel* superModel = [self getSuperModel:self];
    MTTenScrollView* superTenScrollView = self.superTenScrollView;
    
//    MTTenScrollModel* superModel2 = [self getSuperModel:superModel];
//    MTTenScrollView* superTenScrollView2 = superModel2.tenScrollView;
    
    MTTenScrollModel* subModel = [self getSubModel:self];
    MTTenScrollView* subTenScrollView = subModel.tenScrollView;
    UIScrollView* subCurrentView2 = subModel.currentView;
    
    MTTenScrollModel* subModel2 = [self getSubModel:subModel];
    MTTenScrollView* subTenScrollView2 = subModel2.tenScrollView;
    
    if(!self.isChangeTenScrollViewMaxOffsetY)
    {
        if(self.currentView.offsetY > 0) ///
        {
            if(subModel2.tenScrollViewMaxOffsetY > 0)
                offsetY = self.tenScrollViewMaxOffsetY;
        }
        
        if(superTenScrollView.offsetY > superModel.tenScrollViewMaxOffsetY)
        {
//            if([self.currentView isKindOfClass:[MTDelegateTenScrollTableView class]])
//                NSLog(@" 222=== %lf", self.currentView.offsetY);
            offsetY = self.tenScrollViewMaxOffsetY;
        }
    }
    else
    {
        if(subTenScrollView.offsetY > subModel.tenScrollViewMaxOffsetY)
            offsetY = self.tenScrollViewMaxOffsetY2;
        
        if(subTenScrollView2.offsetY > 0)
            offsetY = self.tenScrollViewMaxOffsetY2;
        
        if(subCurrentView2.offsetY > 0)
            offsetY = self.tenScrollViewMaxOffsetY2;
        
        if(offsetY <= self.tenScrollViewMaxOffsetY)
        {
            self.isChangeTenScrollViewMaxOffsetY = false;
            
            if(self.currentView.offsetY > 0) ///
            {
//                if([self.currentView isKindOfClass:[MTDelegateTenScrollTableView class]])
//                    NSLog(@" 333=== %lf", self.currentView.offsetY);
                offsetY = self.tenScrollViewMaxOffsetY;
            }
        }
    }
    
    if(!tenScrollView.bounces && offsetY < 0)
    {
        offsetY = 0;
    }
    
    return offsetY;
}

#pragma mark - tenScrollTableView

-(void)tenScrollTableViewScrollDidScroll
{
    [self fixTenScrollTableViewScroll];
}

-(void)fixTenScrollTableViewScroll
{
    if(![self.currentView isKindOfClass:[MTDelegateTenScrollTableView class]])
        return;
    
    MTDelegateTenScrollTableView* tenScrollTableView = (MTDelegateTenScrollTableView*)self.currentView;
    CGFloat offsetY = tenScrollTableView.offsetY;
    CGFloat tenScrollOffsetY = self.tenScrollView.offsetY;
    NSInteger maxOffsetY = self.tenScrollViewMaxOffsetY;
    if(self.superTenScrollView)
    {
        tenScrollOffsetY = self.superTenScrollView.offsetY;
        maxOffsetY = self.superTenScrollView.model.tenScrollViewMaxOffsetY2;
    }
    
    if(tenScrollTableView.isScrollTop)
    {
        offsetY = [self fixTenScrollTableViewScrollTop];
    }
    else
    {
        offsetY = [self fixTenScrollTableViewScrollDown];
    }
    
    tenScrollTableView.offsetY = offsetY;
}

-(CGFloat)fixTenScrollTableViewScrollTop
{
    MTDelegateTenScrollTableView* tenScrollTableView = (MTDelegateTenScrollTableView*)self.currentView;
    CGFloat offsetY = tenScrollTableView.offsetY;
    
    NSInteger maxOffsetY = self.tenScrollViewMaxOffsetY;
    CGFloat tenScrollOffsetY = self.tenScrollView.offsetY;
    
    if(tenScrollOffsetY < maxOffsetY)
    {
            offsetY = 0;
    }
    else
    {
        if(self.superTenScrollView)
        {
            MTTenScrollView* superTenScrollView = self.superTenScrollView;
            MTTenScrollModel* superModel = superTenScrollView.model;
            if(superTenScrollView.offsetY < superModel.tenScrollViewMaxOffsetY2)
                offsetY = 0;
        }
    }
    
//    if(offsetY > 0)
//        NSLog(@"+++ %lf",offsetY);
    
    return offsetY;
}

-(CGFloat)fixTenScrollTableViewScrollDown
{
    MTDelegateTenScrollTableView* tenScrollTableView = (MTDelegateTenScrollTableView*)self.currentView;
    CGFloat offsetY = tenScrollTableView.offsetY;
    NSInteger maxOffsetY = self.tenScrollViewMaxOffsetY;
    
    if(offsetY < 0)
        offsetY = 0;
    
    if(offsetY > 0)
    {
//        NSLog(@"--- %lf === %lf",self.tenScrollView.offsetY, offsetY);
        
        if(self.tenScrollView.offsetY < maxOffsetY)
            offsetY = 0;
        else
        {
            self.tenScrollView.offsetY = maxOffsetY;
            if(self.superTenScrollView)
            {
                MTTenScrollView* superTenScrollView = self.superTenScrollView;
                MTTenScrollModel* superModel = superTenScrollView.model;
                superTenScrollView.offsetY = superModel.tenScrollViewMaxOffsetY2;
            }
        }
    }
        
    
    return offsetY;
}

#pragma mark - ContentView

-(void)contentViewWillBeginDragging
{
    self.superTenScrollView.model.currentView = self.tenScrollView;
    self.tenScrollView.scrollEnabled = false;
    self.currentView.scrollEnabled = false;
    self.isContentViewDragging = YES;
}

/**固定滚动时必要的offset*/
-(void)fixContentViewScrollingOffset
{
//
    [self fixSubContentViewScroll];
    
    if(!self.superTenScrollView)
        return;
    
    [self fixSuperContentViewScroll];
}

-(MTTenScrollModel*)getSuperModel:(MTTenScrollModel*)model
{
    return model.superTenScrollView.model;
}

-(MTTenScrollModel*)getSubModel:(MTTenScrollModel*)model
{
    if([model.currentView isKindOfClass:[MTTenScrollView class]])
        return ((MTTenScrollView*)model.currentView).model;
    
    return nil;
}
-(void)fixSubContentViewScroll
{
    MTTenScrollModel* subModel = [self getSubModel:self];
    MTTenScrollContentView* subContentView0 = subModel.contentView;
    CGFloat limitoffsetX = self.contentView.width * subModel.superIndex;
    NSInteger superIndex = subModel.superIndex;
    CGFloat subVelX = [subContentView0.panGestureRecognizer velocityInView:subContentView0].x;
    
    while (subModel) {
        
        if(!subModel.isContentViewDragging)
        {
            subModel = [self getSubModel:subModel];
            continue;
        }
        
        MTTenScrollContentView* subContentView = subModel.contentView;
        CGFloat subMinOffsetX = subModel.contentViewFixOffset;
        CGFloat subMaxOffsetX = subContentView.width * subModel.maxIndex - subModel.contentViewFixOffset;
        
        
        if(subContentView.offsetX > subMinOffsetX && subContentView.offsetX< subMaxOffsetX)
        {
            //                NSLog(@"====================111111111=====================");
            self.contentView.offsetX = limitoffsetX;
        }
        else
        {
            if((subContentView.offsetX <= subMinOffsetX) && (subVelX < 0) && (superIndex < 1))
            {
//                if(!self.superTenScrollView)
//                        NSLog(@"%zd === %lf === %lf === %lf", subModel.superIndex, subContentView.offsetX, subMinOffsetX, subVelX);
                self.contentView.offsetX = limitoffsetX;
            }
            else if((subContentView.offsetX >= subMaxOffsetX) && (subVelX > 0) && (superIndex > (subModel.maxIndex - 1)))
            {
                //                    NSLog(@"====================3333333=====================");
                self.contentView.offsetX = limitoffsetX;
            }
            else
            {
                
            }
        }
        
        subModel = [self getSubModel:subModel];
    }
}

-(BOOL)fixSuperContentViewScroll2
{
//    if([NSStringFromClass(self.delegate.class) isEqualToString:@"TestController2"])
//        NSLog(@"%@ === %zd === %d",NSStringFromClass(self.delegate.class), self.superIndex, self.subModel.isTitleViewScrolling);
    if(!self.subModel.isTitleViewScrolling)
    {
        return false;
    }
    
    MTTenScrollTitleView* subTitleView0 = self.subModel.titleView;
    CGFloat minOffsetX = -self.subModel.titleViewModel.margin;
    CGFloat maxOffsetX = floor(subTitleView0.contentSize.width + self.subModel.titleViewModel.margin - subTitleView0.width);
    
    if((subTitleView0.offsetX <= minOffsetX) || (subTitleView0.offsetX >= maxOffsetX))
    {
        return false;
    }
    

    CGFloat offsetX = self.contentView.offsetX / self.contentView.width;
    
    if((offsetX - (NSInteger)offsetX) != 0)
    {
        self.subModel.titleViewFixScrollCount += 1;
    }
    
//    self.contentView.offsetX = self.subModel.superIndex * self.contentView.width;
//    [self getSuperModel:self].subModel = self;
//    self.isTitleViewScrolling = YES;
    
//    MTTenScrollModel* currentModel = self;
//    while (currentModel) {
//        MTTenScrollModel* superModel = currentModel.superTenScrollView.model;
////        if([NSStringFromClass(superModel.delegate.class) isEqualToString:@"TestController"])
////            NSLog(@"%zd",currentModel.superIndex);
//        superModel.contentView.offsetX = currentModel.superIndex * superModel.contentView.width;
//        currentModel = superModel;
//    }
    return YES;
}

-(void)fixSuperContentViewScroll
{
    CGFloat minOffsetX = self.contentViewFixOffset;
    CGFloat maxOffsetX = self.contentView.width * self.maxIndex - self.contentViewFixOffset;
    CGFloat velX = [self.contentView.panGestureRecognizer velocityInView:self.contentView].x;
    
    MTTenScrollModel* currentModel = self;
    
    while (currentModel) {
    
        MTTenScrollModel* superModel = currentModel.superTenScrollView.model;
        MTTenScrollContentView* superContentView = superModel.contentView;
        
        if((self.contentView.offsetX > minOffsetX) && (self.contentView.offsetX < maxOffsetX))
        {
            //        NSLog(@"====================4444444=====================");
            superContentView.offsetX = superContentView.width * currentModel.superIndex;
        }
        else
        {
            if((self.contentView.offsetX <= minOffsetX) && (velX < 0))
            {
                //            NSLog(@"====================5555555=====================");
                superContentView.offsetX = superContentView.width * currentModel.superIndex;
            }
            else if((self.contentView.offsetX >= maxOffsetX) && (velX > 0))
            {
                //            NSLog(@"====================6666666=====================");
                superContentView.offsetX = superContentView.width * currentModel.superIndex;
            }
            else
            {
                
            }
        }
        
        
        currentModel = superModel;
    }
}

-(void)contentViewDidScroll
{
//    NSLog(@"%@ === %zd === %d",NSStringFromClass(self.delegate.class), self.superIndex, self.subModel.isTitleViewScrolling);
//    return;
//    if([self fixSuperContentViewScroll2])
//        return;
    
    [self fixContentViewScrollingOffset];
//        return;
    
    if(self.isTitleViewTap)
        return;
    
    CGFloat currentOffsetX = self.contentView.offsetX;
//    if(!self.superTenScrollView)
//        NSLog(@"%lf",currentOffsetX);
    if(currentOffsetX == self.preOffsetX)
        return;
    
    self.isLeft = currentOffsetX < self.preOffsetX;
    
    CGFloat currentIndex = currentOffsetX / self.contentView.width;
    
    CGFloat scale = currentIndex - ((NSInteger)currentIndex);
    self.immediateIndex = currentIndex;
    
    NSInteger nextIndex = floor(currentIndex);
    if(nextIndex == self.immediateIndex)
        nextIndex = ceil(currentIndex);
    
    
    NSInteger startIndex = self.isLeft ? nextIndex : self.immediateIndex;
    NSInteger endIndex = self.isLeft ? self.immediateIndex : nextIndex;
    if(self.isLeft)
        scale = 1 - scale;
    
    if(startIndex < 0)
        startIndex = 0;
    if(endIndex < 0)
        endIndex = 0;
    
    if(startIndex > self.maxIndex)
        startIndex = self.maxIndex;
    if(endIndex > self.maxIndex)
        endIndex = self.maxIndex;
    
    //    return;
    MTTenScrollTitleCell* currentCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow: startIndex inSection:0]];
    
    NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:endIndex inSection:0];
    MTTenScrollTitleCell* nextCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:endIndex  inSection:0]];
    
//    if(!self.superTenScrollView)
//        NSLog(@"前后索引：==== %zd ==== %zd", startIndex, endIndex);
    
    [self colorChangeCurrentTitleCell:currentCell nextCell:nextCell changeScale:scale];
    [self fontSizeChangeCurrentTitleCell:currentCell nextCell:nextCell changeScale:scale];
    
    CGFloat beginCenterX = currentCell.centerX;
    CGFloat distanceOffset = fabs(beginCenterX - nextCell.centerX) * scale * (self.isLeft ? -1 : 1);
    self.titleView.bottomLine.centerX = beginCenterX + distanceOffset;
    
    CGFloat beginWidth = currentCell.title.width;
    CGFloat nextWidth = nextCell.title.width;
    CGFloat widthOffset = fabs(beginWidth - nextWidth) * scale * ((beginWidth > nextWidth) ? -1 : 1);
    self.titleView.bottomLine.width = beginWidth + widthOffset;
    
    
    self.isContentViewScrolling = YES;
    [self.titleView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.preOffsetX = currentOffsetX;
}

-(void)didContentViewEndScrollWithDecelerate:(BOOL)decelerate
{
    CGFloat currentIndex = self.contentView.offsetX / self.contentView.width;
    if((currentIndex - (NSInteger)currentIndex) != 0)
        return;
    
    
    self.tenScrollView.scrollEnabled = YES;
    self.currentView.scrollEnabled = YES;
    self.isContentViewDragging = false;
    self.currentIndex = currentIndex;
    //        if(!self.superTenScrollView)
    //            NSLog(@"拖拽结束索引：%lf", currentIndex);
}


#pragma mark - TitleView

-(void)titleViewWillBeginDragging
{
//    MTTenScrollModel* currentModel = self;
//    while (currentModel) {
//        MTTenScrollModel* superModel = currentModel.superTenScrollView.model;
//        superModel.subModel = self;
//        currentModel = superModel;
//    }
    
    self.isTitleViewScrolling = YES;
    self.tenScrollView.scrollEnabled = false;
    self.titleViewFixScroll = false;
    self.isContentViewScrolling = false;
}


-(void)titleViewDidScroll
{
    if(self.isContentViewScrolling)
        return;
    
    static CGFloat preOffsetX = 0;
    if(self.titleView.contentSize.width == 0)
        return;
    
    CGFloat minOffsetX = -self.titleViewModel.margin;
    CGFloat maxOffsetX = self.titleView.contentSize.width + self.titleViewModel.margin - self.titleView.width;
    maxOffsetX = floor(maxOffsetX);

    
    if(!self.superTenScrollView)
    {
        if(self.titleView.offsetX < minOffsetX)
            self.titleView.offsetX = minOffsetX;
        
        if(self.titleView.offsetX > maxOffsetX)
            self.titleView.offsetX = maxOffsetX;
        return;
    }
    
    
    if(self.titleViewFixScroll)
        self.titleView.offsetX = preOffsetX;
    else
    {
        if(self.titleView.offsetX < minOffsetX)
            self.titleView.offsetX = minOffsetX;
        
        if(self.titleView.offsetX > maxOffsetX)
            self.titleView.offsetX = maxOffsetX;
    }
    
//        NSLog(@"ccccc === %lf === %lf === %lf", self.titleView.offsetX, minOffsetX, maxOffsetX);
    
    if(self.titleView.offsetX > minOffsetX && self.titleView.offsetX< maxOffsetX)
    {
        self.superTenScrollView.model.contentView.offsetX = self.superTenScrollView.model.contentView.offsetX;
        
//        self.superTenScrollView.model.contentView.width * self.superIndex;
//        MTTenScrollModel* currentModel = self.superTenScrollView.model;
//        while (currentModel) {
//            MTTenScrollModel* superModel = currentModel.superTenScrollView.model;
//            superModel.contentView.offsetX = currentModel.superIndex * superModel.contentView.width;
//            currentModel = superModel;
//        }
    }
    else
    {
        NSInteger offsetX = [self.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;
        
//        NSLog(@"%zd", offsetX);

        if(self.titleView.offsetX <= minOffsetX)
        {
            preOffsetX = minOffsetX;
            self.titleViewFixScroll = offsetX > 0;
        }
        
        if(self.titleView.offsetX >= maxOffsetX)
        {
            preOffsetX = maxOffsetX;
            self.titleViewFixScroll = offsetX < 0;
        }
    }
}

-(void)didTitleViewEndScroll
{
    self.isTitleViewScrolling = false;
    self.tenScrollView.scrollEnabled = YES;
    self.titleViewFixScroll = false;    
}

-(void)didTitleViewSelectedItem
{
    self.isTitleViewTap = YES;
    [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    self.isTitleViewTap = false;
}

#pragma mark - 缓存
-(UIView*)getViewByIndex:(NSInteger)index
{
    return [self getViewtByIndex:index isBandData:YES];
}

/**获取view*/
-(UIView*)getViewtByIndex:(NSInteger)index isBandData:(BOOL)isBand
{
    NSObject* object;
    if(index < self.objectArr.count)
        object = self.objectArr[index];
    else
        _currentIndex = -1;
    
    if([object isKindOfClass:[NSString class]] && ([((NSString*)object) isEqualToString:@""]) && (index < self.objectArr.count))
    {
        NSObject* obj = self.dataList[index];
        Class c = NSClassFromString(obj.mt_reuseIdentifier);
        obj = c.new;
        
        if([obj isKindOfClass:[UIView class]] || [obj isKindOfClass:[UIViewController class]])
            self.objectArr[index] = obj;
        else
            self.objectArr[index] = @"1";
        
        object = obj;
    }
        
    if(![object isKindOfClass:[UIView class]] && ![object isKindOfClass:[UIViewController class]])
        object = nil;
    
    if(isBand)
    {
        /**绑定数据*/
        MTBaseDataModel* model = [MTBaseDataModel new];
        NSObject* data = [self.dataList getDataByIndex:index];
        model.data = [data isKindOfClass:[NSReuseObject class]] ? ((NSReuseObject*)data).data : data;
        model.identifier = MTTenScrollIdentifier;
        if([object respondsToSelector:@selector(whenGetTenScrollDataModel:)])
            [object whenGetTenScrollDataModel:model];        
    }
    
    if(object && self.currentIndex < 0)
    {
        self.currentIndex = index;
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.titleView collectionView:self.titleView willDisplayCell:[self.titleView cellForItemAtIndexPath:indexPath] forItemAtIndexPath:indexPath];
    }
    
    
    UIView* view;
    if([object isKindOfClass:[UIView class]])
        view = (UIView*)object;
    else
        view = ((UIViewController*)object).view;
    
    return view;
}

-(void)setUpCurrentViewByIndex:(NSInteger)index
{
    UIView* superView = [self getViewtByIndex:index isBandData:false];
    
    if([self.currentView isKindOfClass:[MTTenScrollView class]] && (self.currentView.offsetY > 0))
    {
        [self.fixSubTenScrollViewArr addObject:(MTTenScrollView*)self.currentView];
    }
    
    self.currentView = nil;
    for(UIView* subView in superView.subviews)
    {
        if([subView isKindOfClass:[MTDelegateTenScrollTableView class]] || [subView isKindOfClass:[MTTenScrollView class]])
        {
            NSInteger offsetY = self.tenScrollView.offsetY;
            if([subView isKindOfClass:[MTTenScrollView class]])
            {
                MTTenScrollView* subTenScrollView = (MTTenScrollView*)subView;
                subTenScrollView.model.superTenScrollView = self.tenScrollView;
                subTenScrollView.bounces = false;
                
                if(offsetY > self.tenScrollViewMaxOffsetY)
                    [UIView animateWithDuration:0.1 animations:^{
                        subTenScrollView.offsetY = subTenScrollView.model.tenScrollViewMaxOffsetY;
                    }];
            }
            else
            {
                ((MTDelegateTenScrollTableView*)subView).model = self;
                subView.height = self.tenScrollHeight - self.titleViewModel.titleViewHeight;
            }
            
            self.currentView = (UIScrollView*)subView;
            self.currentView.showsVerticalScrollIndicator = false;
            self.currentView.showsHorizontalScrollIndicator = false;
            
            if(offsetY < self.tenScrollViewMaxOffsetY)
                [UIView animateWithDuration:0.1 animations:^{
                    self.currentView.offsetY = 0;
                }];
        }
    }
}

-(void)fixCurrentViewOffsetByIndex:(NSInteger)index
{
    UIView* superView = [self getViewtByIndex:index isBandData:false];
    for(UIView* subView in superView.subviews)
    {
        if([subView isKindOfClass:[MTDelegateTenScrollTableView class]] || [subView isKindOfClass:[MTTenScrollView class]])
        {
            NSInteger offsetY = self.tenScrollView.offsetY;
            if([subView isKindOfClass:[MTTenScrollView class]])
            {
                MTTenScrollView* subTenScrollView = (MTTenScrollView*)subView;
                if(offsetY > self.tenScrollViewMaxOffsetY)
                    subTenScrollView.offsetY = subTenScrollView.model.tenScrollViewMaxOffsetY;
            }
        
            if(offsetY < self.tenScrollViewMaxOffsetY)
                ((UIScrollView*)subView).offsetY = 0;
        }
    }
}

-(void)fixBrotherViewOffset
{
//    NSInteger index = self.currentIndex;
//
//    [self fixCurrentViewOffsetByIndex:(index - 1)];
//
//    NSLog(@"%zd",index);
//    [self fixCurrentViewOffsetByIndex:(index + 1)];
}

#pragma mark - 文字颜色渐变

- (void)colorChangeCurrentTitleCell:(MTTenScrollTitleCell *)currentCell nextCell:(MTTenScrollTitleCell *)nextCell changeScale:(CGFloat)scale {
    
    if(currentCell == nextCell)
        return;
    
    //选中颜色
    CGFloat sel_red;
    CGFloat sel_green;
    CGFloat sel_blue;
    CGFloat sel_alpha;
    
    //未选中的颜色
    CGFloat de_sel_red = 0.0;
    CGFloat de_sel_green = 0.0;
    CGFloat de_sel_blue = 0.0;
    CGFloat de_sel_alpha = 0.0;
    
    
    if ([self.titleViewModel.selectedStyle.wordColor getRed:&sel_red green:&sel_green blue:&sel_blue alpha:&sel_alpha] && [self.titleViewModel.normalStyle.wordColor getRed:&de_sel_red green:&de_sel_green blue:&de_sel_blue alpha:&de_sel_alpha]) {
        //颜色的变化的大小
        CGFloat red_changge = sel_red - de_sel_red;
        CGFloat green_changge = sel_green - de_sel_green;
        CGFloat blue_changge = sel_blue - de_sel_blue;
        CGFloat alpha_changge = sel_alpha - de_sel_alpha;
        //颜色变化
        
        
        nextCell.title.textColor = [UIColor colorWithRed:(de_sel_red + red_changge * scale) green: (de_sel_green + green_changge * scale) blue:(de_sel_blue + blue_changge * scale) alpha: (de_sel_alpha + alpha_changge * scale)];
        
        currentCell.title.textColor = [UIColor colorWithRed:sel_red - red_changge * scale
                                                      green:sel_green - green_changge * scale
                                                       blue:sel_blue - blue_changge * scale
                                                      alpha:sel_alpha - alpha_changge * scale];
    }
}

#pragma mark - 文字大小变化
- (void)fontSizeChangeCurrentTitleCell:(MTTenScrollTitleCell *)currentCell nextCell:(MTTenScrollTitleCell *)nextCell changeScale:(CGFloat)scale
{
    if(currentCell == nextCell)
        return;
    
    CGFloat fontSizeOffset = self.titleViewModel.selectedStyle.wordSize - self.titleViewModel.normalStyle.wordSize;
    
    CGFloat currentFontSize = self.titleViewModel.selectedStyle.wordSize - fontSizeOffset * scale;
    CGFloat nextFontSize = self.titleViewModel.normalStyle.wordSize + fontSizeOffset * scale;
    
    
    if (@available(iOS 8.2, *)) {
        
        CGFloat currentFontWeight = self.titleViewModel.selectedStyle.wordBold ? UIFontWeightBold : (self.titleViewModel.selectedStyle.wordThin ? UIFontWeightThin : UIFontWeightRegular);
        
        CGFloat nextFontWeight = self.titleViewModel.normalStyle.wordBold ? UIFontWeightBold : (self.titleViewModel.selectedStyle.wordThin ? UIFontWeightThin : UIFontWeightRegular);
        
        CGFloat fontWeightOffset = currentFontWeight - nextFontWeight;
        
        currentCell.title.font = [UIFont systemFontOfSize:currentFontSize weight:(currentFontWeight - fontWeightOffset * scale)];
        nextCell.title.font = [UIFont systemFontOfSize:nextFontSize weight:(nextFontWeight + fontWeightOffset * scale)];
    } else {
        
        currentCell.title.font = mt_font(currentFontSize);
        nextCell.title.font = mt_font(nextFontSize);
    }
    
    [currentCell.title sizeToFit];
    [nextCell.title sizeToFit];
}


#pragma mark - 懒加载

-(NSInteger)tenScrollViewMaxOffsetY2
{
    return self.tenScrollViewMaxOffsetY + self.titleViewModel.titleViewHeight;
}

-(NSInteger)tenScrollViewMaxOffsetY
{
    return self.tenScrollView.contentSize.height - self.tenScrollHeight;
}

-(NSInteger)maxIndex
{
    NSInteger maxIndex = self.dataList.count - 1;
    if(maxIndex < 0)
        maxIndex = 0;
    
    return maxIndex;
}

-(void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    [self.objectArr removeAllObjects];
    NSMutableArray* arr = [NSMutableArray array];
    
    Class c1, c2;
    for(NSObject* obj in dataList)
    {
        [arr addObject:obj.mt_tagIdentifier];
        [self.objectArr addObject:@""];
        
        if(!_tenScrollHeight)
        {
            if(!c1)
                c1 = NSClassFromString(@"MTTenScrollController");
            if(!c2)
                c2 = [MTTenScrollView class];
            Class c = NSClassFromString(obj.mt_reuseIdentifier);

            if(![c.new isKindOfClass:c1] && ![c.new isKindOfClass:c2])
                _tenScrollHeight = self.tenScrollView.height;
        }
    }

    _titleList = [arr copy];
}

-(NSArray *)dataList
{
    if(!_dataList && [self.delegate respondsToSelector:@selector(tenScrollDataList)] && (self.delegate.tenScrollDataList.count > 0))
    {
        self.dataList = self.delegate.tenScrollDataList;
    }
    
    return _dataList;
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    if(_currentIndex == currentIndex)
        return;
    
    _currentIndex = currentIndex;
    self.immediateIndex = currentIndex;
    [self setUpCurrentViewByIndex:currentIndex];
}

-(MTTenScrollTitleViewModel *)titleViewModel
{
    if(!_titleViewModel)
    {
        _titleViewModel = [MTTenScrollTitleViewModel new];
    }
    
    return _titleViewModel;
}

-(NSObject *)tenScrollData
{
    if(!self.dataList)
        self.dataList = self.dataList;
    return mt_reuse(self).band(@"MTTenScrollViewCell").bandHeight(self.tenScrollHeight);
}

-(CGFloat)tenScrollHeight
{
    return _tenScrollHeight ? _tenScrollHeight : (self.tenScrollView.height + self.titleViewModel.titleViewHeight);
}

@end
