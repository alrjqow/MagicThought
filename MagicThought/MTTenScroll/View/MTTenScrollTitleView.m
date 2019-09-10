//
//  MTTenScrollTitleView.m
//  DaYiProject
//
//  Created by monda on 2018/12/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollTitleView.h"
#import "MTTenScrollModel.h"
#import "MTTenScrollView.h"
#import "MTTenScrollContentView.h"


#import "UIView+Frame.h"
#import "MTCloud.h"
#import "MTWordStyle.h"
#import "UILabel+Word.h"
#import "NSObject+ReuseIdentifier.h"

@interface MTTenScrollTitleCell ()

@property (nonatomic,assign) BOOL isSelected;

@end

@interface MTTenScrollTitleView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) MTTenScrollTitleCell* selectedCell;

@end

@implementation MTTenScrollTitleView

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
    
    
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    self.clipsToBounds = false;
//    self.bounces = false;
    [self.panGestureRecognizer requireGestureRecognizerToFail:[MTCloud shareCloud].currentViewController.navigationController.interactivePopGestureRecognizer];
    [self addSubview:self.bottomLine];
    [self addTarget:self EmptyData:nil DataList:nil SectionList:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenReceiveNotification:) name:@"NotificationTenScrollViewScroll" object:nil];
}

-(void)whenDealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationTenScrollViewScroll" object:nil];
}

- (void)whenReceiveNotification:(NSNotification *)info
{
    self.scrollEnabled = [info.userInfo[@"canScroll"] boolValue];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bottomLine.maxY = self.height - 2;
}

#pragma mark - 代理

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.model.currentIndex)
    {
        if(!self.selectedCell)
        {
            self.selectedCell = (MTTenScrollTitleCell*)cell;
            ((MTTenScrollTitleCell*)cell).isSelected = YES;
            cell.selected = YES;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bottomLine.width = self.model.titleViewModel.isEqualBottomLineWidth ? self.model.titleViewModel.bottomLineWidth : ((MTTenScrollTitleCell*)cell).title.width;
            self.bottomLine.centerX = cell.centerX;
        }];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.model.titleViewModel.isEqualCellWidth)
        return CGSizeMake(self.model.titleViewModel.cellWidth, collectionView.height);
    
    return CGSizeMake([[[UILabel new] setWordWithStyle:mt_WordStyleMake(self.model.titleViewModel.normalStyle.wordSize, self.model.titleList[indexPath.row], nil)] sizeThatFits:CGSizeMake(MAXFLOAT, collectionView.height)].width, collectionView.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.model.currentIndex == indexPath.row)
        return;

    if(self.model.contentView.isRolling && self.model.isContentViewDragging)
    {
        return;
    }
    
    MTTenScrollTitleCell* cell = (MTTenScrollTitleCell*)[collectionView cellForItemAtIndexPath:indexPath];

    self.model.currentIndex = indexPath.row;
    self.selectedCell.isSelected = YES;
    self.selectedCell.selected = false;
    self.selectedCell = cell;
    self.selectedCell.isSelected = YES;
    self.selectedCell.selected = YES;

    [self reloadData];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    [self.model didTitleViewSelectedItem];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.model titleViewWillBeginDragging];    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate)
        return;
    
    [self.model didTitleViewEndScroll];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.model didTitleViewEndScroll];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.model titleViewDidScroll];
}

#pragma mark - 手势代理

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return otherGestureRecognizer == self.model.superTenScrollView.model.contentView.panGestureRecognizer;    
}

#pragma mark - 懒加载

-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    model.titleView = self;
    
    self.backgroundColor = model.titleViewModel.titleViewBgColor;
    self.bottomLine.backgroundColor = model.titleViewModel.bottomLineColor;
    
    self.contentInset = UIEdgeInsetsMake(0, model.titleViewModel.margin, 0, model.titleViewModel.margin);
    [self reloadDataWithDataList:(NSArray*)model.bandCount(model.titleList.count).band(@"MTTenScrollTitleCell") SectionList:@[@"".bandSpacing(mt_collectionViewSpacingMake(model.titleViewModel.padding, model.titleViewModel.padding, UIEdgeInsetsZero))]];
}

-(UIView *)bottomLine
{
    if(!_bottomLine)
    {
        _bottomLine = [UIView new];        
        _bottomLine.height = 2;
    }
    
    return _bottomLine;
}

@end




@implementation MTTenScrollTitleCell



-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:[MTTenScrollModel class]])
        return;
    
    self.model = (MTTenScrollModel*)object;
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.title = [UILabel new];
    self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.title];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.title sizeToFit];
    self.title.center = self.contentView.center;
}


-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    [self.title setWordWithStyle:model.currentIndex == self.indexPath.row ? model.titleViewModel.selectedStyle : model.titleViewModel.normalStyle];
    if(self.indexPath.row < model.titleList.count)
        self.title.text = model.titleList[self.indexPath.row];
    
    [self.title sizeToFit];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(!self.isSelected)
        return;
    
//    NSLog(@"%@ === %zd === %zd",selected ? @"Yes" : @"No", self.model.currentIndex, self.indexPath.row);
    
    self.isSelected = false;
    
    NSString* text = self.title.text;
    
    [self.title setWordWithStyle:selected ? self.model.titleViewModel.selectedStyle : self.model.titleViewModel.normalStyle];
    
    self.title.text = text;
    [self.title sizeToFit];
}

@end
