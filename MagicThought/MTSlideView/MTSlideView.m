//
//  MTSlideView.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/6.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTSlideView.h"
#import "UIView+Frame.h"
#import "UIView+ViewController.h"
#import "MTConst.h"

@interface MTSlideView () <NSCacheDelegate,UIScrollViewDelegate>
{
    NSMutableArray *viewsArray;
    
    CGFloat start_offset_x;
}
@property (nonatomic, strong) NSCache *viewsCache;//存储页面(使用计数功能)

@end

@implementation MTSlideView


#pragma mark - init Method
- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources {
    if (self = [super initWithFrame:frame]) {
        viewsArray = [sources mutableCopy];
        [self defaultSet];
    }
    return self;
}

#pragma mark - default setting
- (void)defaultSet {
    self.clipsToBounds = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    [self setContentSize:CGSizeMake(viewsArray.count *self.width, self.height)];
    
    _countLimit = viewsArray.count;
}

#pragma mark - viewsCache
- (NSCache *)viewsCache {
    if (!_viewsCache) {
        _viewsCache = [[NSCache alloc] init];
        _viewsCache.countLimit = _countLimit;
        _viewsCache.delegate = self;
        _viewsCache.evictsObjectsWithDiscardedContent = YES;
    }
    return _viewsCache;
}


#pragma mark - default add View
- (void)createView {
    _showIndex = MIN(viewsArray.count-1, MAX(0, _showIndex));
    [self setContentOffset:CGPointMake(_showIndex * self.frame.size.width, 0)];
    
    if (_loadAll) {
        NSInteger startIndex;
        if (viewsArray.count-_showIndex > _countLimit) {
            startIndex = _showIndex;
        } else {
            startIndex = viewsArray.count - _countLimit;
        }
        for (NSInteger i = startIndex; i < startIndex + _countLimit; i ++) {
            [self addViewCacheIndex:i];
        }
    } else {
        [self setContentOffset:CGPointMake(_showIndex*self.width, 0) animated:NO];
    }
}

//- (void)addVcOrViews:(NSArray *)sources {
//    NSInteger startIndex = viewsArray.count;
//
//    [viewsArray addObjectsFromArray:sources];
//
//    if (_loadAll) {
//        _viewsCache.countLimit = viewsArray.count;
//        for (NSInteger i = startIndex; i < viewsArray.count; i ++) {
//            [self addViewCacheIndex:i];
//        }
//    }
//    [self setContentSize:CGSizeMake(viewsArray.count *self.width, self.height)];
//}


#pragma mark - addView
- (void)addViewCacheIndex:(NSInteger)index {
    id object = viewsArray[index];
    if ([object isKindOfClass:[NSString class]]) {
        Class class = NSClassFromString(object);
        if ([class isSubclassOfClass:[UIViewController class]]) {//vc
            UIViewController *vc = [class new];
            [self addVC:vc atIndex:index];
        } else if ([class isSubclassOfClass:[UIView class]]){//view
            UIView *view = [class new];
            [self addView:view atIndex:index];
        } else {
            NSLog(@"please enter the correct name of class!");
        }
    } else {
        if ([object isKindOfClass:[UIViewController class]]) {
            [self addVC:object atIndex:index];
        } else if ([object isKindOfClass:[UIView class]]) {
            [self addView:object atIndex:index];
        } else {
            NSLog(@"this class was not found!");
        }
    }
    
}

#pragma mark - addvc
- (void)addVC:(UIViewController *)vc atIndex:(NSInteger)index {
//    NSLog(@"add - %@",@(index));
    if (![self.viewsCache objectForKey:@(index)]) {
        [self.viewsCache setObject:vc forKey:@(index)];
    }
    
    vc.view.frame = CGRectMake(index*self.width, 0, self.width, self.height);
    [self.viewController addChildViewController:vc];
    [self addSubview:vc.view];
}

#pragma mark - addview
- (void)addView:(UIView *)view atIndex:(NSInteger)index {
    if (![self.viewsCache objectForKey:@(index)]) {
        [self.viewsCache setObject:view forKey:@(index)];
    }
    view.frame = CGRectMake(index*self.width, 0, self.width, self.height);
    [self addSubview:view];
}


- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
    NSInteger currentIndex = self.contentOffset.x/self.frame.size.width;
    if (!animated) {
        if ([self.segDelegate respondsToSelector:@selector(animationEndIndex:)]) {
            [self.segDelegate animationEndIndex:currentIndex];
        }
        if (self.animationEnd) {
            self.animationEnd(currentIndex);
        }
    }
    if (![_viewsCache objectForKey:@(currentIndex)]) {
        [self addViewCacheIndex:currentIndex];
    }
}

#pragma mark - scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    start_offset_x = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = self.contentOffset.x/self.contentSize.width;
    if ([self.segDelegate respondsToSelector:@selector(scrollOffsetScale:)]) {
        [self.segDelegate scrollOffsetScale:scale];
    } else if (self.offsetScale) {
        self.offsetScale(scale);
    }
    
    if (_addTiming == MTSegmentAddScale) {        
        NSInteger currentIndex = self.contentOffset.x/self.frame.size.width;
        BOOL left = start_offset_x>=self.contentOffset.x;
        NSInteger next_index = MAX(MIN(viewsArray.count-1, left?currentIndex:currentIndex+1), 0);
        if (fabs(scale*viewsArray.count-next_index)<(1-_addScale)) {
            if (![_viewsCache objectForKey:@(next_index)]) {
                [self addViewCacheIndex:next_index];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    //滑动结束
    NSInteger currentIndex = self.contentOffset.x/self.frame.size.width;
    if ([self.segDelegate respondsToSelector:@selector(scrollEndIndex:)]) {
        [self.segDelegate scrollEndIndex:currentIndex];
    }
    if (self.scrollEnd) {
        self.scrollEnd(currentIndex);
    }
    if (_addTiming == MTSegmentAddNormal) {
        if (![_viewsCache objectForKey:@(currentIndex)]) {
            [self addViewCacheIndex:currentIndex];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    //动画结束
    NSInteger currentIndex = self.contentOffset.x/self.frame.size.width;
    if ([self.segDelegate respondsToSelector:@selector(animationEndIndex:)]) {
        [self.segDelegate animationEndIndex:currentIndex];
    } else if (self.animationEnd) {
        self.animationEnd(currentIndex);
    }
}

#pragma mark - NSCacheDelegate
-(void)cache:(NSCache *)cache willEvictObject:(id)obj {
    //进入后台不清理
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        return;
    }
    NSLog(@"remove - %@",NSStringFromClass([obj class]));
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = obj;
        [vc.view removeFromSuperview];
        vc.view = nil;
        [vc removeFromParentViewController];
    } else {
        UIView *vw = obj;
        [vw removeFromSuperview];
        vw = nil;
    }
}

-(void)didSelectedWithHeader:(MTSlideHeader *)header Index:(NSInteger)index
{
    [header setSelectIndex:index];
    
    CGPoint offset = self.contentOffset;
    offset.x = index * mt_ScreenW();
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.contentOffset = offset;
    } completion:^(BOOL finished) {
        
        [header animationEnd];
        [weakSelf scrollViewDidEndDecelerating:weakSelf];
    }];
}


#pragma mark - dealloc
- (void)dealloc {
    self.delegate = nil;
    _viewsCache.delegate = nil;
    _viewsCache = nil;
}

@end
