//
//  MTTenScrollView.m
//  DaYiProject
//
//  Created by monda on 2018/12/26.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollView.h"
#import "MTTenScrollModel.h"
#import "MTTenScrollContentView.h"
#import "MTTenScrollTitleView.h"

#import "UIView+Frame.h"

@interface MTDynamicItem : NSObject<UIDynamicItem>

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, readonly) CGRect bounds;

@property (nonatomic, assign) CGAffineTransform transform;

@end

@implementation MTDynamicItem

-(CGRect)bounds
{
    return CGRectMake(0, 0, 1, 1);
}

@end

@interface MTTenScrollView ()
{
    MTTenScrollModel * _model;
}

@property (nonatomic,strong) UIDynamicAnimator* animator;

@property (nonatomic,strong) MTDynamicItem* item;

@property (nonatomic,assign) BOOL isSelfSimulateDecelerate;


@end

@implementation MTTenScrollView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self = [super initWithFrame:frame style:style])
    {
        if (@available(iOS 11.0, *))
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    
    return self;
}

-(void)addTarget:(id<MTDelegateProtocol,UITableViewDelegate>)target EmptyData:(NSObject *)emptyData DataList:(NSArray *)dataList SectionList:(NSArray *)sectionList
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:dataList];
    [arr addObject:self.model.tenScrollData];
  
    [super addTarget:self EmptyData:emptyData DataList:[arr copy] SectionList:sectionList];
}

-(void)reloadDataWithDataList:(NSArray *)dataList SectionList:(NSArray *)sectionList EmptyData:(NSObject *)emptyData
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:dataList];
    [arr addObject:self.model.tenScrollData];
    [super reloadDataWithDataList:[arr copy] SectionList:sectionList EmptyData:emptyData];
}

/*
 * 是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
        
    if([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
        return false;
    
    return YES;
}

#pragma mark - 代理

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animator removeAllBehaviors];
    
    [self.model tenScrollViewWillBeginDragging];
    
    [super scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.model tenScrollViewDidScroll];
    
    CGFloat offsetY = scrollView.offsetY;
    
    UIScrollView* currentView = self.model.currentView;
    
    static CGFloat preY;
    NSInteger maxOffsetY = scrollView.contentSize.height - scrollView.height;
    
    MTTenScrollView* superTenScrollView = self.model.superTenScrollView;
    if(superTenScrollView)
    {        
        NSInteger superMaxOffsetY = superTenScrollView.contentSize.height - superTenScrollView.height;
     
        if(self.offsetY > 0)
        {
            if(preY <= 0 && superTenScrollView.offsetY < (superTenScrollView.contentSize.height - superTenScrollView.model.tenScrollHeight - 1))
            {
                offsetY = 0;
            }
            else
            {
                superTenScrollView.offsetY = superMaxOffsetY;
                preY = 0;
            }
        }
        if(self.offsetY < 0)
        {
            preY = self.offsetY;
            self.offsetY = 0;
            return;
        }
    }
    else
    {
        if(currentView.offsetY > 0)
        {
            offsetY = maxOffsetY;
        }
        else
        {            
            
        }
    }
    
    if(self.isScrollTop)
    {
        if(self.offsetY >= maxOffsetY)
        {
            offsetY = maxOffsetY;            
        }
        
        self.isSelfSimulateDecelerate = self.offsetY < maxOffsetY;
    }
    else
    {
        if(currentView.offsetY > 0)
        {
            offsetY = maxOffsetY;
        }
    }
    
    
    scrollView.offsetY = offsetY;
    
    [super scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self simulateDecelerate];
    
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - 模拟减速
-(void)simulateDecelerate
{
    if(!self.isScrollTop || self.model.currentView.contentOffset.y > 0)
    {
        [self.model tenScrollViewEndScroll];
        return;
    }
    
    [self.animator removeAllBehaviors];
    self.item.center = CGPointZero;
    
    CGPoint vPoint = [self.panGestureRecognizer velocityInView:self];
    
    UIDynamicItemBehavior* behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item]];
    [behavior addLinearVelocity:CGPointMake(0, -vPoint.y) forItem:self.item];
    behavior.resistance = 2.0;
    
    UIScrollView* currentView = self.model.currentView;
    __block CGPoint lastCenter = CGPointZero;
    __weak __typeof(self) weakSelf = self;
    
    behavior.action = ^{
        
        CGFloat currentY = weakSelf.item.center.y - lastCenter.y;
        
        if(self.isSelfSimulateDecelerate)
            weakSelf.offsetY += currentY;
        else
        {
            CGFloat maxCurrentViewOffsetY = currentView.contentSize.height - currentView.height;
            if(currentView.offsetY > (maxCurrentViewOffsetY + 100))
                [self simulateCurrentViewSpring:currentView];
            else
                currentView.offsetY += currentY;
        }
        
        lastCenter = weakSelf.item.center;
        [self.model tenScrollViewEndScroll];
    };
    [self.animator addBehavior:behavior];
}

#pragma mark - 模拟回弹
-(void)simulateCurrentViewSpring:(UIScrollView*)currentView
{
    CGFloat maxCurrentViewOffsetY = currentView.contentSize.height - currentView.height;
    if(maxCurrentViewOffsetY < 0)
        maxCurrentViewOffsetY = 0;
    
    [self.animator removeAllBehaviors];
    self.item.center = currentView.contentOffset;
    
    UIAttachmentBehavior* behavior = [[UIAttachmentBehavior alloc] initWithItem:self.item attachedToAnchor:CGPointMake(0, maxCurrentViewOffsetY)];
    behavior.length = 0;
    behavior.damping = 1;
    behavior.frequency = 2;
    
        __weak __typeof(self) weakSelf = self;
    behavior.action = ^{
        
        currentView.contentOffset = weakSelf.item.center;
    };
    
    [self.animator addBehavior:behavior];
}


#pragma mark - 懒加载

-(void)setModel:(MTTenScrollModel *)model
{
    _model = model;
    
    model.tenScrollView = self;
}

-(MTTenScrollModel *)model
{
    if(!_model)
    {
        _model = [MTTenScrollModel new];
        _model.tenScrollView = self;
    }
    
    return _model;
}

-(MTDynamicItem *)item
{
    if(!_item)
    {
        _item = [MTDynamicItem new];
        _item.center = CGPointZero;
        _item.transform = CGAffineTransformIdentity;
    }
    
    return _item;
}

@end




@interface MTDelegateTenScrollTableView()


@end

@implementation MTDelegateTenScrollTableView

-(void)setupDefault
{
    [super setupDefault];
    
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.model.currentView = scrollView;
    
    [super scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat tenScrollOffsetY = self.model.tenScrollView.offsetY;
    
    NSInteger maxOffsetY = self.model.tenScrollView.contentSize.height - self.model.tenScrollView.height;

    if(self.isScrollTop)
    {
        if(tenScrollOffsetY < maxOffsetY)
            scrollView.contentOffset = CGPointZero;
    }
    else
    {
        if(self.offsetY <= 0)
            scrollView.contentOffset = CGPointZero;
        
        if(self.offsetY > 0)
            self.model.tenScrollView.offsetY = maxOffsetY;                
    }
    
    
    [super scrollViewDidScroll:scrollView];
}

@end

