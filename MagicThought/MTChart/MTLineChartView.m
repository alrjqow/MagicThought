
//
//  MTLineChartView.m
//  WSLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "MTLineChartView.h"
#import "MTXAxisView.h"
#import "MTYAxisView.h"
#import "MTLineChartContentView.h"
#import "MTVernierView.h"
#import "MTHud.h"

@interface MTLineChartView ()<UIScrollViewDelegate>


@property (strong, nonatomic) MTYAxisView *yAxisView;
@property (strong, nonatomic) MTXAxisView *xAxisView;
@property (strong, nonatomic) VernierLineView *vernierLineView;
@property (strong, nonatomic) MTVernierView *MTVernierView;
@property (strong, nonatomic) MTLineChartContentView* lineChartView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic,strong) MTLineChartViewConfig* config;

@property (nonatomic,strong) UIView* foregroundView1;
@property (nonatomic,strong) UIView* foregroundView2;

@end




@implementation MTLineChartView

- (id)initWithFrame:(CGRect)frame Config:(MTLineChartViewConfig*)config{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.foregroundView1 = [UIView new];
        self.foregroundView1.backgroundColor = self.backgroundColor;
        
        self.foregroundView2 = [UIView new];
        self.foregroundView2.backgroundColor = self.backgroundColor;
        
        self.config = config;
        
        [self creatMTYAxisView];
        
        [self creatMTXAxisView];
        
        [self creatLineChartView];
        
        [self addSubview:self.foregroundView1];
        [self addSubview:self.foregroundView2];
        
        // 2. 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [self.lineChartView addGestureRecognizer:pinch];
        
        //拖动，轻点手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event_tapAction:)];
        [self.lineChartView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(event_panAction:)];
        pan.maximumNumberOfTouches = 1;
        pan.minimumNumberOfTouches = 1;
        [self.MTVernierView addGestureRecognizer:pan];
    }
    return self;
}

- (void)refreshWithXTitleArray:(NSArray*)xTitleArray YValueArray:(NSArray*)yValueArray
{
    self.config.currentIndex = 0;
    self.config.xTitleArray = xTitleArray;
    self.config.yValueArray = yValueArray;
    
    [self refreshMTYAxisView];
    [self refreshMTXAxisView];
    [self refreshLineChartView];
}

- (void)creatMTYAxisView {
    
    UIScrollView* scrollView = [UIScrollView new];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    scrollView.delegate = self;
    self.config.yAxisScrollView = scrollView;
    
    self.yAxisView = [MTYAxisView new];
    self.yAxisView.config = self.config;
    [scrollView addSubview:self.yAxisView];
    
    [self refreshMTYAxisView];
}

- (void)refreshMTYAxisView
{
    CGRect yAxisScrollViewRect = CGRectMake(0.5, 0, self.config.yAxisLeftMargin, self.frame.size.height);
    self.config.yAxisScrollView.frame = yAxisScrollViewRect;
    
    CGRect yViewRect = CGRectMake(0, 0, self.config.yAxisLeftMargin, self.config.numberOfYAxisElements * self.config.yAxisMargin + self.config.yAxisLastSpace + self.config.yAxisMarkWidth + self.config.yAxisMarkAndLabelMargin + self.config.axisLabelFontSize * 1.5);
    if(yViewRect.size.height < self.config.yAxisScrollView.frame.size.height)
        yViewRect.size.height = self.config.yAxisScrollView.frame.size.height;
    self.yAxisView.frame = yViewRect;
    
    
    self.config.yAxisScrollView.contentSize = self.yAxisView.frame.size;
    self.config.yAxisScrollView.contentOffset = CGPointMake(0, self.yAxisView.frame.size.height - self.frame.size.height);
    
    CGFloat x = self.config.yAxisLeftMargin - self.config.yAxisMarkWidth - 1;
    CGFloat y = self.config.yAxisOrigin - self.config.yAxisScrollView.contentOffset.y + 1.6;
    CGFloat w = self.config.yAxisMarkWidth + 2;
    CGFloat h = self.config.axisLabelFontSize * 0.5;
    self.foregroundView1.frame = CGRectMake(x, y, w, h);
    
    x = self.config.yAxisScrollView.frame.origin.x;
    y = self.foregroundView1.frame.origin.y + h;
    w = self.config.yAxisScrollView.frame.size.width;
    h = self.config.yAxisScrollView.frame.size.height - (self.config.yAxisOrigin - self.config.yAxisScrollView.contentOffset.y) - self.foregroundView1.frame.size.height - 1.6;
    self.foregroundView2.frame = CGRectMake(x, y, w, h);
    
    [self.yAxisView setNeedsDisplay];
}

