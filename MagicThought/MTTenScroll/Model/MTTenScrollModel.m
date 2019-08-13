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

@property (nonatomic,assign) BOOL isTitleViewTap;

@property (nonatomic, strong) NSMutableArray *objectArr;



/**上次拖拽的索引*/
@property (nonatomic,assign) CGFloat preIndexOffset;

/**上次拖拽的contentView*/
@property (nonatomic,weak) MTTenScrollContentView* preContentView;

/**相对于父控件它的索引*/
@property (nonatomic,assign) NSInteger superIndex;

/**标题固定滚动*/
@property (nonatomic,assign) BOOL titleViewFixScroll;

/**content固定滚动*/
@property (nonatomic,assign) BOOL conntentViewFixScroll;

/**superContent固定滚动*/
@property (nonatomic,assign) BOOL superConntentViewFixScroll;

@property (nonatomic,assign) CGFloat preOffsetX;


@end

@implementation MTTenScrollModel


-(instancetype)init
{
    if(self = [super init])
    {
        _currentIndex = -1;
        self.objectArr = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - ContentView

-(void)contentViewWillBeginDragging
{
    self.isDecelerate = false;
    self.tenScrollView.scrollEnabled = false;
    self.currentView.scrollEnabled = false;
    self.preContentView = nil;
    
    CGFloat currentOffsetX = self.contentView.offsetX / self.contentView.width;
    CGFloat subValue = fabs(currentOffsetX - self.preIndexOffset);
    
    //证明上次滚动是有效的
    if(subValue > 0.5)
    {
        if(self.immediateIndex == self.currentIndex)
            self.immediateIndex = self.currentIndex + ([self.contentView.panGestureRecognizer velocityInView:self.contentView].x < 0 ? 1 : -1);
        else
            self.immediateIndex += ([self.contentView.panGestureRecognizer velocityInView:self.contentView].x < 0 ? 1 : -1);
        
        if(fabs(self.immediateIndex - currentOffsetX) > 1)
            self.immediateIndex = currentOffsetX += ([self.contentView.panGestureRecognizer velocityInView:self.contentView].x < 0 ? 1 : -1);
    }
    
//    if(self.superTenScrollView)
//        NSLog(@"开始的索引：==== %zd", self.immediateIndex);
    
    self.preIndexOffset = currentOffsetX;
    self.preIndex = self.immediateIndex;
}

/**固定滚动时必要的offset*/
-(void)fixContentViewScrollingOffset
{
    //解决弹簧回弹的问题
    if(self.isDecelerate)
    {
        if(self.immediateIndex != self.preIndex)
        {
            CGFloat maxOffsetX = self.immediateIndex * self.contentView.width;
            
            if(self.immediateIndex < self.preIndex)
            {
                if(self.contentView.offsetX > maxOffsetX)
                {
                    self.contentView.offsetX = maxOffsetX;
                    //                        NSLog(@"%lf ==== %lf ==== %zd ==== %zd",self.contentView.offsetX, maxOffsetX, self.immediateIndex, self.preIndex);
                    return;
                }
            }
            else
            {
                if(self.contentView.offsetX < maxOffsetX)
                {
                    self.contentView.offsetX = maxOffsetX;
                    return;
                }
            }
        }
    }
    
    CGFloat minOffsetX = 0;
    CGFloat maxOffsetX = self.contentView.width * self.maxIndex;
    
    if(!self.superTenScrollView)
    {
        NSLog(@"ccccc === %lf === %lf === %lf === %@", self.contentView.offsetX, minOffsetX, maxOffsetX, self.conntentViewFixScroll ? @"Yes" : @"No");
    }
    
    if(self.conntentViewFixScroll)
        self.contentView.offsetX = self.preOffsetX;
    else
    {
        if(self.contentView.offsetX < minOffsetX)
            self.contentView.offsetX = minOffsetX;

        if(self.contentView.offsetX > maxOffsetX)
            self.contentView.offsetX = maxOffsetX;
        
        if(!self.superTenScrollView)
        {
            if([self.currentView isKindOfClass:[MTTenScrollView class]])
            {
                MTTenScrollModel* subModel = ((MTTenScrollView*)self.currentView).model;
                MTTenScrollContentView* subContentView = subModel.contentView;
                CGFloat subMinOffsetX = 0;
                CGFloat subMaxOffsetX = subContentView.width * subModel.maxIndex;
                
                if(subContentView.offsetX > subMinOffsetX && subContentView.offsetX< subMaxOffsetX)
                    self.contentView.offsetX = self.contentView.width * self.currentIndex;
                
//                if(subModel.superConntentViewFixScroll)
//                    self.contentView.offsetX = self.contentView.width * self.currentIndex;
//                NSLog(@"ccccc === %lf === %@ === %lf", self.contentView.offsetX, subModel.conntentViewFixScroll ? @"Yes" : @"No", self.contentView.width * self.currentIndex);
            }
            return;
        }
    }
    
    
    
    MTTenScrollModel* superModel = self.superTenScrollView.model;
    MTTenScrollContentView* superContentView = superModel.contentView;

    
    if(self.contentView.offsetX > minOffsetX && self.contentView.offsetX< maxOffsetX)
    {
        superContentView.offsetX = superContentView.width * superModel.currentIndex;
    }
    else
    {
        if(((superContentView.offsetX / superContentView.width) - superModel.currentIndex) != 0)
        {
            if(self.contentView.offsetX >= maxOffsetX)
                self.preOffsetX = maxOffsetX;
            if(self.contentView.offsetX <= minOffsetX)
                self.preOffsetX = minOffsetX;
            self.conntentViewFixScroll = YES;
        }
        else
            self.conntentViewFixScroll = false;
    }
    
    
    return;


//    if(self.contentView.offsetX < 0)
//        self.contentView.offsetX = minOffsetX;
//    if(self.contentView.offsetX > ((self.dataList.count - 1) * self.contentView.width))
//        self.contentView.offsetX = (self.dataList.count - 1) * self.contentView.width;
//
//    if([self.currentView isKindOfClass:[MTTenScrollView class]])
//    {
//        MTTenScrollModel* subModel = ((MTTenScrollView*)self.currentView).model;
//        MTTenScrollContentView* subContentView = subModel.contentView;
//
//        if(subContentView.isRolling && ([self.contentView.panGestureRecognizer locationInView:self.contentView].x == [subContentView.panGestureRecognizer locationInView:self.contentView].x))
//        {
//            if((subModel.immediateIndex < (subModel.dataList.count - 1)))
//            {
//                self.contentView.offsetX = self.currentIndex * self.contentView.width;
//            }
//            else
//            {
////                NSLog(@"=== %zd", subModel.immediateIndex);
//            }
//        }
//    }
    
    if(self.superTenScrollView)
    {
        
//        if(self.titleViewFixScroll)
//            self.titleView.offsetX = preOffsetX;
//        else
//        {
//            if(self.titleView.offsetX < minOffsetX)
//                self.titleView.offsetX = minOffsetX;
//
//            if(self.titleView.offsetX > maxOffsetX)
//                self.titleView.offsetX = maxOffsetX;
//        }
//
//        //    NSLog(@"ccccc === %lf === %lf === %lf", self.titleView.offsetX, minOffsetX, maxOffsetX);
//
//        if(self.titleView.offsetX > minOffsetX && self.titleView.offsetX< maxOffsetX)
//        {
//
//            self.superTenScrollView.model.contentView.offsetX = self.superTenScrollView.model.contentView.width * self.superTenScrollView.model.currentIndex;
//        }
//        else
//        {
//            if(((self.superTenScrollView.model.contentView.offsetX / self.superTenScrollView.model.contentView.width) - self.superTenScrollView.model.currentIndex) != 0)
//            {
//                if(self.titleView.offsetX >= maxOffsetX)
//                    preOffsetX = maxOffsetX;
//                if(self.titleView.offsetX <= minOffsetX)
//                    preOffsetX = minOffsetX;
//                self.titleViewFixScroll = YES;
//            }
//            else
//                self.titleViewFixScroll = false;
//        }
//
        return;
        
        MTTenScrollModel* superModel = self.superTenScrollView.model;
        MTTenScrollContentView* superContentView = superModel.contentView;
        
        CGFloat velX = [self.contentView.panGestureRecognizer velocityInView:self.contentView].x;
        
        if(((self.immediateIndex <= 0) && (velX >= 0)) || ((self.immediateIndex >= self.maxIndex) && (velX <= 0)))
        {
//            NSLog(@"=== %zd === %lf", self.immediateIndex, velX);
            superModel.preContentView = self.contentView;
        }
//        else if(!self.contentView.isRolling && (superModel.currentView == self.tenScrollView))
//        {
//            NSLog(@"asdasdas");
//            superContentView.offsetX = superModel.currentIndex * superContentView.width;
//        }
        else if(superModel.currentIndex == self.superIndex)
        {
//            NSLog(@"asdasdas1111");
//            NSLog(@"aaaa === %zd ===== %zd", superModel.currentIndex, self.superIndex);
            
            
            if((fabs(((superContentView.offsetX / superContentView.width) - superModel.currentIndex)) < 1) && ((self.immediateIndex != self.maxIndex) && (self.immediateIndex != 0)))
            {
                NSLog(@"%zd === %zd",self.immediateIndex, self.maxIndex);
                superContentView.offsetX = superModel.currentIndex * superContentView.width;
            }
            else
                NSLog(@"dddddd");
        }
        else
        {
            NSLog(@"vvvvvvv");
        }
  
//        NSLog(@"%lf === %zd",self.contentView.offsetX / self.contentView.width, self.currentIndex);
//            if(fabs((self.contentView.offsetX / self.contentView.width) - self.currentIndex) > 1)
    }
}

-(BOOL)canContentViewDidScroll
{
    if(self.titleViewFixScroll)
        return YES;
    
    if(![self.currentView isKindOfClass:[MTTenScrollView class]])
    {
        if(self.superTenScrollView)
        {
            if(self.superIndex != self.superTenScrollView.model.currentIndex)
            {
//                NSLog(@"子： === %zd === %zd", self.superIndex, self.superTenScrollView.model.currentIndex);
                //                NSLog(@"子： === %p ===  %@", self.superTenScrollView.model.currentView, NSStringFromClass([self.superTenScrollView.model.currentView class]));
            }
            return self.superIndex == self.superTenScrollView.model.currentIndex;
        }
        
        
        return YES;
    }
    
    
    
    MTTenScrollModel* subModel = ((MTTenScrollView*)self.currentView).model;
    
    if(!(self.currentView.isRolling && (([self.contentView.panGestureRecognizer locationInView:self.contentView].x == [subModel.contentView.panGestureRecognizer locationInView:self.contentView].x) || ([self.contentView.panGestureRecognizer locationInView:self.contentView].x == [subModel.titleView.panGestureRecognizer locationInView:self.contentView].x))))
    {
//        if(self.superTenScrollView)
//        {
//            NSLog(@"11111");
//        }
        return YES;
    }
    
    
    if((subModel.immediateIndex <= 0) && (self.currentIndex > 0))
    {
//        if(self.superTenScrollView)
//        {
//            NSLog(@"22222");
//        }
        return YES;
    }
    
    
    if((subModel.immediateIndex >= (subModel.dataList.count - 1)) && (self.currentIndex < (self.dataList.count - 1)))
    {
//        if(self.superTenScrollView)
//        {
//            NSLog(@"33333");
//        }
        return YES;
    }
    
//    NSLog(@"44444");
    return false;
}

-(void)contentViewDidScroll
{
    [self fixContentViewScrollingOffset];
    
    if(![self canContentViewDidScroll])
        return;

    static BOOL isLeft;
    if(self.isTitleViewTap)
        return;
    
    //判断左右
    CGFloat closeingIndex = self.contentView.contentOffset.x / self.contentView.width;
    if(closeingIndex == self.currentIndex)
        return;
    
    isLeft = closeingIndex < self.currentIndex;
    
    
    NSInteger index = self.currentIndex;
    if(isLeft)
    {
        index = self.currentIndex - 1;
        if(index < 0)
            index = 0;
    }
    
    CGFloat scale = closeingIndex - index;
    if(isLeft)
        scale = 1 - scale;
    
    NSInteger nextIndex = isLeft ? (self.currentIndex - 1) : (self.currentIndex + 1);
    if(nextIndex < 0)
        nextIndex = 0;
    if(nextIndex >= self.titleList.count)
        nextIndex = (self.titleList.count - 1);
  
    
    MTTenScrollTitleCell* currentCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    
    MTTenScrollTitleCell* nextCell = (MTTenScrollTitleCell*)[self.titleView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0]];
    
//    NSLog(@"%zd === %zd === %@ === %lf",self.currentIndex, nextIndex, isLeft ? @"左" :@"右", closeingIndex);

    [self colorChangeCurrentTitleCell:currentCell nextCell:nextCell changeScale:scale];
    [self fontSizeChangeCurrentTitleCell:currentCell nextCell:nextCell changeScale:scale];

    CGFloat beginCenterX = currentCell.centerX;
    CGFloat distanceOffset = fabs(beginCenterX - nextCell.centerX) * scale * (isLeft ? -1 : 1);
    
    self.titleView.bottomLine.centerX = beginCenterX + distanceOffset;
    
    CGFloat beginWidth = currentCell.title.width;
    CGFloat nextWidth = nextCell.title.width;
    CGFloat widthOffset = fabs(beginWidth - nextWidth) * scale * ((beginWidth > nextWidth) ? -1 : 1);
    self.titleView.bottomLine.width = beginWidth + widthOffset;
    
    if(fabs(self.currentIndex - closeingIndex) >= 1)
        [self didContentViewEndScroll:(isLeft ? ceil(closeingIndex) : closeingIndex)];    
}

-(void)didContentViewEndScrollWithDecelerate:(BOOL)decelerate
{
    if(decelerate)
    {
        self.isDecelerate = decelerate;
//        if(self.superTenScrollView)
//            NSLog(@"===================================");
        return;
    }
    
    CGFloat index = self.contentView.contentOffset.x / self.contentView.width;
    NSInteger currentIndex = index;
    
    if((index - currentIndex) > 0.5)
        currentIndex++;
    
    [self didContentViewEndScroll:currentIndex];
}

-(void)didContentViewEndScroll:(NSInteger)currentIndex
{
    _isContentViewScrollEnd = YES;
    self.tenScrollView.scrollEnabled = YES;
    self.currentView.scrollEnabled = YES;
    
//    if(self.preContentView)
//    {
//        if(self.currentIndex != currentIndex)
//        {
//            //    父：1 ==== 0
//            //此处有一个bug，在高速移动情况下，当左滑返回会使得子View最大的索引归0
////            NSLog(@"父：%zd ==== %zd", self.currentIndex, currentIndex);
//            NSInteger row = currentIndex < self.currentIndex ? 0 : (self.preContentView.model.dataList.count - 1);
//            [self.preContentView.model didContentViewEndScroll:row];
//            self.preContentView.offsetX = row * self.preContentView.width;
//        }
//        self.preContentView = nil;
//    }
//
//    if(self.superTenScrollView && self.superIndex != self.superTenScrollView.model.currentIndex)
//    {
////        NSLog(@"子：%zd ==== %zd", self.superIndex, self.superTenScrollView.model.currentIndex);
//        currentIndex = self.superTenScrollView.model.currentIndex < self.superIndex ? 0 : (self.dataList.count - 1);
//    }
//
////    NSLog(@"%@ === %zd",self.superTenScrollView ? @"子：" :  @"父：", currentIndex);
//    self.contentView.offsetX = currentIndex * self.contentView.width;
    self.currentIndex = currentIndex;

    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [self.titleView collectionView:self.titleView didSelectItemAtIndexPath:indexPath];
    
    _isContentViewScrollEnd = false;
}

//4300344222215
//
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
}


