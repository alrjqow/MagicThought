//
//  MTCountingView.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/13.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTCountingView.h"
#import "MTConst.h"
#import "Masonry.h"

#define kDefaultStartAngle                      -M_PI_2
#define kDefaultEndAngle                        2 * M_PI - M_PI_2
#define kDefaultMinValue                        0
#define kDefaultMaxValue                        120
#define kDefaultLimitValue                      50

#define kDefaultRingThickness                   3
#define kDefaultRingBackgroundColor             [UIColor colorWithWhite:0.9 alpha:1]         
#define kDefaultRingCenterBackgroundColor             rgba(0, 0, 0, 0.7)

#define kDefaultRingColor                       [UIColor colorWithRed:76.0/255 green:217.0/255 blue:100.0/255 alpha:1]

#define kDefaultDivisionsRadius                 1.25
#define kDefaultDivisionsPadding                12

#define kDefaultValueFont                       [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:140]
#define kDefaultValueTextColor                  [UIColor colorWithWhite:0.1 alpha:1]


NSString*  MTCountingViewOrder = @"MTCountingViewOrder";
@interface MTCountingView ()
{
    CGFloat timeDelta;
    NSInteger acceleration;
}

// For calculation
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;


@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat currentValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat limitValue;

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, weak) UILabel *valueLabel;
@property(nonatomic,weak) UIButton* btn;

@property(nonatomic,strong) NSTimer* timer;

@end

@implementation MTCountingView

#pragma mark - 生命周期

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)dealloc
{
    [self stopTimer];
}

#pragma mark - 初始化

- (void)initialize
{
    if(!self.backgroundColor)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    acceleration = 40;
    timeDelta = 1.0/10;
    
    self.isAnimate = YES;
    
    
    self.defaultColor = hex(0xffb035);//[UIColor colorWithRed:11.0/255 green:150.0/255 blue:246.0/255 alpha:1];
    self.limitColor = [UIColor colorWithRed:255.0/255 green:59.0/255 blue:48.0/255 alpha:1];
    
    // Set default values
    _startAngle = kDefaultStartAngle;
    _endAngle = kDefaultEndAngle;
    
    _value = kDefaultMinValue;
    _minValue = kDefaultMinValue;
    _maxValue = kDefaultMaxValue;
    _limitValue = kDefaultLimitValue;
    
    // Ring
    _ringThickness = kDefaultRingThickness;
    _ringBackgroundColor = kDefaultRingBackgroundColor;
    _ringCenterBackgroundColor = kDefaultRingCenterBackgroundColor;
    
    // Value Text
    _valueFont = kDefaultValueFont;
    _valueTextColor = kDefaultValueTextColor;
    
    [self.layer addSublayer:self.progressLayer];
    
    UILabel* valueLabel = [[UILabel alloc] init];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.text = [NSString stringWithFormat:@"%0.f", self.value];
    valueLabel.font = self.valueFont;
    valueLabel.adjustsFontSizeToFitWidth = YES;
    valueLabel.minimumScaleFactor = 10/self.valueLabel.font.pointSize;
    valueLabel.textColor = self.valueTextColor;
    [self addSubview:valueLabel];
    self.valueLabel = valueLabel;
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.minimumScaleFactor = 10/self.valueLabel.font.pointSize;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"跳过" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.btn = btn;
    
    __weak typeof (self) weakSelf = self;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakSelf);
    }];
    
    
    self.valueLabel.hidden = self.canClick;
    self.btn.hidden = !self.canClick;
}

#pragma mark - 点击


-(void)click:(UIButton*)btn
{
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self withOrder:MTCountingViewOrder];
}

#pragma mark - 布局子控件

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.btn.titleLabel.font = [UIFont systemFontOfSize:self.bounds.size.width * 0.3];
    //    self.ringThickness = self.bounds.size.width * 0.07;//0.04
    CGFloat insetX = self.ringThickness + kDefaultDivisionsPadding * 2 + kDefaultDivisionsRadius;
    CGRect frame = CGRectOffset(CGRectInset(self.progressLayer.frame, insetX, insetX), 0, -kDefaultDivisionsPadding/2);
    
    self.valueLabel.frame = frame;
}

#pragma mark - 成员方法

-(void)startCounting
{
    if(self.totalTime)
    {
        [self stopTimer];
        
        [self timer];
    }
}

