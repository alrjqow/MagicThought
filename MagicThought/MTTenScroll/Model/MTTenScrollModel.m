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



/**即时索引*/
@property (nonatomic,assign) NSInteger immediateIndex;

/**ccontentView 上次的偏移值*/
@property (nonatomic,assign) CGFloat preOffsetX;
@property (nonatomic,assign) CGFloat preTitleOffsetX;
@property (nonatomic,assign) CGFloat preContentViewOffsetX;

/**ccontentView 是否向左滚动*/
@property (nonatomic,assign) BOOL isLeft;

@property (nonatomic,assign) BOOL isTitleViewDragging;

/**ccontentView 是否正在滚动*/
@property (nonatomic,assign) BOOL isContentViewScrolling;

/**titleView 是否向左滚动*/
@property (nonatomic,assign) BOOL isTitleLeft;

@property (nonatomic,weak) MTTenScrollModel* subModel;

@property (nonatomic,assign) NSInteger preIndex;

@property (nonatomic,assign) BOOL contentViewFixScroll;

/**标题固定滚动*/
@property (nonatomic,assign) BOOL titleViewFixScroll;
@property (nonatomic,assign) NSInteger titleViewFixScrollCount;
/**标题是否正在滚动*/
@property (nonatomic,assign) BOOL isTitleViewScrolling;
/**标题是否点击*/
@property (nonatomic,assign) BOOL isTitleViewTap;

/**锁*/
@property (nonatomic,assign) BOOL lock;


@property (nonatomic,assign) NSInteger minIndex;
@property (nonatomic,assign) NSInteger maxIndex1;


@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger lastStatus;

@property (nonatomic,assign) BOOL isDraging;

@end

@implementation MTTenScrollModel


