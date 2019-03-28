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

#import "MTDefine.h"
#import "MTWordStyle.h"
#import "UIView+Frame.h"
#import "NSObject+ReuseIdentifier.h"
#import "NSObject+API.h"
#import "MTBaseDataModel.h"

NSString* MTTenScrollIdentifier = @"MTTenScrollIdentifier";

@interface MTTenScrollModel ()

@property (nonatomic,assign) BOOL isTitleViewTap;

// 定义缓存池
@property (nonatomic, strong) NSCache *cache;

@end

@implementation MTTenScrollModel


-(instancetype)init
{
    if(self = [super init])
    {
        self.cache = [NSCache new];
    }
    
    return self;
}

#pragma mark - 横向滚动contentView

-(void)contentViewDidScroll
{
    if(self.isTitleViewTap)
        return;
    CGFloat closeingIndex = self.contentView.contentOffset.x / self.contentView.width;
    
    //判断左右
    BOOL isLeft = closeingIndex < self.currentIndex;
    
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
    {
        self.currentIndex = isLeft ? ceil(closeingIndex) : closeingIndex;
        
        [self didContentViewEndScroll];
    }
}

-(void)didContentViewEndScroll
{
    _isContentViewScrollEnd = YES;
    
    if([self.titleView respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)])
        [self.titleView collectionView:self.titleView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    
    _isContentViewScrollEnd = false;
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
    
        currentCell.title.font = mt_font((currentFontSize));
        nextCell.title.font = mt_font((nextFontSize));
    }
    
    [currentCell.title sizeToFit];
    [nextCell.title sizeToFit];
}


#pragma mark - 标题栏点击后
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
    NSObject* data = [self getDataByIndex:index];
    NSString* identifier = data.mt_reuseIdentifier;
    
    if([identifier isEqualToString:@"none"])
        return nil;
    
    NSObject* object = [self getObjectByIdentifier:identifier];
    
    if(!object)
        object = [self createObjectByIdentifier:identifier];
    
    [self bandData:data WithObject:object];
    
    
    UIView* view;
    
    if([object isKindOfClass:[UIView class]])
        view = (UIView*)object;
    else
        view = ((UIViewController*)object).view;
    
    [self bandModelWithParentView:view Index:index];
    
    return view;
}

-(void)bandModelWithParentView:(UIView*)view Index:(NSInteger)index
{
    for(UIView* subView in view.subviews)
    {
        if([subView isKindOfClass:[MTDelegateTenScrollTableView class]])
        {
            ((MTDelegateTenScrollTableView*)subView).model = self;
            
            self.currentView = (MTDelegateTenScrollTableView*)subView;
        }
    }
    
    if(index != self.currentIndex)
        self.currentView = nil;
    self.isTenScrollViewScrollDownFix = false;
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

/**获取view*/
-(NSObject*)getObjectByIdentifier:(NSString*)identifier
{
    NSMutableArray* objArr = [self.cache objectForKey:identifier];
    
    for(NSObject* obj in objArr)
    {
        if(![obj isKindOfClass:[UIView class]] && ![obj isKindOfClass:[UIViewController class]])
            continue;
        
        if([obj isKindOfClass:[UIView class]] && (((UIView*)obj).tag == 0))
            return obj;
        else if([obj isKindOfClass:[UIViewController class]] && (((UIViewController*)obj).view.tag == 0))
            return obj;
    }
    
    return nil;
}

/**创建view*/
-(NSObject*)createObjectByIdentifier:(NSString*)identifier
{
    Class c = NSClassFromString(identifier);
    NSObject* object = c.new;
    
    if(![object isKindOfClass:[UIView class]] && ![object isKindOfClass:[UIViewController class]])
        return nil;
    
    NSMutableArray* objArr = [self.cache objectForKey:identifier];
    if(!objArr)
    {
        objArr = [NSMutableArray array];
        [self.cache setObject:objArr forKey:identifier];
    }
    
    [objArr addObject:object];
    return object;
}

/**绑定数据*/
-(void)bandData:(NSObject*)data WithObject:(NSObject*)object
{
    MTBaseDataModel* model = [MTBaseDataModel new];
    model.data = [data isKindOfClass:[NSReuseObject class]] ? ((NSReuseObject*)data).data : data;
    model.identifier = MTTenScrollIdentifier;
    [object whenGetBaseModel:model];
}

#pragma mark - 懒加载
-(void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    NSMutableArray* arr = [NSMutableArray array];
    
    for(NSObject* obj in dataList)
        [arr addObject:obj.mt_tagIdentifier];
    
    _titleList = [arr copy];
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

@end