- (void)creatMTXAxisView {
    
    CGFloat y = self.config.yAxisOrigin - self.config.yAxisScrollView.contentOffset.y;
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.config.yAxisLeftMargin, y, self.frame.size.width - self.config.yAxisLeftMargin, self.frame.size.height - y)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    scrollView.delegate = self;
    
    self.config.xAxisScrollView = scrollView;
    
    CGRect xViewRect = CGRectMake(0, 0, (self.config.xTitleArray.count - 1) * self.config.xAxisMargin + self.config.xAxisLeftSpace + self.config.xAxisRightSpace, scrollView.frame.size.height);
    if(xViewRect.size.width < scrollView.frame.size.width)
        xViewRect.size.width = scrollView.frame.size.width;
    
    self.xAxisView = [[MTXAxisView alloc] initWithFrame:xViewRect];
    self.xAxisView.config = self.config;
    
    [scrollView addSubview:self.xAxisView];
    
    scrollView.contentSize = self.xAxisView.frame.size;
}

-(void)refreshMTXAxisView
{
    CGFloat y = self.config.yAxisOrigin - self.config.yAxisScrollView.contentOffset.y;
    CGRect xAxisScrollViewRect = CGRectMake(self.config.yAxisLeftMargin, y, self.frame.size.width - self.config.yAxisLeftMargin, self.frame.size.height - y);
    self.config.xAxisScrollView.frame = xAxisScrollViewRect;
    
    
    CGRect xViewRect = CGRectMake(0, 0, (self.config.xTitleArray.count - 1) * self.config.xAxisMargin + self.config.xAxisLeftSpace + self.config.xAxisRightSpace, self.config.xAxisScrollView.frame.size.height);
    if(xViewRect.size.width < self.config.xAxisScrollView.frame.size.width)
        xViewRect.size.width = self.config.xAxisScrollView.frame.size.width;
    self.xAxisView.frame = xViewRect;
    
    
    self.config.xAxisScrollView.contentSize = self.xAxisView.frame.size;
    
    [self.xAxisView setNeedsDisplay];
}

- (void)creatLineChartView {
    
    CGFloat h = self.config.yAxisOrigin - self.config.yAxisScrollView.contentOffset.y;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.config.yAxisLeftMargin, 0, self.frame.size.width - self.config.yAxisLeftMargin, h)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    _scrollView.delegate = self;
    
    self.lineChartView = [[MTLineChartContentView alloc] initWithFrame:CGRectMake(0, 0, self.xAxisView.frame.size.width, self.yAxisView.frame.size.height - self.config.xAxisMarkWidth - self.config.xAxisMarkAndLabelMargin - self.config.axisLabelFontSize)];
    self.lineChartView.config = self.config;
    
    
    [_scrollView addSubview:self.lineChartView];
    
    _scrollView.contentSize = self.lineChartView.frame.size;
    _scrollView.contentOffset = CGPointMake(0, self.lineChartView.frame.size.height - _scrollView.frame.size.height);
    
    
    self.MTVernierView = [[MTVernierView alloc] initWithFrame:CGRectMake(self.config.xAxisLeftSpace - self.config.pointSelectedRadius * 0.5, 0, self.config.pointSelectedRadius, _scrollView.frame.size.height)];
    self.MTVernierView.config = self.config;
    
    [self.scrollView addSubview:self.MTVernierView];
    
    self.vernierLineView = [VernierLineView new];
    self.vernierLineView.config = self.config;
    self.vernierLineView.center = self.MTVernierView.center;
    self.vernierLineView.bounds = CGRectMake(0, 0, 1, self.MTVernierView.frame.size.height);
    
    [self.scrollView insertSubview:self.vernierLineView atIndex:0];
}

