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
@property (nonatomic,assign) CGFloat preOffsetX2;

/**ccontentView 是否向左滚动*/
@property (nonatomic,assign) BOOL isLeft;
@property (nonatomic,assign) BOOL isLeft2;


/**ccontentView 是否正在滚动*/
@property (nonatomic,assign) BOOL isContentViewScrolling;


/**标题固定滚动*/
@property (nonatomic,assign) BOOL titleViewFixScroll;
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
-(void)tenScrollViewDidScroll
{
    if(self.tenScrollView.offsetY >= self.tenScrollViewMaxOffsetY)
        return;
    
    if(!self.fixSubTenScrollViewArr.count)
        return;
    
    for (MTTenScrollView* tenScrollView in self.fixSubTenScrollViewArr) {        
        tenScrollView.offsetY = 0;
    }
    
    [self.fixSubTenScrollViewArr removeAllObjects];
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
    if([self.currentView isKindOfClass:[MTTenScrollView class]])
    {
        MTTenScrollModel* subModel = ((MTTenScrollView*)self.currentView).model;
        if(subModel.isContentViewDragging)
        {
            MTTenScrollContentView* subContentView = subModel.contentView;
            CGFloat subMinOffsetX = subModel.contentViewFixOffset;
            CGFloat subMaxOffsetX = subContentView.width * subModel.maxIndex - subModel.contentViewFixOffset;
            
            
            CGFloat limitoffsetX = self.contentView.width * subModel.superIndex;
            CGFloat subVelX = [subContentView.panGestureRecognizer velocityInView:subContentView].x;
            
            if(subContentView.offsetX > subMinOffsetX && subContentView.offsetX< subMaxOffsetX)
            {
                self.contentView.offsetX = limitoffsetX;
            }
            else
            {
                if((subContentView.offsetX <= subMinOffsetX) && (subVelX < 0))
                    self.contentView.offsetX = limitoffsetX;
                else if((subContentView.offsetX >= subMaxOffsetX) && ((subVelX > 0)))
                    self.contentView.offsetX = limitoffsetX;
                else
                {
//                    NSLog(@"+++ %lf",subVelX);
                }
//                    NSLog(@"++++ %d === %d === %lf === %lf === %lf",subModel.isLeft2, subModel.isLeft, subContentView.offsetX, subMinOffsetX, subMaxOffsetX);
//                    NSLog(@"================1111111=========================");
            }
        }
    }
    else
    {
        
    }
    
    if(!self.superTenScrollView)
    {
        return;
    }
    

    
    
    
    CGFloat minOffsetX = self.contentViewFixOffset;
    CGFloat maxOffsetX = self.contentView.width * self.maxIndex - self.contentViewFixOffset;
    CGFloat velX = [self.contentView.panGestureRecognizer velocityInView:self.contentView].x;
    
    MTTenScrollModel* superModel = self.superTenScrollView.model;
    MTTenScrollContentView* superContentView = superModel.contentView;
    
    if((self.contentView.offsetX > minOffsetX) && (self.contentView.offsetX < maxOffsetX))
    {
            superContentView.offsetX = superContentView.width * self.superIndex;
    }
    else
    {
        if((self.contentView.offsetX <= minOffsetX) && (velX < 0))
            superContentView.offsetX = superContentView.width * self.superIndex;
        else if((self.contentView.offsetX >= maxOffsetX) && (velX > 0))
            superContentView.offsetX = superContentView.width * self.superIndex;
        else
        {
//            NSLog(@"%lf",velX);
        }
        
//            NSLog(@"%d === %d === %lf === %lf === %lf", self.isLeft2, self.isLeft, self.contentView.offsetX, minOffsetX, maxOffsetX);
        
//            NSLog(@"=========================================");
    }
    
    self.preOffsetX2 = self.contentView.offsetX;
}