-(void)titleViewDidScroll
{
    if(!self.superTenScrollView)
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
    if(self.isContentViewScrollEnd)
        return;
    
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
    
    if(![object isKindOfClass:[UIView class]] && ![object isKindOfClass:[UIViewController class]])
        object = nil;
    
    if(isBand)
    {
        /**绑定数据*/
        MTBaseDataModel* model = [MTBaseDataModel new];
        NSObject* data = [self getDataByIndex:index];
        model.data = [data isKindOfClass:[NSReuseObject class]] ? ((NSReuseObject*)data).data : data;
        model.identifier = MTTenScrollIdentifier;
        [object whenGetBaseModel:model];
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
//            if(!self.superTenScrollView)
//                NSLog(@"已设置 === %zd === %p",index, subView);
            self.currentView.height = self.tenScrollHeight - self.titleViewModel.titleViewHeight;
            
            NSInteger offsetY = self.tenScrollView.contentOffset.y;
            NSInteger maxOffsetY = self.tenScrollView.contentSize.height - self.tenScrollHeight;
            
            if(offsetY < maxOffsetY)
                self.currentView.offsetY = 0;
        }
    }
//    NSLog(@"===== %@",NSStringFromClass(self.currentView.class));
}


-(NSObject*)getDataByIndex:(NSInteger)index
{
    if(index >= self.dataList.count)
        return nil;
    
    NSObject* data = self.dataList[index];
    
    if(![data isKindOfClass:[NSObject class]])
        return nil;
    
    if([data.mt_reuseIdentifier isEqualToString:@"none"] && [data isKindOfClass:[NSString class]])
        data.mt_reuseIdentifier = (NSString*)data;
            
    return data;
}


#pragma mark - 懒加载

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
        
        Class c = NSClassFromString(obj.mt_reuseIdentifier);
        NSObject* object = c.new;
        
        if([object isKindOfClass:[UIView class]] || [object isKindOfClass:[UIViewController class]])
            [self.objectArr addObject:object];
        else
            [self.objectArr addObject:@""];
    }
    
    _titleList = [arr copy];
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    if(_currentIndex == currentIndex)
        return;
    
    _currentIndex = currentIndex;
    self.preIndexOffset = self.immediateIndex = currentIndex;
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
