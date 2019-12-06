//
//  MTPhotoBrowser.m
//  MTPhotoBrowser
//
//  Created by 王奕聪 on 2016/12/14.
//  Copyright © 2016年 com.king.app. All rights reserved.
//

#import "MTPhotoBrowser.h"
#import "MTPhotoPreviewViewCellModel.h"
#import "MTPhotoLook.h"
#import "MTConst.h"
#import "MTNavigationPhotoBrowserController.h"
#import "MTDelegateCollectionViewCell.h"
#import "MTDelegateCollectionView.h"
#import "MTPhotoBrowserViewModel.h"
#import "MTPhotoPreviewViewModel.h"
#import "NSObject+ReuseIdentifier.h"
#import "UIView+Frame.h"


#import "Masonry.h"


@interface MTPhotoBrowserCell : MTDelegateCollectionViewCell

@property(nonatomic,weak) MTPhotoLook* look;

@end

@interface MTPhotoBrowser ()<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic)  UIPageControl *pagePoint;

@property(nonatomic,weak) MTDelegateCollectionView* collectionView;

@property(nonatomic,weak) UIView* blackView;

@property (nonatomic,strong) NSMutableArray* imageArr;

@end

@implementation MTPhotoBrowser


#pragma mark - 成员方法

#pragma mark 刷新状态
-(void)reloadStatus
{
    [self.model reloadTitleAtIndex:self.model.currentIndex];
    self.pagePoint.currentPage = self.model.currentIndex;
    self.pagePoint.numberOfPages = self.model.cellModelArr.count;
    self.pagePoint.hidden = self.model.isHidePagePoint;
}

#pragma mark 刷新所有图片
-(void)loadData
{
    [self reloadStatus];
    
    [self.imageArr removeAllObjects];
    [self.imageArr addObjectsFromArray:self.model.cellModelArr];
    [self.collectionView reloadDataWithDataList:self.imageArr];
}

#pragma mark 展示
-(void)show
{
    if(!self.model || self.model.currentIndex < 0)
        return;
    

    if(self.model.isPopDismiss)
        [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.model.rootViewController.interactivePopGestureRecognizer];
    
    self.imageArr.arrBindSize(CGSizeMake(self.width + 10, self.height));
    [self loadData];
}


#pragma mark - collectionView代理

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.model isShowAnimateAtIndex:indexPath.row])
        return;
    
    indexPath.row == self.model.currentIndex ? [((MTPhotoBrowserCell*)cell).look.model startAnimate] : [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.model.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
}

#pragma mark - scrollView代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(fabs(scrollView.contentOffset.x - self.model.currentIndex * scrollView.width) < scrollView.halfWidth)
    {
        [self.model reloadTitleAtIndex:self.model.currentIndex];
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x / scrollView.width;
    [self.model reloadTitleAtIndex:offsetX > self.model.currentIndex ? ceil(offsetX) : offsetX];    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
        [self scrollViewDidEndMove:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndMove:scrollView];
}

-(void)scrollViewDidEndMove:(UIScrollView *)scrollView
{
    if(self.model.rootViewController.navigationBar.tag == 0)
        [self.model refreshNavigationBarStatus];
    
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if(self.model.currentIndex == index)
        return;
    
    UICollectionView* view = (UICollectionView*)scrollView;
    MTPhotoBrowserCell* cell = (MTPhotoBrowserCell*)[view cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.model.currentIndex inSection:0]];
    cell.look.zoomScale = 1;
    
    self.model.currentIndex = index;
    [self reloadStatus];
    [self.model.previewViewModel updatePreviewViewPosition];
}

#pragma mark 点击展示隐藏状态栏
- (void)didTap:(UITapGestureRecognizer *)tap
{
    [self.model refreshNavigationBarStatus];
}

#pragma mark - 懒加载

-(void)setModel:(MTPhotoBrowserViewModel *)model
{
    _model = model;
    
    __weak __typeof(self) weakSelf = self;
    
    model.changeAlpha = ^(CGFloat alpha){
        weakSelf.blackView.alpha = alpha;
    };
}

#pragma mark - 初始化单例

static MTPhotoBrowser *singleton = nil;
+(instancetype)shareBrowser {
    if (! singleton)
    {
        singleton = [[MTPhotoBrowser alloc] initPrivate];
    }
    return singleton;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"这是个单例"
                                   reason:@"请调用 [MTPhotoBrowser browser]"
                                 userInfo:nil];
    return nil;
}

+(void)clearBrowser
{
    singleton = nil;
}

//实现自己真正的私有初始化方法
- (instancetype)initPrivate {
    self  = [super init];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.imageArr = [NSMutableArray array];
        self.imageArr.arrBind(@"MTPhotoBrowserCell");
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tap];
        
        [self setupCollectionView];
    }
    
    return self;
}

#pragma mark 初始化属性
-(void)setupCollectionView
{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0;
    [self addSubview:view];
    self.blackView = view;
    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.bounds.size.width + 10, self.bounds.size.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    MTDelegateCollectionView* collectionView = [[MTDelegateCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.pagingEnabled = YES;
    [collectionView addTarget:self EmptyData:nil DataList:nil SectionList:nil];
    
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIPageControl* pagePoint = [UIPageControl new];
    pagePoint.numberOfPages = self.model.cellModelArr.count;
    [self addSubview:pagePoint];
    self.pagePoint = pagePoint;
    
    __weak typeof (self) weakSelf = self;
    [pagePoint mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.blackView.frame = self.bounds;
    self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width + 10, self.bounds.size.height);
}

@end





@implementation MTPhotoBrowserCell

-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:[MTPhotoPreviewViewCellModel class]])
        return;
    
    self.look.model = (MTPhotoPreviewViewCellModel*)object;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        MTPhotoLook* look = [[MTPhotoLook alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height)];
        
        [self addSubview:look];
        self.look = look;
    }
    return self;
}
@end