-(instancetype)init
{
    if(self = [super init])
    {
        _currentIndex = -1;
        self.contentViewFixOffset = 80;
//        self.titleViewFixOffset = 40;
        self.objectArr = [NSMutableArray array];
        self.fixSubTenScrollViewArr = [NSMutableArray array];
        self.subModelList = [NSMutableDictionary dictionary];
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
    MTTenScrollModel* model = self;
    do {
        if(model.tenScrollView.dragging || model.tenScrollView.decelerating)
        {
//            NSLog(@"%@ === %d === %d === %d",NSStringFromClass(self.delegate.class), model.tenScrollView.tracking, model.tenScrollView.dragging,  model.tenScrollView.decelerating);
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
    self.tenScrollView.offsetY = [self fixTenScrollViewScroll2];
}

-(CGFloat)fixTenScrollViewScroll2
{
    CGFloat offsetY = self.tenScrollView.offsetY;
    MTTenScrollModel* superModel = self.superTenScrollView.model;
    MTTenScrollView* superTenScrollView = superModel.tenScrollView;
    superModel.subModel = self;
    
    MTTenScrollModel* superModel2 = superModel.superTenScrollView.model;
//    MTTenScrollView* superTenScrollView2 = superModel2.tenScrollView;
    
    MTTenScrollModel* subModel = self.subModel;
    MTTenScrollView* subTenScrollView = subModel.tenScrollView;
    
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
        }
    }
    else
    {
        self.status = 3;        
        offsetY = self.tenScrollViewMaxOffsetY2;
    }
    

    self.lastStatus = self.status;
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
    self.superTenScrollView.model.isDraging = YES;
//    NSLog(@"qqqqq %zd",self.superIndex);
//    if(self.superTenScrollView)
//        NSLog(@"----------------------------- %zd",self.superIndex);
//    if(!self.superTenScrollView)
//        NSLog(@"%@ === %@ === %d === %d === %d",NSStringFromClass(self.delegate.class), NSStringFromClass(self.subModel.delegate.class), self.subModel.contentView.dragging, self.subModel.contentView.decelerating, self.subModel.contentView.tracking);
        
    if(!self.subModel.contentView.isRolling && !self.subModel.titleView.isRolling)
    {
        self.subModel = nil;
    }
        
    self.isTitleViewDragging = false;
    self.superTenScrollView.model.subModel = self;
    
    self.superTenScrollView.model.currentView = self.tenScrollView;
    self.tenScrollView.scrollEnabled = false;
    self.currentView.scrollEnabled = false;
    self.isContentViewDragging = YES;
}


/**固定滚动时必要的offset*/
-(BOOL)fixContentViewScrollingOffset4:(MTTenScrollModel*)subModel2
{
//    NSLog(@"%@",NSStringFromClass(self.delegate.class));
//    if([NSStringFromClass(self.delegate.class) isEqualToString:@"TestController3"])
//            NSLog(@"%zd === %zd",self.superTenScrollView.model.minIndex, self.superTenScrollView.model.maxIndex1);
//        NSLog(@"%d",self.superTenScrollView.model.contentView.isRolling);
    
    
//    NSLog(@"%@",NSStringFromClass(self.delegate.class));
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
         self.subModel = nil;
//         self.isDraging = false;
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
    
    if(!self.superTenScrollView)
    {
//        NSLog(@"%zd === %zd === %zd === %zd === %zd",self.minIndex, self.maxIndex1, currentIndex, minIndex, maxIndex);
    }
    
//    if(self.superTenScrollView.model.minIndex != self.superTenScrollView.model.maxIndex1)
//    {
//        self.contentView.offsetX = self.contentView.width * currentIndex;
//        return YES;
//    }
    
//    if([NSStringFromClass(self.delegate.class) isEqualToString:@"TestController3"])
//    {
//        NSLog(@"%zd === %zd",self.superIndex, currentIndex);
//    }
    NSInteger offsetX = [self.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;
    if(offsetX != 0)
    {
        self.contentView.offsetX = self.contentView.width * currentIndex;
        return YES;
    }
    
//        if(!self.superTenScrollView)
//        {
//            NSLog(@"%zd",  currentIndex);
//        }
//
    MTTenScrollModel* subModel = subModel2 ? subModel2 : self.subModelList[[NSString stringWithFormat:@"%zd", currentIndex]];
    if(!subModel)
    {
        self.minIndex = minIndex;
        self.maxIndex1 = maxIndex;
//        if(!self.superTenScrollView)
//        {
//            NSLog(@"asdasd");
//        }
        return false;
    }
    
//    if(!self.superTenScrollView)
//    {
//        NSLog(@"%zd",subModel.superIndex);
//    }
    
        
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
//    if(!self.superTenScrollView)
//    NSLog(@"fixContentViewScrollingOffset5");
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
//              if(!self.superTenScrollView)
//              {
//                  NSLog(@"%zd === %zd === %zd",currentIndex, minIndex, maxIndex);
//              }
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
                  
//                  if(!self.superTenScrollView)
//                  NSLog(@"%zd",currentIndex);
              }
          }
     
//          if(!self.superTenScrollView)
//          {
//              NSLog(@"qwqww");
//          }
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
 
    
    if(!self.superTenScrollView)
    {
//        NSLog(@"fixContentViewScrollingOffset6");
//        NSLog(@"%lf === %lf === %lf",subMinOffsetX, subScrollView.offsetX, subMaxOffsetX);
    }
        
    
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
//             NSLog(@"%lf", subScrollView.offsetX);
//             NSLog(@".... %lf === %lf === %lf",subMinOffsetX, subMaxOffsetX, subScrollView.offsetX);
         }
    
    self.minIndex = minIndex;
    self.maxIndex1 = maxIndex;
    return false;
}

