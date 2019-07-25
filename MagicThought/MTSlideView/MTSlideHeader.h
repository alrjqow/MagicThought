//
//  MTSlideHeader.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/6.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /**
     *  默认
     */
    MTSegmentHeadStyleDefault,
    /**
     *  line(下划线)
     */
    MTSegmentHeadStyleLine,
    /**
     *  arrow(箭头)
     */
    MTSegmentHeadStyleArrow,
    /**
     *  Slide(滑块)
     */
    MTSegmentHeadStyleSlide
} MTSegmentHeadStyle;


/**
 *
 * 分割样式,默认均分，其他样式按照标题长度计算
 */
typedef enum : NSUInteger {
    /*
     * 默认均分，根据maxTitles计算宽度，均分
     */
    MTSegmentLayoutDefault,
    
    /*
     * 居中(标题不足一屏时选择样式，反之设置后按照居左)
     */
    MTSegmentLayoutCenter,
    /*
     * 居左
     */
    MTSegmentLayoutLeft
    
} MTSegmentLayoutStyle;


@class MTSlideHeader;
@protocol MTSlideHeaderDelegate <NSObject>

@optional
/**
 *  selected
 *
 *  @param index index
 */
- (void)didSelectedWithHeader:(MTSlideHeader*)header Index:(NSInteger)index;

@end

@interface MTSlideHeader : UIView

@property(nonatomic,assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat marginLeft;
@property(nonatomic,assign) BOOL onlyUseSingleW;

/**
 *  初始化显示的下标。默认显示0
 */
@property (nonatomic, assign) NSInteger showIndex;
/**
 *  导航条的背景颜色
 */
@property (nonatomic, strong) UIColor *headColor;
/**
 *  非均分样式下按钮宽度 = 计算 + singleW_Add
 */
@property (nonatomic, assign) CGFloat singleW_Add;
/**
 * 设置完成后更改self的宽度 = titlesScroll.contentSize.width
 */
@property (nonatomic, assign) BOOL equalSize;


/*------------自定义导航栏可不设置------------*/
/**
 *  选择状态下的颜色，完全自定义样式下可不设置
 */
@property (nonatomic, strong) UIColor *selectColor;
/**
 *  未选中状态下的颜色,完全自定义样式下可不设置
 */
@property (nonatomic, strong) UIColor *deSelectColor;
/**
 *  字体的大小，完全自定义样式下可不设置
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 *  选中状态的缩放比例，SegmentHeadStyleSlide风格下此属性无用,设置缩放比例滑动过程中会有相应动画
 */
@property (nonatomic, assign) CGFloat fontScale;


/*------------添加更多按钮样式------------*/
/**
 * 添加更多样式
 */
@property (nonatomic, strong) UIView *moreButton;
/**
 * 更多按钮宽度
 */
@property (nonatomic, assign) CGFloat moreButton_width;


/*------------下划线风格------------*/
/**
 *  下划线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 *  下划线高度
 */
@property (nonatomic, assign) CGFloat lineHeight;
/**
 *  下划线相对于正常状态下的百分比，默认为1
 */
@property (nonatomic, assign) CGFloat lineScale;

/*------------箭头风格------------*/
/**
 *  箭头的颜色
 */
@property (nonatomic, strong) UIColor *arrowColor;

/*------------滑块风格------------*/
/**
 *  滑块的颜色
 */
@property (nonatomic, strong) UIColor *slideColor;
/**
 *  滑块的高度
 */
@property (nonatomic, assign) CGFloat slideHeight;
/**
 *  滑块的圆角大小
 */
@property (nonatomic, assign) CGFloat slideCorner;
/**
 *  滑块相对于正常状态下的百分比，默认为1
 */
@property (nonatomic, assign) CGFloat slideScale;


/**
 *  顶部导航栏下方的边线
 */
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, strong) UIColor *bottomLineColor;

/**
 *  设置当前屏幕最多显示的按钮数,只有在默认布局样式 - MLMSegmentLayoutDefault 下使用
 */
@property (nonatomic, assign) CGFloat maxTitles;


/**
 *  代理
 */
@property (nonatomic, weak) id<MTSlideHeaderDelegate> delegate;


/**
 *  block
 */
@property (nonatomic, copy) void(^selectedIndex)(NSInteger);


/**
 *  init method
 *
 *  @param frame  frame
 *  @param titles titles array
 *
 *  @return SegmentHeadView
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles;


/**
 *  init method
 *
 *  @param frame  frame
 *  @param titles titles array
 *  @param style  SegmentHeadStyle
 *
 *  @return SegmentHeadView
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    headStyle:(MTSegmentHeadStyle)style;

/**
 *  init method
 *
 *  @param frame  frame
 *  @param titles titles array
 *  @param style  SegmentHeadStyle
 *  @param layout  MLMSegmentLayoutStyle
 *
 *  @return SegmentHeadView
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    headStyle:(MTSegmentHeadStyle)style
                  layoutStyle:(MTSegmentLayoutStyle)layout;


/**
 *  set currentIndex
 *
 *  @param index , set currendIndex
 */
- (void)setSelectIndex:(NSInteger)index;

/**
 *  animation by scale
 *
 *  @param scale scale
 */
- (void)changePointScale:(CGFloat)scale;


/**
 *  在SegmentHeadStyleLine样式下，返回下划线view，可以根据自己的需求进行进一步定制，如自定义UIImageView添加
 *
 *  @return SegmentHeadStyleLine样式下，下划线view
 */

- (UIView *)getScrollLineView;
/**
 *  返回导航栏下方的下划线，可根据需求进行定制，如绘制虚线，添加UIImageView等
 *
 *  @return 返回导航栏下方的下划线
 */
- (UIView *)getBottomLineView;


/**
 * get sumWidth
 */
- (CGFloat)getSumWidth;

/**
 * 创建之后，初始化
 */
- (void)defaultAndCreateView;

/**
 * *重要*：与之关联的scroll动画结束调用
 */
- (void)animationEnd;


@end








