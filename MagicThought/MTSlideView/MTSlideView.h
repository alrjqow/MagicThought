//
//  MTSlideView.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/6.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSlideHeader.h"

//添加子视图的时机
typedef enum : NSUInteger {
    MTSegmentAddNormal,//滑动或者动画结束
    MTSegmentAddScale//根据设置滑动百分比添加0-1
} MTSegmentAddTiming;

@protocol MTSlideViewDelegate <NSObject>

@optional
///滑动结束
- (void)scrollEndIndex:(NSInteger)index;
///动画结束
- (void)animationEndIndex:(NSInteger)index;
///偏移的百分比
- (void)scrollOffsetScale:(CGFloat)scale;

@end

@interface MTSlideView : UIScrollView<MTSlideHeaderDelegate>

///第一次进入是否加载,YES加载countLimit个页面，默认 - NO
@property (nonatomic, assign) BOOL loadAll;
///缓存页面数目，默认 - all
@property (nonatomic, assign) NSInteger countLimit;
///默认显示开始的位置，默认 - 1
@property (nonatomic, assign) NSInteger showIndex;

///delegate
@property (nonatomic, weak) id<MTSlideViewDelegate> segDelegate;
///blcok
@property (nonatomic, copy) void(^scrollEnd)(NSInteger);
@property (nonatomic, copy) void(^animationEnd)(NSInteger);
@property (nonatomic, copy) void(^offsetScale)(CGFloat);

///添加时机,默认动画或者滑动结束添加
@property (nonatomic, assign) MTSegmentAddTiming addTiming;
///SegmentAddScale 时使用
@property (nonatomic, assign) CGFloat addScale;

- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources;

/**
 * 创建之后，初始化
 */
- (void)createView;



@end
