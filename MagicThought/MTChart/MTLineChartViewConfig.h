//
//  MTLineChartViewConfig.h
//  WSLineChart
//
//  Created by monda on 2019/7/3.
//  Copyright © 2019 zws. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MTLineChartViewConfig : NSObject

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;


/**是否显示小数*/
@property (nonatomic,assign) BOOL isPureFloatShow;

/**隐藏缩放极限提示*/
@property (nonatomic,assign) BOOL hideScaleLimitTips;

/**是否两端对齐*/
@property (nonatomic,assign) BOOL isJustifyAlign;

/**是否缩放自动隐藏坐标*/
@property (nonatomic,assign) BOOL isLabelScaleAutoHide;

/**仅显示某几个刻度*/
@property (nonatomic,strong) NSArray<NSNumber*>* xAxisMarkShowIndexArray;




/**x坐标轴默认间距*/
@property (nonatomic,assign) CGFloat xAxisDefaultMargin;

/**y坐标轴默认间距*/
@property (nonatomic,assign) CGFloat yAxisDefaultMargin;

/**x轴间距*/
@property (nonatomic,assign) CGFloat xAxisMargin;

/**y轴间距*/
@property (nonatomic,assign) CGFloat yAxisMargin;

/**坐标Label文字大小*/
@property (nonatomic,assign) CGFloat axisLabelFontSize;

/**坐标Label文字颜色*/
@property (nonatomic,strong) UIColor* axisLabelFontColor;

/**选中坐标的详情文字大小*/
@property (nonatomic,assign) CGFloat detailFontSize;

/**选中坐标的详情文字颜色*/
@property (nonatomic,strong) UIColor* detailFontColor;

/**选中文字*/
@property (nonatomic,copy) NSString* (^detailMsg) (NSInteger currentIndex);

/**选中文字水平内边距*/
@property (nonatomic,assign) CGFloat detailFontHMargin;

/**选中文字垂直内边距*/
@property (nonatomic,assign) CGFloat detailFontVMargin;

/**刻度颜色*/
@property (nonatomic,strong) UIColor* axisMarkColor;

/**x轴刻度宽度*/
@property (nonatomic,assign) CGFloat xAxisMarkWidth;

/**x轴刻度与文字的间距*/
@property (nonatomic,assign) CGFloat xAxisMarkAndLabelMargin;

/**y轴刻度宽度*/
@property (nonatomic,assign) CGFloat yAxisMarkWidth;

/**y轴刻度与文字的间距*/
@property (nonatomic,assign) CGFloat yAxisMarkAndLabelMargin;

/**分割线颜色*/
@property (nonatomic,strong) UIColor* separatorColor;

/**x轴颜色*/
@property (nonatomic,strong) UIColor* xAxisColor;

/**y轴颜色*/
@property (nonatomic,strong) UIColor* yAxisColor;

/**游标颜色*/
@property (nonatomic,strong) UIColor* youBiaoColor;

/**游标线类型*/
@property (nonatomic,assign) BOOL isYouBiaoWeak;

/**当前选中点偏移，用于手势滑动*/
@property (nonatomic,assign) CGFloat currentPointOffset;

/**折线颜色*/
@property (nonatomic,strong) UIColor* lineColor;

/**点颜色*/
@property (nonatomic,strong) UIColor* pointColor;
/**点半径*/
@property (nonatomic,assign) CGFloat pointRadius;
/**选中点半径*/
@property (nonatomic,assign,readonly) CGFloat pointSelectedRadius;
/**点选中的放大倍数*/
@property (nonatomic,assign) CGFloat pointSelectedZoomScale;

/**点外环颜色*/
@property (nonatomic,strong) UIColor* pointRingColor;
/**点外环半径偏移*/
@property (nonatomic,assign) CGFloat pointRingRadiusOffset;


/**点选中环颜色*/
@property (nonatomic,strong) UIColor* pointSelectedRingColor;
/**点选中环半径偏移*/
@property (nonatomic,assign) CGFloat pointSelectedRingRadiusOffset;

/**折线图背景色*/
@property (nonatomic,strong) UIColor* lineBgStartColor;
/**折线图背景色设置则作为渐变色*/
@property (nonatomic,strong) UIColor* lineBgEndColor;

/**是否正在拖动*/
@property (nonatomic,assign) BOOL isPanning;


/**y轴scrollView*/
@property (nonatomic,weak) UIScrollView* yAxisScrollView;
/**y轴View的高度*/
@property (nonatomic,assign) CGFloat MTYAxisViewHeight;
/**y轴的分段*/
@property (nonatomic,assign) CGFloat numberOfYAxisElements;
/**y轴原点*/
@property (nonatomic,assign) CGFloat yAxisOrigin;
/**y轴高度*/
@property (nonatomic,assign) CGFloat yAxisHeight;
/**y轴上间距*/
@property (nonatomic,assign) CGFloat yAxisLastSpace;
/**y轴左间距*/
@property (nonatomic,assign) CGFloat yAxisLeftMargin;
/**y轴文字左间距*/
@property (nonatomic,assign) CGFloat yAxisLabelLeftMargin;



/**x轴scrollView*/
@property (nonatomic,weak) UIScrollView* xAxisScrollView;
/**x轴View的宽度*/
@property (nonatomic,assign) CGFloat MTXAxisViewWidth;

/**x轴右间距*/
@property (nonatomic,assign) CGFloat xAxisRightSpace;

/**x轴左间距*/
@property (nonatomic,assign) CGFloat xAxisLeftSpace;
/**x轴默认左间距*/
@property (nonatomic,assign) CGFloat xAxisDefaultLeftSpace;

/**x轴长度*/
@property (nonatomic,assign) CGFloat xAxisWidth;

/**x轴是否以左边距为起点*/
@property (nonatomic,assign) BOOL isXAxisOriginLeftSpace;

/**游标索引*/
@property (nonatomic,assign) NSInteger currentIndex;

/**x轴最大索引*/
@property (nonatomic,assign) CGFloat xMaxIndex;
/**坐标点最大x值*/
@property (nonatomic,assign) CGFloat maxWidthX;


// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num;

- (void)drawLinearGradient:(CGContextRef)context path:(CGPathRef)path startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor;

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width;

- (void)drawWeakLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width;

@end