/**固定滚动时必要的offset*/
-(void)fixContentViewScrollingOffset2
{
//    if(self.superTenScrollView.model.contentView.isDecelerating)
//    {
//        self.contentView.offsetX = self.contentView.width * self.currentIndex;
//        return;
//    }
    
    MTTenScrollModel* subModel = self.subModel;
    
    if(!subModel)
    {
        return;
    }
                        
    if(subModel.isTitleViewDragging)
    {
        [self fixContentViewScrollingOffset2_1];
        return;
    }
        
    
    NSInteger currentIndex = subModel.superIndex;
    UIScrollView* subScrollView;
    CGFloat subMinOffsetX;
    CGFloat subMaxOffsetX;
    
//    if(!self.superTenScrollView)
//    {
//        NSLog(@"%lf",self.contentView.offsetX);
//    }
    
    do {
        subScrollView = subModel.contentView;
        subMinOffsetX = subModel.contentViewFixOffset;
        subMaxOffsetX = subScrollView.width * subModel.maxIndex - subModel.contentViewFixOffset;

//        NSLog(@"%@ === %lf === %lf === %lf",NSStringFromClass(subModel.delegate.class), subMinOffsetX, subMaxOffsetX, subContentView.offsetX);
        if(subScrollView.offsetX > subMinOffsetX && subScrollView.offsetX< subMaxOffsetX)
        {
            if(!self.superTenScrollView)
            {
                NSLog(@"+++ %zd",currentIndex);
            }
            if(!self.contentView.isDecelerating)
                self.contentView.offsetX = self.contentView.width * currentIndex;
            return;
        }
        else
        {
            if(!self.superTenScrollView)
            {
                NSLog(@"--- %zd",currentIndex);
            }
            NSInteger offsetX = [subModel.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;
            
//            NSLog(@"%@ === %@ === %lf === %lf === %lf === %zd === %d",NSStringFromClass(self.delegate.class), NSStringFromClass(subModel.delegate.class), subScrollView.offsetX, subMinOffsetX, subMaxOffsetX, offsetX, (subScrollView.offsetX <= subMinOffsetX && offsetX <= 0));
            
//            NSLog(@"%@ === %@",NSStringFromClass(self.delegate.class), NSStringFromClass(subModel.delegate.class));
            
            if(subScrollView.offsetX <= subMinOffsetX)
            {
                if(offsetX <= 0)
                {
                    self.contentView.offsetX = self.contentView.width * currentIndex;
                    return;
                }
                else
                {
//                    if(subScrollView.offsetX > 0)
//                    {
//                        self.contentView.offsetX = self.contentView.width * currentIndex;
//                        return;
//                    }
                }
            }
            
            if(subScrollView.offsetX >= subMaxOffsetX)
            {
                if(offsetX >= 0)
                {
                    self.contentView.offsetX = self.contentView.width * currentIndex;
                    return;
                }
                else
                {
//                    if(subScrollView.offsetX < (subModel.isTitleViewDragging ? subMaxOffsetX : (subScrollView.width * subModel.maxIndex)))
//                    {
//                        self.contentView.offsetX = self.contentView.width * currentIndex;
//                        return;
//                    }
                }
            }
        }
        
                
        subModel = subModel.subModel;
        
    } while (subModel);
}

-(void)fixContentViewScrollingOffset2_1
{
    MTTenScrollModel* subModel = self.subModel;
                
    NSInteger currentIndex = subModel.superIndex;
//    if(!self.superTenScrollView)
//    {
//            NSLog(@"%zd === %lf", currentIndex, self.contentView.offsetX);
//    }
        
    UIScrollView* subScrollView;
    CGFloat subMinOffsetX;
    CGFloat subMaxOffsetX;
    
    do {
        subScrollView = subModel.titleView;
        subMinOffsetX = -subModel.titleViewModel.margin;
        subMaxOffsetX = floor(subModel.titleView.contentSize.width + subModel.titleViewModel.margin - subModel.titleView.width);
        
        
        if(subScrollView.offsetX > subMinOffsetX && subScrollView.offsetX< subMaxOffsetX)
        {
            if(!self.contentView.isDecelerating)
                self.contentView.offsetX = self.contentView.width * currentIndex;
            return;
        }
        else
        {

        }
                        
        subModel = subModel.subModel;
        
    } while (subModel);
}


-(void)fixContentViewScrollingOffset3
{
    
    if(self.contentViewFixScroll)
        self.contentView.offsetX = self.preContentViewOffsetX;
    
    CGFloat minOffsetX = 0;
    CGFloat maxOffsetX = self.contentView.width * self.maxIndex;
    
//    NSLog(@"%@ === %lf === %lf === %lf",NSStringFromClass(self.delegate.class), minOffsetX, maxOffsetX, self.contentView.offsetX);
    if(self.contentView.offsetX > minOffsetX && self.contentView.offsetX< maxOffsetX)
    {
//        NSLog(@"%@",NSStringFromClass(self.delegate.class));
    }
    else
    {
        NSInteger offsetX = [self.tenScrollView convertPoint:CGPointZero toView:mt_Window().rootViewController.view].x;
        
        //        NSLog(@"%zd", offsetX);
        
        if(self.contentView.offsetX <= minOffsetX)
        {
            self.preContentViewOffsetX = minOffsetX;
            self.contentViewFixScroll = offsetX > 0;
        }
        
        if(self.contentView.offsetX >= maxOffsetX)
        {
            self.preContentViewOffsetX = maxOffsetX;
            self.contentViewFixScroll = offsetX < 0;
        }
    }
}

-(void)fixContentViewScrollingOffset
{
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
        if(!superModel)
            break;
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
    if(self.isTitleViewTap)
         return;
     
     [self fixContentViewScrollingOffset4:nil];
    
    NSInteger currentIndex = self.contentView.offsetX / self.contentView.width;
    if(currentIndex > self.maxIndex)
        currentIndex = self.maxIndex;
    CGFloat rate = self.contentView.offsetX / self.contentView.width - currentIndex;
    
    NSInteger nextIndex = currentIndex + 1;
    if(nextIndex > self.maxIndex)
        nextIndex = self.maxIndex;
    
    MTTenScrollTitleCell* currentCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow: currentIndex inSection:0]];
          
     MTTenScrollTitleCell* nextCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex  inSection:0]];
    
    CGFloat beginCenterX = currentCell.centerX;
    CGFloat nextCenterX = nextCell.centerX;
    self.titleView.bottomLine.centerX = beginCenterX + (nextCenterX - beginCenterX) * rate;
       
   CGFloat beginWidth = currentCell.title.width;
   CGFloat nextWidth = nextCell.title.width;
   self.titleView.bottomLine.width = beginWidth + (nextWidth - beginWidth)*rate;
    

}