- (void)updateGaugeTimer:(NSTimer *)timer
{
    CGFloat velocity = self.value;
    // Calculate velocity
    velocity += timeDelta * acceleration;
    
//    CGFloat targetValue = self.currentValue != 0 ? self.currentValue : self.maxValue;

    CGFloat targetValue = self.currentValue;
    
    if (velocity > targetValue) {
        velocity = targetValue;
        acceleration = -acceleration;
        
        if(!self.repeat)
        {
            [self stopTimer];
            if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
                [self.mt_delegate doSomeThingForMe:self withOrder:MTCountingViewOrder];
        }
    }
    if (self.repeat && velocity < self.minValue) {
        velocity = self.minValue;
        acceleration = -acceleration;
    }
    
    self.value = velocity;
}


- (void)strokeGauge
{
    /*!
     *  Set progress for ring layer
     */
    CGFloat progress = self.maxValue ? (self.value - self.minValue)/(self.maxValue - self.minValue) : 0;
    if(self.opposite)
        self.progressLayer.strokeStart = progress;
    else
        self.progressLayer.strokeEnd = progress;
    /*!
     *  Set ring stroke color
     */
    UIColor *  ringColor;
    if(self.limitTime)
        ringColor = self.value >= self.limitValue ? self.limitColor : self.defaultColor;
    else
        ringColor = self.defaultColor;
    
    
    self.progressLayer.strokeColor = ringColor.CGColor;
}


- (void)drawRect:(CGRect)rect
{
    /*!
     *  Prepare drawing
     */
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat ringRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.ringThickness/2;
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //使用UIBezierPath 与直接使用上下文划线，设置同一数值，用UIBezierPath画出来的线要更粗
    /*!
     *  Draw the ring background
     */
    //    CGContextSetLineWidth(context, self.ringThickness);
    //    CGContextBeginPath(context);
    //    CGContextAddArc(context, center.x, center.y, ringRadius, 0, M_PI * 2, 0);
    //    CGContextSetStrokeColorWithColor(context, self.ringBackgroundColor.CGColor);
    //    CGContextStrokePath(context);
    
    [self.ringBackgroundColor setStroke];
    UIBezierPath *ringBackgroundPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                      radius:ringRadius
                                                                  startAngle:0
                                                                    endAngle:M_PI * 2
                                                                   clockwise:false];
    ringBackgroundPath.lineWidth = self.ringThickness;
    [ringBackgroundPath stroke];
    
    
    
    
    /*!
     *  Draw the ring progress background
     */
    //    CGContextBeginPath(context);
    //    CGContextAddArc(context, center.x, center.y, ringRadius * 0.93, self.startAngle, self.endAngle, 0);
    //    CGContextSetFillColorWithColor(context, self.ringCenterBackgroundColor.CGColor);
    //    CGContextFillPath(context);
    
    [self.ringCenterBackgroundColor setFill];
    UIBezierPath *ringProgressBackgroundPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                              radius:ringRadius - self.ringThickness/2
                                                                          startAngle:0
                                                                            endAngle:M_PI * 2
                                                                           clockwise:false];
    ringProgressBackgroundPath.lineWidth = self.ringThickness;
    [ringProgressBackgroundPath fill];
    
    
    
    /*!
     *  Progress Layer
     */
    
    if(self.isAnimate)
    {
        self.progressLayer.frame = CGRectMake(center.x - ringRadius - self.ringThickness/2,
                                              center.y - ringRadius - self.ringThickness/2,
                                              (ringRadius + self.ringThickness/2) * 2,
                                              (ringRadius + self.ringThickness/2) * 2);
        self.progressLayer.bounds = self.progressLayer.frame;
        UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:self.progressLayer.position
                                                                    radius:ringRadius
                                                                startAngle:self.startAngle
                                                                  endAngle:self.endAngle
                                                                 clockwise:YES];
        
        
        self.progressLayer.path = smoothedPath.CGPath;
        self.progressLayer.lineWidth = self.ringThickness;
        
    }
    else
    {
        UIColor *  ringColor;
        if(self.limitTime)
            ringColor = self.value >= self.limitValue ? self.limitColor : self.defaultColor;
        else
            ringColor = self.defaultColor;
        [ringColor setStroke];
        
        CGFloat progress = self.maxValue ? (self.value - self.minValue)/(self.maxValue - self.minValue) : 0;
        UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                    radius:ringRadius
                                                                startAngle:-M_PI * 0.5
                                                                  endAngle:M_PI * 2 * progress - M_PI * 0.5
                                                                 clockwise:YES];
        
        
        
        smoothedPath.lineWidth = self.ringThickness;
        [smoothedPath stroke];
    }
    
}