- (void)refreshLineChartView
{
    CGFloat h = self.config.yAxisOrigin - self.config.yAxisScrollView.contentOffset.y;
    _scrollView.frame = CGRectMake(self.config.yAxisLeftMargin, 0, self.frame.size.width - self.config.yAxisLeftMargin, h);
    
    
    self.lineChartView.frame = CGRectMake(0, 0, self.xAxisView.frame.size.width, self.yAxisView.frame.size.height - self.config.xAxisMarkWidth - self.config.xAxisMarkAndLabelMargin - self.config.axisLabelFontSize);
    
    
    _scrollView.contentSize = self.lineChartView.frame.size;
    _scrollView.contentOffset = CGPointMake(0, self.lineChartView.frame.size.height - _scrollView.frame.size.height);
    
    
    self.MTVernierView.frame = CGRectMake(self.config.xAxisLeftSpace - self.config.pointSelectedRadius * 0.5, 0, self.config.pointSelectedRadius, _scrollView.frame.size.height);
    
    
    self.vernierLineView.center = self.MTVernierView.center;
    self.vernierLineView.bounds = CGRectMake(0, 0, 1, self.MTVernierView.frame.size.height);
    
    
    [self.lineChartView setNeedsDisplay];
    [self.MTVernierView setNeedsDisplay];
    [self.vernierLineView setNeedsDisplay];
}

// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    static CGFloat leftMagin;
    static CGFloat currentIndex;
    static CGFloat topMagin;
    static CGFloat centerX;
    static CGFloat centerY;
    static CGFloat lineChartViewXScale;
    static CGFloat lineChartViewYScale;
    
    if (recognizer.state == 3) {
        
        
        if(floor(self.xAxisView.frame.size.width) <= self.scrollView.frame.size.width)
        {
            self.config.xAxisMargin = (self.scrollView.frame.size.width - self.config.xAxisRightSpace - self.config.xAxisLeftSpace) / (self.config.xTitleArray.count - 1);
            
            if(self.config.xAxisMargin > self.config.xAxisDefaultMargin)
                self.config.xAxisMargin = self.config.xAxisDefaultMargin;
            
            CGRect frame = self.lineChartView.frame;
            frame.size.width = self.scrollView.frame.size.width;
            self.lineChartView.frame = frame;
            
            frame = self.xAxisView.frame;
            frame.size.width = self.scrollView.frame.size.width;
            self.xAxisView.frame = frame;
        }
        
        
        CGFloat yAxisHeight = self.config.numberOfYAxisElements * self.config.yAxisMargin + self.config.yAxisLastSpace + 0.5 * self.config.axisLabelFontSize;
        
        if(floor(yAxisHeight) <= self.scrollView.frame.size.height)
        {
            self.config.yAxisMargin = (self.scrollView.frame.size.height - 0.5 * self.config.axisLabelFontSize - self.config.yAxisLastSpace) / self.config.numberOfYAxisElements;
            
            if(self.config.yAxisMargin > self.config.yAxisDefaultMargin)
                self.config.yAxisMargin = self.config.yAxisDefaultMargin;
        }
        
        [self.lineChartView setNeedsDisplay];
        [self.xAxisView setNeedsDisplay];
        [self.yAxisView setNeedsDisplay];
        
    }else{
        
        if (recognizer.numberOfTouches < 2)
            return;
        
        CGFloat xAxisLeftSpace = self.config.xAxisLeftSpace;
        if(self.config.isXAxisOriginLeftSpace)
        {
            xAxisLeftSpace *= (recognizer.scale * 1);
            if (xAxisLeftSpace > self.config.xAxisDefaultLeftSpace)
                xAxisLeftSpace = self.config.xAxisDefaultLeftSpace;
        }
        
        CGFloat xAxisMargin = self.config.xAxisMargin;
        xAxisMargin *= (recognizer.scale * 1);
        if (xAxisMargin > self.config.xAxisDefaultMargin)
            xAxisMargin = self.config.xAxisDefaultMargin;
        
        //相对于屏幕的位置
        CGFloat yAxisMargin = self.config.yAxisMargin;
        yAxisMargin *= (recognizer.scale * 1);
        if (yAxisMargin > self.config.yAxisDefaultMargin)
            yAxisMargin = self.config.yAxisDefaultMargin;
        
        //        if(self.config.xTitleArray.count * xAxisMargin + self.config.xAxisRightSpace + xAxisLeftSpace < self.scrollView.frame.size.width && self.config.numberOfYAxisElements * yAxisMargin + self.config.yAxisLastSpace + self.config.axisLabelFontSize * 0.5 < self.scrollView.frame.size.height)
        //            return;
        
        //相对于屏幕的位置
        if((self.config.xTitleArray.count - 1) * xAxisMargin + xAxisLeftSpace + self.config.xAxisRightSpace >= self.scrollView.frame.size.width)
        {
            self.config.xAxisMargin = xAxisMargin;
            self.config.xAxisLeftSpace = xAxisLeftSpace;
        }
        
        if(self.config.numberOfYAxisElements * yAxisMargin + self.config.yAxisLastSpace + self.config.axisLabelFontSize * 0.5 >= self.scrollView.frame.size.height)
            self.config.yAxisMargin = yAxisMargin;
        
        
        //2.获取捏合中心点 -> 捏合中心点距离scrollviewcontent左侧的距离
        if(recognizer.state == UIGestureRecognizerStateBegan)
        {
            CGPoint p1 = [recognizer locationOfTouch:0 inView:self.lineChartView];
            CGPoint p2 = [recognizer locationOfTouch:1 inView:self.lineChartView];
            centerX = (p1.x+p2.x)/2;
            centerY = (p1.y+p2.y)/2;
            
            leftMagin = centerX - self.scrollView.contentOffset.x;
            topMagin = centerY - self.scrollView.contentOffset.y;
            
            lineChartViewXScale = centerX / self.lineChartView.frame.size.width;
            lineChartViewYScale = centerY / self.lineChartView.frame.size.height;
            
            currentIndex = centerX / self.config.xAxisMargin;
        }
        
        self.lineChartView.frame = CGRectMake(0, 0, (self.config.xTitleArray.count - 1) * self.config.xAxisMargin + self.config.xAxisLeftSpace + self.config.xAxisRightSpace, self.yAxisView.frame.size.height - self.xAxisView.frame.size.height);
        
        CGRect MTXAxisViewRect = self.xAxisView.frame;
        MTXAxisViewRect.size.width = self.lineChartView.frame.size.width;
        if(MTXAxisViewRect.size.width < self.config.xAxisScrollView.frame.size.width)
            MTXAxisViewRect.size.width = self.config.xAxisScrollView.frame.size.width;
        self.xAxisView.frame = MTXAxisViewRect;
        
        CGRect MTYAxisViewRect = self.yAxisView.frame;
        MTYAxisViewRect.size.height = self.config.numberOfYAxisElements * self.config.yAxisMargin + self.config.yAxisLastSpace + self.config.yAxisMarkWidth + self.config.yAxisMarkAndLabelMargin + self.config.axisLabelFontSize * 1.5;
        if(MTYAxisViewRect.size.height < self.config.yAxisScrollView.frame.size.height)
            MTYAxisViewRect.size.height = self.config.yAxisScrollView.frame.size.height;
        self.yAxisView.frame = MTYAxisViewRect;
        
        [self.lineChartView setNeedsDisplay];
        [self.xAxisView setNeedsDisplay];
        [self.yAxisView setNeedsDisplay];
        
        CGFloat offsetX = self.lineChartView.frame.size.width * lineChartViewXScale - leftMagin;
        CGFloat offsetY = self.lineChartView.frame.size.height * lineChartViewYScale - topMagin;
        
        if(offsetX > self.lineChartView.frame.size.width - self.scrollView.frame.size.width)
            offsetX = self.lineChartView.frame.size.width - self.scrollView.frame.size.width;
        if(offsetX < 0)
            offsetX = 0;
        
        if(offsetY > self.lineChartView.frame.size.height - self.scrollView.frame.size.height)
            offsetY = self.lineChartView.frame.size.height - self.scrollView.frame.size.height;
        if(offsetY < 0)
            offsetY = 0;
        
        self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
        
        if(!self.config.hideScaleLimitTips)
        {
            if (recognizer.scale > 1 && self.config.xAxisMargin == self.config.xAxisDefaultMargin && self.config.yAxisMargin == self.config.yAxisDefaultMargin) {
                
                [[UIApplication sharedApplication].keyWindow showToast:@"已经放至最大"];
            }
            
            if(recognizer.scale < 1 && self.yAxisView.frame.size.height == self.config.yAxisScrollView.frame.size.height && self.xAxisView.frame.size.width == self.config.xAxisScrollView.frame.size.width){
                
                [[UIApplication sharedApplication].keyWindow showToast:@"已经缩至最小"];
            }
        }
        
        recognizer.scale = 1.0;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.xAxisView.frame.size.width, self.yAxisView.frame.size.height - self.config.xAxisMarkWidth - self.config.xAxisMarkAndLabelMargin - self.config.axisLabelFontSize);
    self.config.xAxisScrollView.contentSize = CGSizeMake(self.xAxisView.frame.size.width, self.config.xAxisScrollView.contentSize.height);
    self.config.yAxisScrollView.contentSize = CGSizeMake(self.config.yAxisScrollView.contentSize.width, self.yAxisView.frame.size.height);
    
    CGPoint center = self.MTVernierView.center;
    center.x = self.config.currentIndex * self.config.xAxisMargin + self.config.xAxisLeftSpace;
    self.MTVernierView.center = center;
    self.vernierLineView.center = self.MTVernierView.center;
}




