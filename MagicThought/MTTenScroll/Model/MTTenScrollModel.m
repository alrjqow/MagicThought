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

@property (nonatomic,weak) MTTenScrollView* tenScrollView;

@property (nonatomic,weak) MTTenScrollView* superTenScrollView;

@property (nonatomic,weak) MTTenScrollContentView* contentView;

@property (nonatomic,weak) MTTenScrollTitleView* titleView;

@property (nonatomic,weak) UIScrollView* currentView;

@property (nonatomic, strong) NSMutableArray *objectArr;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong,readonly) NSObject* tenScrollData;

@property (nonatomic,strong) NSMutableDictionary* subModelList;

/**tenScrollView固定的偏移值*/
@property (nonatomic,assign, readonly) NSInteger tenScrollViewMaxOffsetY;
@property (nonatomic,assign, readonly) NSInteger tenScrollViewMaxOffsetY2;

/**固定样式*/
@property (nonatomic,assign) BOOL wordStyleChange;

/**titleView固定的偏移值*/
@property (nonatomic,assign) CGFloat titleViewFixOffset;

/**需要固定的 tenScrollView 集合*/
@property (nonatomic,strong) NSMutableArray<MTTenScrollView*>* fixSubTenScrollViewArr;

@property (nonatomic,weak) MTTenScrollModel* subModel;

/**相对于父控件它的索引*/
@property (nonatomic,assign) NSInteger superIndex;

/**最大索引*/
@property (nonatomic,assign, readonly) NSInteger maxIndex;

/**标题上次的偏移值*/
@property (nonatomic,assign) CGFloat preTitleOffsetX;
/**标题固定滚动*/
@property (nonatomic,assign) BOOL titleViewFixScroll;
/**标题是否点击*/
@property (nonatomic,assign) BOOL isTitleViewTap;

@property (nonatomic,assign) NSInteger minIndex;
@property (nonatomic,assign) NSInteger maxIndex1;

@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger lastStatus;

/**contentView是否有被拖拽*/
@property (nonatomic,assign,readonly) BOOL isContentViewDragging;

@property (nonatomic,assign) BOOL isDraging;

@property (nonatomic,assign) NSInteger directionTag;

@property (nonatomic,assign) CGFloat preCurrentIndex;

@property (nonatomic,assign) NSInteger unknownCellIndex;

@property (nonatomic,assign) BOOL isUnknownCell;

@property (nonatomic,strong) NSMutableDictionary* cellWidthList;
@property (nonatomic,strong) NSMutableDictionary* cellCenterXList;

@property (nonatomic,strong,readonly) NSArray* titleList;

@end

@implementation MTTenScrollModel