-(void)contentViewDidScroll2
{
//    NSLog(@"%@",NSStringFromClass(self.delegate.class));
//    return;
//    if([self fixSuperContentViewScroll2])
//        return;
    
//    [self fixContentViewScrollingOffset];
    
//        return;
    
    if(self.isTitleViewTap)
        return;
    
    [self fixContentViewScrollingOffset3];
    [self fixContentViewScrollingOffset2];
            
                
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
//    NSLog(@"%@ === 前后索引：==== %zd ==== %zd", NSStringFromClass(self.delegate.class), startIndex, endIndex);
    
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
    if(!decelerate)
        self.isDraging = false;
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
//    if(self.superTenScrollView)
//        NSLog(@"----------------------------- %zd === %p",self.superIndex, self);
    
    if(!self.subModel.contentView.isRolling && !self.subModel.titleView.isRolling)
        self.subModel = nil;
    self.isTitleViewDragging = YES;
    self.superTenScrollView.model.subModel = self;
    
    self.isTitleViewScrolling = YES;
    self.tenScrollView.scrollEnabled = false;
    self.titleViewFixScroll = false;
    self.isContentViewScrolling = false;
}


-(void)titleViewDidScroll
{
    if(self.isContentViewScrolling)
        return;
    
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
    
//    if(!self.superTenScrollView)
//    {
//        if(self.titleView.offsetX < minOffsetX)
//            self.titleView.offsetX = minOffsetX;
//
//        if(self.titleView.offsetX > maxOffsetX)
//            self.titleView.offsetX = maxOffsetX;
//        return;
//    }
    
    
    if(self.titleViewFixScroll)
        self.titleView.offsetX = self.preTitleOffsetX;
    else
    {
        if(self.titleView.offsetX < minOffsetX)
            self.titleView.offsetX = minOffsetX;
        
        if(self.titleView.offsetX > maxOffsetX)
            self.titleView.offsetX = maxOffsetX;
    }
    
//    NSLog(@"ccccc === %lf === %lf === %lf", self.titleView.offsetX, minOffsetX, maxOffsetX);
    
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
    self.isTitleViewScrolling = false;
    self.isTitleViewDragging = false;
    self.tenScrollView.scrollEnabled = YES;
    self.titleViewFixScroll = false;    
}

-(void)didTitleViewSelectedItem
{
    self.isTitleViewTap = YES;
    [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    self.contentViewFixScroll = false;
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
    
    _currentIndex = currentIndex;
    self.minIndex = self.maxIndex1 = self.immediateIndex = currentIndex;
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
    if(!self.dataList)
        self.dataList = self.dataList;
    return mt_reuse(self).band(@"MTTenScrollViewCell").bandHeight(self.tenScrollHeight);
}

-(CGFloat)tenScrollHeight
{
    return _tenScrollHeight ? _tenScrollHeight : (self.tenScrollView.height + self.titleViewModel.titleViewHeight);
}

@end