-(void)contentViewDidScroll
{
    [self fixContentViewScrollingOffset];
    //    return;
    
    if(self.isTitleViewTap)
        return;
    
    CGFloat currentOffsetX = self.contentView.offsetX;
    
    if(currentOffsetX == self.preOffsetX)
        return;
    
    self.isLeft = currentOffsetX < self.preOffsetX;
    
    CGFloat currentIndex = currentOffsetX / self.contentView.width;
    
    CGFloat scale = currentIndex - ((NSInteger)currentIndex);
    
    if(scale < 5)
    {
        self.immediateIndex = currentIndex;
    }
    
    NSInteger nextIndex = floor(currentIndex);
    if(nextIndex == self.immediateIndex)
        nextIndex = ceil(currentIndex);
    
    
    NSInteger startIndex = self.isLeft ? nextIndex : self.immediateIndex;
    NSInteger endIndex = self.isLeft ? self.immediateIndex : nextIndex;
    if(self.isLeft)
        scale = 1 - scale;
    
    //    return;
    MTTenScrollTitleCell* currentCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow: startIndex inSection:0]];
    
    NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:endIndex inSection:0];
    MTTenScrollTitleCell* nextCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:endIndex  inSection:0]];
    
    
//        if(self.superTenScrollView)
//            NSLog(@"前后索引：==== %zd ==== %zd", startIndex, endIndex);
    
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
    
    if(startIndex != endIndex)
        self.isLeft2 = startIndex > endIndex;
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


#pragma mark - TitleView

-(void)titleViewWillBeginDragging
{
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
    if(maxOffsetX < 0)
        maxOffsetX -= 0.1;
    if(minOffsetX > 0)
        maxOffsetX += 0.1;
    
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
    
    //    NSLog(@"ccccc === %lf === %lf === %lf", self.titleView.offsetX, minOffsetX, maxOffsetX);
    
    if(self.titleView.offsetX > minOffsetX && self.titleView.offsetX< maxOffsetX)
    {
        
        self.superTenScrollView.model.contentView.offsetX = self.superTenScrollView.model.contentView.width * self.superTenScrollView.model.currentIndex;
    }
    else
    {
        if(((self.superTenScrollView.model.contentView.offsetX / self.superTenScrollView.model.contentView.width) - self.superTenScrollView.model.currentIndex) != 0)
        {
            if(self.titleView.offsetX >= maxOffsetX)
                preOffsetX = maxOffsetX;
            if(self.titleView.offsetX <= minOffsetX)
                preOffsetX = minOffsetX;
            self.titleViewFixScroll = YES;
        }
        else
            self.titleViewFixScroll = false;
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
            if([subView isKindOfClass:[MTTenScrollView class]])
            {
                ((MTTenScrollView*)subView).model.superTenScrollView = self.tenScrollView;
                ((MTTenScrollView*)subView).model.superIndex = index;
            }
            else
            {
                ((MTDelegateTenScrollTableView*)subView).model = self;
                ((MTDelegateTenScrollTableView*)subView).model.superIndex = index;
            }
            
            
            self.currentView = (UIScrollView*)subView;
            
            self.currentView.height = self.tenScrollHeight - self.titleViewModel.titleViewHeight;
            
            NSInteger offsetY = self.tenScrollView.contentOffset.y;
            NSInteger maxOffsetY = self.tenScrollView.contentSize.height - self.tenScrollHeight;
            
            if(offsetY < maxOffsetY)
                self.currentView.offsetY = 0;
        }
    }
}


#pragma mark - 懒加载

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
    
    for(NSObject* obj in dataList)
    {
        [arr addObject:obj.mt_tagIdentifier];
        [self.objectArr addObject:@""];
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
    return mt_reuse(self).band(@"MTTenScrollViewCell").bandHeight(self.tenScrollHeight);
}

-(CGFloat)tenScrollHeight
{
    return (_tenScrollHeight && _tenScrollHeight < self.tenScrollView.height) ? _tenScrollHeight : self.tenScrollView.height;
}

@end