- (void)event_panAction:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.config.isPanning = YES;
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            [self changeCurrentIndexWithLocation:self.MTVernierView.center];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat indexValue = (self.MTVernierView.center.x - self.config.xAxisLeftSpace) / self.config.xAxisMargin;
            CGFloat scale = indexValue - self.config.currentIndex;
            
            NSInteger scaleIntegerValue = scale;
            if(scale > 1)
                self.config.currentIndex++;
            if(scale < -1)
                self.config.currentIndex--;
            
            NSInteger nextIndex = self.config.currentIndex + (scale > 0 ? 1 : -1);
            scale = scale - scaleIntegerValue;
            scale = ABS(scale);
            
            if(nextIndex >= self.config.xTitleArray.count)
                nextIndex = self.config.xTitleArray.count - 2;
            
            if(nextIndex < 0)
                nextIndex = 0;
            
            
            CGFloat currentY = self.config.yAxisOrigin - (((NSNumber *)self.config.yValueArray[self.config.currentIndex]).floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight;
            CGFloat nextY = self.config.yAxisOrigin - (((NSNumber *)self.config.yValueArray[nextIndex]).floatValue - self.config.yMin)/(self.config.yMax - self.config.yMin)  * self.config.yAxisHeight;
            
            CGFloat currentPointOffset = ABS(currentY - nextY) * (currentY > nextY ? -1 : 1);
            
            self.config.currentPointOffset = scale * currentPointOffset;
            
            CGPoint offset = [pan translationInView:self.MTVernierView];
            CGPoint center = self.MTVernierView.center;
            center.x += offset.x;
            if(center.x < self.config.xAxisLeftSpace)
                center.x = self.config.xAxisLeftSpace + 0.0000001;
            if(center.x > (self.config.xTitleArray.count - 1) * self.config.xAxisMargin + self.config.xAxisLeftSpace)
                center.x = (self.config.xTitleArray.count - 1) * self.config.xAxisMargin + self.config.xAxisLeftSpace - 0.0000001;
            
            self.MTVernierView.center = center;
            self.vernierLineView.center = self.MTVernierView.center;
            [self.MTVernierView setNeedsDisplay];
            [self.lineChartView setNeedsDisplay];
            [pan setTranslation:CGPointZero inView:self.MTVernierView];//初始化MTVernierView的转换坐标，否则会一直积累
            
            break;
        }
            
        default:
            break;
    }
}

- (void)event_tapAction:(UITapGestureRecognizer *)tap
{
    [self changeCurrentIndexWithLocation:[tap locationInView:self.lineChartView]];
}

-(void)changeCurrentIndexWithLocation:(CGPoint)location
{
    CGFloat indexValue = (location.x - self.config.xAxisLeftSpace) / self.config.xAxisMargin;
    NSInteger index = indexValue;
    
    CGFloat offset = indexValue - index;
    
    if(offset > 0.5)
        index++;
    
    //不要这个，不然拖动的时候无法复位
    //    if(index == self.config.currentIndex)
    //        return;
    
    if(index >= self.config.yValueArray.count)
        return;
    
    self.config.currentIndex = index;
    
    self.config.currentPointOffset = 0;
    self.config.isPanning = false;
    
    CGPoint center = self.MTVernierView.center;
    center.x = self.config.currentIndex * self.config.xAxisMargin + self.config.xAxisLeftSpace;
    self.MTVernierView.center = center;
    self.vernierLineView.center = self.MTVernierView.center;
    [self.MTVernierView setNeedsDisplay];
    
    //相对于屏幕的位置
    CGPoint screenLoc = CGPointMake(self.config.currentIndex * self.config.xAxisMargin + self.config.currentPointOffset + self.config.xAxisLeftSpace - self.scrollView.contentOffset.x, location.y);
    self.lineChartView.screenLoc = screenLoc;
}

-(MTLineChartViewConfig *)config
{
    if(!_config)
    {
        _config = [MTLineChartViewConfig new];
    }
    
    return _config;
}

#pragma mark - scrollView Delegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView)
    {
        //        NSLog(@"offsetY: %lf",scrollView.contentOffset.y);
        self.config.xAxisScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        self.config.yAxisScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }
    else if(scrollView == self.config.xAxisScrollView)
        self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.scrollView.contentOffset.y);
    else if(scrollView == self.config.yAxisScrollView)
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, scrollView.contentOffset.y);
}

@end