#pragma mark - 属性



-(void)setOpposite:(BOOL)opposite
{
    _opposite = opposite;
    
    self.progressLayer.strokeEnd = opposite;
}

-(CAShapeLayer *)progressLayer
{
    if (!_progressLayer)
    {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.contentsScale = [[UIScreen mainScreen] scale];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = self.defaultColor.CGColor;
        _progressLayer.lineCap = kCALineJoinBevel;
        _progressLayer.lineJoin = kCALineJoinBevel;
        self.progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}

-(void)setCanClick:(BOOL)canClick
{
    _canClick = canClick;
    
    self.valueLabel.hidden = canClick;
    self.btn.hidden = !canClick;
}

-(void)setTotalTime:(NSInteger)totalTime
{
    if(!totalTime) return;
    _totalTime = totalTime;
    
    self.maxValue = totalTime * acceleration;
}

-(void)setLimitTime:(NSInteger)limitTime
{
    if(!limitTime) return;
    _limitTime = limitTime;
    
    self.limitValue = limitTime * acceleration;
}

-(void)setCurrentTime:(NSInteger)currentTime
{
//    if(!currentTime) return;
    if(currentTime > self.totalTime) return;
    
    _currentTime = currentTime;
    self.currentValue = currentTime * acceleration;
    
    
    [self startCounting];
    //    self.value = currentTime * acceleration;
}

-(NSTimer *)timer
{
    if(!_timer)
    {
        _timer = [NSTimer timerWithTimeInterval:timeDelta target:self selector:@selector(updateGaugeTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)stopTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)setValue:(CGFloat)value
{
    _value = MIN(value, _maxValue);
    _value = MAX(_value, _minValue);
    
    /*!
     *  Set text for value label
     */
    self.valueLabel.text = [NSString stringWithFormat:@"%0.f", fabs(_value / acceleration)];
    
    /*!
     *  Trigger the stoke animation of ring layer.
     */
    
    if(self.isAnimate)
        [self strokeGauge];
    else
        [self setNeedsDisplay];
}

- (void)setMinValue:(CGFloat)minValue
{
    if (_minValue != minValue && minValue < _maxValue) {
        _minValue = minValue;
        
        [self setNeedsDisplay];
    }
}

- (void)setMaxValue:(CGFloat)maxValue
{
    if (_maxValue != maxValue && maxValue > _minValue) {
        _maxValue = maxValue;
        
        
        [self setNeedsDisplay];
//        [self startCounting];
    }
}

- (void)setLimitValue:(CGFloat)limitValue
{
    if (_limitValue != limitValue && limitValue >= _minValue && limitValue <= _maxValue) {
        _limitValue = limitValue;
        
        [self setNeedsDisplay];
    }
}

- (void)setRingThickness:(CGFloat)ringThickness
{
    if (_ringThickness != ringThickness) {
        _ringThickness = ringThickness;
        
        [self setNeedsDisplay];
    }
}

- (void)setRingBackgroundColor:(UIColor *)ringBackgroundColor
{
    if (_ringBackgroundColor != ringBackgroundColor) {
        _ringBackgroundColor = ringBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

-(void)setRingCenterBackgroundColor:(UIColor *)ringCenterBackgroundColor
{
    if(_ringCenterBackgroundColor != ringCenterBackgroundColor)
    {
        _ringCenterBackgroundColor = ringCenterBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setValueFont:(UIFont *)valueFont
{
    if (_valueFont != valueFont) {
        _valueFont = valueFont;
        
        self.valueLabel.font = _valueFont;
        self.valueLabel.minimumScaleFactor = 10/_valueFont.pointSize;
    }
}

- (void)setValueTextColor:(UIColor *)valueTextColor
{
    if (_valueTextColor != valueTextColor) {
        _valueTextColor = valueTextColor;
        
        self.valueLabel.textColor = _valueTextColor;
    }
}


@end