-(instancetype)init
{
    if(self = [super init])
    {
        _currentIndex = -1;
        self.contentViewFixOffset = 80;
        self.wordStyleChange = YES;
//        self.titleViewFixOffset = 40;
        self.objectArr = [NSMutableArray array];
        self.fixSubTenScrollViewArr = [NSMutableArray array];
        self.subModelList = [NSMutableDictionary dictionary];
        self.cellWidthList = [NSMutableDictionary dictionary];
        self.cellCenterXList = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - tenScrollView

-(void)tenScrollViewWillBeginDragging
{
    self.superTenScrollView.model.subModel = self;
    if(self.tenScrollViewMaxOffsetY == 0)
        self.status = 2;
    [self contentViewScrollEnabled:false];
}

-(void)tenScrollViewEndScroll
{
    MTTenScrollModel* model = self;
    do {
        if(model.tenScrollView.dragging || model.tenScrollView.decelerating)
        {
            return;
        }
        
        
        model = model.superTenScrollView.model;
    } while (model);
    
    [self contentViewScrollEnabled:YES];    
}

-(void)contentViewScrollEnabled:(BOOL)scrollEnabled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationTenScrollViewScroll" object:nil userInfo:@{@"canScroll" : @(scrollEnabled)}];
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
    CGFloat offsetY = self.tenScrollView.offsetY;
    MTTenScrollModel* superModel = self.superTenScrollView.model;
    MTTenScrollView* superTenScrollView = superModel.tenScrollView;
    superModel.subModel = self;
    
    MTTenScrollModel* superModel2 = superModel.superTenScrollView.model;
    
    MTTenScrollModel* subModel = self.subModel;
    if(!subModel)
    {
        subModel = self.subModelList[[NSString stringWithFormat:@"%zd", self.currentIndex]];
        if(subModel.tenScrollViewMaxOffsetY == 0)
            subModel.status = 2;
    }
    
    MTTenScrollView* subTenScrollView = subModel.tenScrollView;
    
    UIScrollView* tenScrollTableView;
    if(!subModel && [self.currentView isKindOfClass:[MTDelegateTenScrollTableView class]])
    {
        tenScrollTableView = self.currentView;
    }
    
    UIScrollView* subTenScrollTableView;
    if(subModel && [subModel.currentView isKindOfClass:[MTDelegateTenScrollTableView class]])
    {
        subTenScrollTableView = subModel.currentView;
    }
    
    if(offsetY <= 0)
    {
        if(self.tenScrollViewMaxOffsetY > 0)
        {
            self.status = 0;
            if(superModel)
                offsetY = 0;
        }
        else if(self.tenScrollViewMaxOffsetY == 0)
        {
            if(offsetY < self.tenScrollViewMaxOffsetY)
                self.status = 0;
            else
                self.status = 2;
        }
                    
        if(self.lastStatus > 1)
        {
            if(subModel.status > 0 && subModel.tenScrollViewMaxOffsetY > 0)
            {
                    self.status = self.lastStatus;
                    offsetY = self.tenScrollViewMaxOffsetY;
            }
            if(tenScrollTableView.offsetY > 0)
            {
                    self.status = self.lastStatus;
                    offsetY = self.tenScrollViewMaxOffsetY;
            }
            if(superModel.status > 1 && superTenScrollView.offsetY > superModel.tenScrollViewMaxOffsetY)
            {
                self.status = self.lastStatus;
                offsetY = self.tenScrollViewMaxOffsetY;
            }
        }
    }
    else if(offsetY > 0 && offsetY < self.tenScrollViewMaxOffsetY)
    {
        self.status = 1;
                            
        if(superModel && superModel.status < 2)
                offsetY = 0;
        
        if(superModel.status > 1)
        {
            if(superModel2 && superModel2.status < 3)
            {
                    offsetY = 0;
            }
        }
        
        if(self.lastStatus > 1)
        {
            if(subModel.status > 0 && subModel.tenScrollViewMaxOffsetY > 0)
            {
                self.status = self.lastStatus;
                offsetY = self.tenScrollViewMaxOffsetY;
            }
            if(tenScrollTableView.offsetY > 0)
            {
                    self.status = self.lastStatus;
                    offsetY = self.tenScrollViewMaxOffsetY;
            }
            if(superModel.status > 1 && superTenScrollView.offsetY > superModel.tenScrollViewMaxOffsetY)
            {
                self.status = self.lastStatus;
                offsetY = self.tenScrollViewMaxOffsetY;
            }
        }
            
    }
    else if(offsetY >= self.tenScrollViewMaxOffsetY && offsetY < self.tenScrollViewMaxOffsetY2)
    {
        self.status = 2;
        
        if(subModel)
        {
            if(subModel.status < 2)
                offsetY = self.tenScrollViewMaxOffsetY;
            else if(subModel.tenScrollViewMaxOffsetY <= 0)
            {
                if(superModel && superModel.status < 3)
                    offsetY = self.tenScrollViewMaxOffsetY;
            }
        }
        else
        {
            if(!superModel)
            {
                offsetY = self.tenScrollViewMaxOffsetY;
            }
        }
        
        if(self.lastStatus > 2)
        {
              if(subModel.subModel.status > 0)
              {
                  if(subModel.subModel.tenScrollViewMaxOffsetY > 0)
                  {
                      self.status = self.lastStatus;
                      offsetY = self.tenScrollViewMaxOffsetY2;
                  }
                  else
                  {                      
                      if(subTenScrollView.offsetY > subModel.tenScrollViewMaxOffsetY)
                      {
                          self.status = self.lastStatus;
                          offsetY = self.tenScrollViewMaxOffsetY2;
                      }
                  }
              }
            
            if(subTenScrollTableView.offsetY > 0)
            {
                self.status = self.lastStatus;
                offsetY = self.tenScrollViewMaxOffsetY2;
            }
        }
    }
    else
    {
        if(tenScrollTableView)
        {
            self.status = 2;
            offsetY = self.tenScrollViewMaxOffsetY;
        }
        else
        {
            if(subModel && subModel.status < 2)
            {
                self.status = 2;
                offsetY = self.tenScrollViewMaxOffsetY;
            }
            else
            {
                self.status = 3;
                offsetY = self.tenScrollViewMaxOffsetY2;
            }
        }
    }
    
    self.lastStatus = self.status;
    self.tenScrollView.offsetY = offsetY;
}

#pragma mark - tenScrollTableView

-(void)tenScrollTableViewScrollDidScroll
{
    if(![self.currentView isKindOfClass:[MTDelegateTenScrollTableView class]])
        return;
    
    CGFloat offsetY = self.currentView.offsetY;
    CGFloat tenScrollOffsetY = self.tenScrollView.offsetY;
    
    if(tenScrollOffsetY < self.tenScrollViewMaxOffsetY)
        offsetY = 0;
    
    if(self.superTenScrollView && self.superTenScrollView.model.lastStatus < 3)
        offsetY = 0;
    
    if(offsetY < 0)
        offsetY = 0;
    
    self.superTenScrollView.model.subModel = self;
    if(self.tenScrollViewMaxOffsetY == 0)
        self.status = 2;
    
    self.currentView.offsetY = offsetY;
}

#pragma mark - ContentView

-(void)contentViewWillBeginDragging
{
    self.superTenScrollView.model.isDraging = YES;
    self.superTenScrollView.model.currentView = self.tenScrollView;
    self.tenScrollView.scrollEnabled = false;
    self.currentView.scrollEnabled = false;
    self.titleView.scrollEnabled = false;
    _isContentViewDragging = YES;
}


/**固定滚动时必要的offset*/
-(BOOL)fixContentViewScrollingOffset4:(MTTenScrollModel*)subModel2
{
    CGFloat index = self.contentView.offsetX / self.contentView.width;
    NSInteger minIndex = floor(index);
    NSInteger maxIndex = ceil(index);
    
    
    if((minIndex == self.minIndex) && (maxIndex == self.maxIndex1))
     {
         return false;
     }

     if(minIndex == maxIndex)
     {
         self.minIndex = self.maxIndex1 = minIndex;
         return false;
     }
    
    NSInteger currentIndex = 0;
    if(minIndex == self.maxIndex1)
    {
        currentIndex = minIndex;
    }
        
    if(maxIndex == self.minIndex)
    {
        currentIndex = maxIndex;
    }
    
    
    NSInteger offsetX = [self.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;
    if(offsetX != 0)
    {
        self.contentView.offsetX = self.contentView.width * currentIndex;
        return YES;
    }
    
    MTTenScrollModel* subModel = subModel2 ? subModel2 : self.subModelList[[NSString stringWithFormat:@"%zd", currentIndex]];
    if(!subModel)
    {
        self.minIndex = minIndex;
        self.maxIndex1 = maxIndex;
        return false;
    }
      
    if(subModel.contentView.isRolling)
    {
        return [self fixContentViewScrollingOffset5:subModel MinIndex:minIndex MaxIndex:maxIndex CurrentIndex:currentIndex];
    }
    
    if(subModel.titleView.isRolling)
    {
        return [self fixContentViewScrollingOffset6:subModel MinIndex:minIndex MaxIndex:maxIndex CurrentIndex:currentIndex];
    }
    
    if(self.isDraging)
    {
        self.contentView.offsetX = self.contentView.width * currentIndex;
        return YES;
    }

    return false;
}

-(BOOL)fixContentViewScrollingOffset5:(MTTenScrollModel*)subModel MinIndex:(NSInteger)minIndex MaxIndex:(NSInteger)maxIndex CurrentIndex:(NSInteger)currentIndex
{
      UIScrollView* subScrollView = subModel.contentView;
      CGFloat subMinOffsetX = subModel.contentViewFixOffset;
      CGFloat subMaxOffsetX = subScrollView.width * subModel.maxIndex - subModel.contentViewFixOffset;
      
      if(subScrollView.offsetX > subMinOffsetX && subScrollView.offsetX< subMaxOffsetX)
      {
          self.contentView.offsetX = self.contentView.width * currentIndex;
          return YES;
      }
      else
      {
          NSInteger offsetX = [subModel.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;
          
          if(subScrollView.offsetX <= subMinOffsetX)
          {
              if(offsetX <= 0)
              {
                  self.contentView.offsetX = self.contentView.width * currentIndex;
                  return YES;
              }
              else
              {
                  if((subModel.superTenScrollView.model != self) && (subModel.superIndex == subModel.superTenScrollView.model.maxIndex))
                  {
                      self.contentView.offsetX = self.contentView.width * currentIndex;
                      return YES;
                  }
                  else
                  {
                      
                  }
                      
                  CGFloat index = subScrollView.offsetX / subScrollView.width;
                  NSInteger minIndex = floor(index);

                  NSInteger currentIndex = minIndex;
                  MTTenScrollModel* subModel2 = subModel.subModelList[[NSString stringWithFormat:@"%zd", currentIndex]];
                  
                  if(subModel2 && [self fixContentViewScrollingOffset4:subModel2])
                  {
                      return YES;
                  }
                  else
                  {
                      
                  }
              }
          }
     
          
          if(subScrollView.offsetX >= subMaxOffsetX)
          {
              if(offsetX >= 0)
              {
                  self.contentView.offsetX = self.contentView.width * currentIndex;
                  return YES;
              }
              else
              {
                  if((subModel.superTenScrollView.model != self) && (subModel.superIndex == 0))
                  {
                      self.contentView.offsetX = self.contentView.width * currentIndex;
                      return YES;
                  }
                  
                  CGFloat index = subScrollView.offsetX / subScrollView.width;
                  NSInteger maxIndex = ceil(index);
                                    
                  NSInteger currentIndex = maxIndex;
                  MTTenScrollModel* subModel2 = subModel.subModelList[[NSString stringWithFormat:@"%zd", currentIndex]];
                  
                  if(subModel2 && [self fixContentViewScrollingOffset4:subModel2])
                  {
                      return YES;
                  }
              }
          }
     
          self.minIndex = minIndex;
          self.maxIndex1 = maxIndex;
      }
    
    return false;
}

-(BOOL)fixContentViewScrollingOffset6:(MTTenScrollModel*)subModel MinIndex:(NSInteger)minIndex MaxIndex:(NSInteger)maxIndex CurrentIndex:(NSInteger)currentIndex
{
        UIScrollView* subScrollView = subModel.titleView;
         CGFloat subMinOffsetX = -subModel.titleViewModel.margin;
         CGFloat subMaxOffsetX = floor(subModel.titleView.contentSize.width - subModel.titleView.width + subModel.titleViewModel.margin);
    
         if(subScrollView.offsetX > subMinOffsetX && subScrollView.offsetX< subMaxOffsetX)
         {
             if(!self.contentView.isDecelerating)
             {
                 self.contentView.offsetX = self.contentView.width * currentIndex;
                 return YES;
             }
         }
         else
         {
             NSInteger offsetX = [subModel.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;
                   
                   if(subScrollView.offsetX <= subMinOffsetX)
                   {
                       if(offsetX <= 0)
                       {
                           if(!self.contentView.isDecelerating)
                           {
                               self.contentView.offsetX = self.contentView.width * currentIndex;
                               return YES;
                           }
                       }
                       else
                       {
                           
                       }
                   }
                   
                   if(subScrollView.offsetX >= subMaxOffsetX)
                   {
                       if(offsetX >= 0)
                       {
                           if(!self.contentView.isDecelerating)
                           {
                               self.contentView.offsetX = self.contentView.width * currentIndex;
                               return YES;
                           }
                       }
                       else
                       {
                           
                       }
                   }
         }
    
    self.minIndex = minIndex;
    self.maxIndex1 = maxIndex;
    return false;
}

-(void)contentViewDidScroll
{
    if(self.isTitleViewTap)
         return;
     
     [self fixContentViewScrollingOffset4:nil];
    
    CGFloat floatCurrentIndex = self.contentView.offsetX / self.contentView.width;
    if(floatCurrentIndex > self.preCurrentIndex)
        self.directionTag = 1;
    else if(floatCurrentIndex == self.preCurrentIndex)
        self.directionTag = 0;
    else
        self.directionTag = -1;
            
    NSInteger currentIndex = floatCurrentIndex;
    NSInteger preCurrentIndex = self.preCurrentIndex;
            
    if(currentIndex > self.maxIndex)
        currentIndex = self.maxIndex;
    CGFloat rate = self.contentView.offsetX / self.contentView.width - currentIndex;
    
    NSInteger nextIndex = currentIndex + 1;
    if(nextIndex > self.maxIndex)
        nextIndex = self.maxIndex;
    
    NSString* currentIndexStr = [NSString stringWithFormat:@"%zd", currentIndex];
    NSString* nextIndexStr = [NSString stringWithFormat:@"%zd", nextIndex];
    
    MTTenScrollTitleCell* currentCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow: currentIndex inSection:0]];
    if(currentCell)
    {
        self.cellWidthList[currentIndexStr] = @(currentCell.title.width);
        if(!self.cellCenterXList[currentIndexStr])
            self.cellCenterXList[currentIndexStr] = @(currentCell.centerX);
    }
    
    MTTenScrollTitleCell* nextCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex  inSection:0]];
    if(nextCell)
    {
        self.cellWidthList[nextIndexStr] = @(nextCell.title.width);
        if(!self.cellCenterXList[nextIndexStr])
            self.cellCenterXList[nextIndexStr] = @(nextCell.centerX);
    }
    
    CGFloat beginCenterX = 0;
    CGFloat beginWidth = 0;
    
    CGFloat nextCenterX = 0;
    CGFloat nextWidth = 0;
    
    BOOL isScroll = YES;
    
    if(currentCell || nextCell)
    {
        if(!currentCell || !nextCell)
        {
            if(!currentCell)
            {
                nextWidth = nextCell.title.width;
                nextCenterX = nextCell.centerX;
                                
                beginWidth = [self.titleView collectionView:self.titleView layout:nil sizeForItemAtIndexPath:[NSIndexPath indexPathForRow: nextIndex inSection:0]].width;
                beginCenterX = nextCell.x - self.titleViewModel.padding - beginWidth * 0.5;
                
                self.unknownCellIndex = currentIndex;
            }
            
            if(!nextCell)
            {
                beginWidth = currentCell.title.width;
                beginCenterX = currentCell.centerX;
                
                nextWidth = [self.titleView collectionView:self.titleView layout:nil sizeForItemAtIndexPath:[NSIndexPath indexPathForRow: nextIndex inSection:0]].width;
                nextCenterX = currentCell.maxX + self.titleViewModel.padding + nextWidth * 0.5;
                
                self.unknownCellIndex = nextIndex;
            }
        }
        else
        {
            beginWidth = currentCell.title.width;
            beginCenterX = currentCell.centerX;
            
            nextWidth = nextCell.title.width;
            nextCenterX = nextCell.centerX;
        }
        
        if(self.wordStyleChange)
        {
            [self colorChangeCurrentTitleCell:currentCell nextCell:nextCell changeScale:rate];
            [self fontSizeChangeCurrentTitleCell:currentCell nextCell:nextCell changeScale:rate];
        }
    }
    else
    {
        self.isUnknownCell = YES;

        if(self.cellCenterXList[currentIndexStr] && self.cellCenterXList[nextIndexStr])
        {
            beginWidth = [self.cellWidthList[currentIndexStr] floatValue];
            beginCenterX = [self.cellCenterXList[currentIndexStr] floatValue];
            
            nextWidth = [self.cellWidthList[nextIndexStr] floatValue];
            nextCenterX = [self.cellCenterXList[nextIndexStr] floatValue];
        }
        else
        {
            if(self.cellCenterXList[currentIndexStr] || self.cellCenterXList[nextIndexStr])
            {
                if(!self.cellCenterXList[currentIndexStr])
                {
                    nextWidth = [self.cellWidthList[nextIndexStr] floatValue];
                    nextCenterX = [self.cellCenterXList[nextIndexStr] floatValue];
                    
                    beginWidth = [self.titleView collectionView:self.titleView layout:nil sizeForItemAtIndexPath:[NSIndexPath indexPathForRow: currentIndex inSection:0]].width;
                    beginCenterX = nextCenterX - nextWidth * 0.5 - self.titleViewModel.padding - beginWidth * 0.5;
                    
                    self.cellCenterXList[currentIndexStr] = @(beginCenterX);
                    self.cellWidthList[currentIndexStr] = @(beginWidth);
                }
                
                if(!self.cellCenterXList[nextIndexStr])
                {
                    beginWidth = [self.cellWidthList[currentIndexStr] floatValue];
                    beginCenterX = [self.cellCenterXList[currentIndexStr] floatValue];
                    
                    nextWidth = [self.titleView collectionView:self.titleView layout:nil sizeForItemAtIndexPath:[NSIndexPath indexPathForRow: nextIndex inSection:0]].width;
                    nextCenterX = beginCenterX + beginWidth * 0.5 + self.titleViewModel.padding + nextWidth * 0.5;
                    
                    self.cellCenterXList[nextIndexStr] = @(nextCenterX);
                    self.cellWidthList[nextIndexStr] = @(nextWidth);
                }
            }
            else
                isScroll = false;
        }
    }
    
    if(isScroll)
    {
        self.titleView.bottomLine.centerX = beginCenterX + (nextCenterX - beginCenterX) * rate;
        self.titleView.bottomLine.width = beginWidth + (nextWidth - beginWidth)*rate;
    }
        
    /*-----------------------------------自动滚动-----------------------------------*/
    
    if(self.directionTag < 0)
    {
        currentIndex = ceil(floatCurrentIndex);
        preCurrentIndex = ceil(self.preCurrentIndex);
    }
        
    if(currentIndex != preCurrentIndex)
    {
        [self.titleView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow: currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
            
    self.preCurrentIndex = floatCurrentIndex;
}

-(void)didContentViewEndScrollWithDecelerate:(NSNumber*)decelerate1
{
    BOOL decelerate = decelerate1.boolValue;
    if(!decelerate)
        self.isDraging = false;
    CGFloat currentIndex = self.contentView.offsetX / self.contentView.width;
    if((currentIndex - (NSInteger)currentIndex) != 0)
        return;
        
    self.tenScrollView.scrollEnabled = YES;
    self.currentView.scrollEnabled = YES;
    self.titleView.scrollEnabled = YES;
    _isContentViewDragging = false;
    self.isUnknownCell = false;
    self.currentIndex = currentIndex;
    
    [self.titleView collectionView:nil didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
}


#pragma mark - TitleView

-(void)titleViewWillBeginDragging
{
    self.tenScrollView.scrollEnabled = false;
    self.titleViewFixScroll = false;
}


-(void)titleViewDidScroll
{
    if(self.titleView.contentSize.width == 0)
        return;
    
    if(self.superTenScrollView.model.contentView.isDecelerating)
    {
        self.titleView.offsetX = self.preTitleOffsetX;
        return;
    }
    
    
    CGFloat minOffsetX = -self.titleViewModel.margin;
    CGFloat maxOffsetX = self.titleView.contentSize.width + self.titleViewModel.margin - self.titleView.width;
    maxOffsetX = floor(maxOffsetX);

    
    if(self.titleViewFixScroll)
        self.titleView.offsetX = self.preTitleOffsetX;
    else
    {
        if(self.titleView.offsetX < minOffsetX)
            self.titleView.offsetX = minOffsetX;
        
        if(self.titleView.offsetX > maxOffsetX)
            self.titleView.offsetX = maxOffsetX;
    }
    
    if(self.titleView.offsetX > minOffsetX && self.titleView.offsetX< maxOffsetX)
    {
        self.preTitleOffsetX = self.titleView.offsetX;
    }
    else
    {
        NSInteger offsetX = [self.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;

        if(self.titleView.offsetX <= minOffsetX)
        {
            self.preTitleOffsetX = minOffsetX;
            self.titleViewFixScroll = offsetX > 0;
        }
        else
        {
            self.preTitleOffsetX = maxOffsetX;
            self.titleViewFixScroll = offsetX < 0;
        }
    }
}

-(void)didTitleViewEndScroll
{
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
-(UIView*)getViewByIndex:(NSNumber*)index
{    
    return [self getViewtByIndex:index.integerValue isBandData:YES];
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
    
    [self setUpCurrentViewBySuperView:view];
    
    return view;
}

-(void)setUpCurrentViewBySuperView:(UIView*)superView
{
    if(!superView)
        return;
    if([self.currentView isKindOfClass:[MTTenScrollView class]] && (self.currentView.offsetY > 0))
    {
        [self.fixSubTenScrollViewArr addObject:(MTTenScrollView*)self.currentView];
    }
    
    self.currentView.scrollEnabled = YES;
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
                
//                if(offsetY > self.tenScrollViewMaxOffsetY)
//                    [UIView animateWithDuration:0.1 animations:^{
//                        subTenScrollView.offsetY = subTenScrollView.model.tenScrollViewMaxOffsetY;
//                    }];
            }
            else
            {
                ((MTDelegateTenScrollTableView*)subView).model = self;
                subView.height = self.tenScrollHeight - self.titleViewModel.titleViewHeight;
            }
            
            self.currentView = (UIScrollView*)subView;
            self.currentView.showsVerticalScrollIndicator = false;
            self.currentView.showsHorizontalScrollIndicator = false;
            
//            if(offsetY < self.tenScrollViewMaxOffsetY)
//                [UIView animateWithDuration:0.1 animations:^{
//                    self.currentView.offsetY = 0;
//                }];
        }
    }
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
    
//    NSLog(@"%zd --- %lf",currentCell.indexPath.row,currentFontSize);
//    NSLog(@"%zd +++ %lf",nextCell.indexPath.row,nextFontSize);
    
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
    return self.tenScrollViewMaxOffsetY + (_tenScrollHeight ? 0 : self.titleViewModel.titleViewHeight);
}

-(NSInteger)tenScrollViewMaxOffsetY
{
    NSInteger tenScrollViewMaxOffsetY = self.tenScrollView.contentSize.height - self.tenScrollHeight;
    
//    if(!tenScrollViewMaxOffsetY)
//        tenScrollViewMaxOffsetY = 1;
//    if(!self.superTenScrollView)
//        NSLog(@"%zd",tenScrollViewMaxOffsetY);
    return tenScrollViewMaxOffsetY;
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
        
    self.subModel = nil;
    _currentIndex = currentIndex;
    self.preCurrentIndex = self.minIndex = self.maxIndex1 = currentIndex;
    [self getViewtByIndex:currentIndex isBandData:false];    
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
    NSObject* tenScrollData = mt_reuse(self).band(@"MTTenScrollViewCell").bandHeight(self.tenScrollHeight);    
    return self.dataList ? tenScrollData : tenScrollData;
}

-(CGFloat)tenScrollHeight
{
    return _tenScrollHeight ? _tenScrollHeight : (self.tenScrollView.height + self.titleViewModel.titleViewHeight);
}

@end
