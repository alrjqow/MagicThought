//
//  MTRoundView.m
//  MyTool
//
//  Created by 王奕聪 on 2017/6/24.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTRoundView.h"

#import "MTConst.h"
#import "Masonry.h"
#import "UIColor+ColorfulColor.h"



//动画会出现精度偏差，即不会准确升到1或者降到0，有0.00000001或更小的偏差均属正常范围
#define ProgressOffset 0.00000001



@interface MTRoundView ()

/**定时器控制进度*/
@property(nonatomic,strong) NSTimer* timer;

/**时间间隔*/
@property(nonatomic,assign) CGFloat timeInterval;

/**从进度开始已经过多少时间*/
@property(nonatomic,assign) CGFloat haveSpendTime;

/**计时器每次执行的速率*/
@property(nonatomic,assign) CGFloat speed;

/**加速度*/
@property(nonatomic,assign) CGFloat acceleration;

/**开始速度*/
@property(nonatomic,assign) CGFloat startSpeed;

/**当前进度*/
@property(nonatomic,assign) CGFloat currentProgress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

/**是否为正方向,规定顺时针为正方向*/
@property(nonatomic,assign) BOOL isPositiveDirection;






@end

@implementation MTRoundView

-(void)setProgressDefaultColor:(UIColor *)progressDefaultColor
{
    _progressDefaultColor = progressDefaultColor;
    
    self.progressLayer.strokeColor = progressDefaultColor.CGColor;
}

-(void)setRingThickness:(CGFloat)ringThickness
{
    _ringThickness = ringThickness;
    
    self.progressLayer.lineWidth = ringThickness;
}

-(void)setOpposite:(BOOL)opposite
{
    if(_opposite == opposite) return;
    
    //不是相反时，若进度已经为1，则设置无效，因为已完成
    if(!_opposite && self.currentProgress == 1) return;
    else if(_opposite && self.currentProgress == 0) return;
    
    _opposite = opposite;
}

-(void)setTargetProgress:(CGFloat)targetProgress
{
    if(targetProgress < 0 || targetProgress > 1) return;
    if(targetProgress == self.currentProgress) return;
    
    _targetProgress = targetProgress;
    [self adjustSpeedDirection];
    
    [self startRuning];
}

/**调整速度方向*/
-(void)adjustSpeedDirection
{
    if(_targetProgress < 0 || _targetProgress > 1) return;
    if(_targetProgress == _currentProgress) return;
    if(!self.speed) return;
    
    self.speed = (self.targetProgress > self.currentProgress ? 1 : -1) * fabs(self.speed);
    self.isPositiveDirection = self.speed >= 0;
}

-(void)setSpendTime:(CGFloat)spendTime
{
    if(spendTime <= 0) return;
    
    _spendTime = spendTime;
    
    
    if(self.speedType == MTRoundViewSpeedUniform)
    {
        //计算长度单位为1，时间为spendTime的速率，单位为 转/秒
        CGFloat r_s = 1 / spendTime;
        
        //计算定时器1秒执行多少次,单位为 次/秒
        CGFloat c_s = 1 / self.timeInterval;
        
        self.speed = r_s / c_s;
    }
    else if(self.speedType == MTRoundViewSpeedAcceleration)
    {
        //求加速度
        self.startSpeed = 0;
        self.acceleration = 2 / (spendTime * spendTime) * self.timeInterval;
    }
    else
    {
        self.startSpeed = 2 / spendTime * self.timeInterval;
        self.acceleration = -2 / (spendTime * spendTime) * self.timeInterval;
    }
    
    [self adjustSpeedDirection];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupMySelf];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupMySelf];
    }
    return self;
}


-(void)setupMySelf
{
//    self.opposite = YES;
//    self.speedType = MTRoundViewSpeedRetard;
    
    self.isAnimate = YES;
    self.isPositiveDirection = YES;
    
    self.ringColor = [UIColor colorWithR:200 G:200 B:200 A:0.6];
    self.ringBackgroundColor = [UIColor whiteColor];
    self.progressDefaultColor = [UIColor colorWithHex:0xfb035];
    
    _targetProgress = -1;
    
    self.ringThickness = 16;
    self.timeInterval = 0.01;
    self.spendTime = 2;
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.frame = self.bounds;
    


    CAShapeLayer *line = [CAShapeLayer layer];
    
    line.lineWidth = self.ringThickness ;
    line.strokeColor = self.progressDefaultColor.CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    
    
    [self.layer addSublayer:line];
    self.progressLayer = line;
    
//    [self startRuning];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

-(void)drawRect:(CGRect)rect
{
    CGFloat ringThickness = self.ringThickness;
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat ringRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - ringThickness;

    //1. 先绘制外层圆环线条，不变
    [self.ringColor setStroke];
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                      radius:ringRadius
                                                                  startAngle:0
                                                                    endAngle:M_PI * 2
                                                                   clockwise:YES];
    ringPath.lineWidth = ringThickness;
    [ringPath stroke];
    
    
    
    //2. 再绘制圆环内背景颜色,不变
    [self.ringBackgroundColor setFill];
    
    UIBezierPath *ringBackgroundPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                              radius:ringRadius - ringThickness / 2
                                                                          startAngle:0
                                                                            endAngle:M_PI * 2
    
                                                                   clockwise:YES];
    [ringBackgroundPath fill];

    
    
    //3. 环形进度条，动态变化
    CGFloat offset = -M_PI_2;
    CGFloat startAngle = self.opposite ? M_PI * self.currentProgress * 2 + offset : offset;
    CGFloat endAngle = self.opposite ? M_PI * 2 + offset : M_PI * self.currentProgress * 2 + offset;
    
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:ringRadius
                                                            startAngle:startAngle
                                                              endAngle:endAngle
                                                             clockwise:YES];
    
    self.progressLayer.path = smoothedPath.CGPath;

}

-(void)startRuning
{
    if(!self.isAnimate) //如果不需要动画
    {
        [self stopTimer];
        
        CGFloat targetProgress = self.targetProgress != -1 ? self.targetProgress : 1;
        self.currentProgress = targetProgress;
        [self setNeedsDisplay];
        
        //结束后，通知代理做某事
        if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
            [self.mt_delegate doSomeThingForMe:self withOrder:MTRoundViewFinishRunningOrder];
        
        return;
    }
    
    if(self.spendTime)
    {
        [self stopTimer];
        
//        NSLog(@"%@",[NSDate date]);
        [self timer];
    }
}

- (void)runing:(NSTimer *)timer
{
    if(self.speedType != MTRoundViewSpeedUniform)
    {
        self.haveSpendTime += self.timeInterval;
        CGFloat speed = self.startSpeed + self.acceleration * self.haveSpendTime;
        
        if(speed > 0.001)
            self.speed = speed;
    }
    
    self.currentProgress += self.speed;
    
    CGFloat targetProgress = self.targetProgress != -1 ? self.targetProgress : 1;
    
    BOOL isEnd = self.isPositiveDirection ? self.currentProgress >= targetProgress : self.currentProgress <= targetProgress;
    
    if (isEnd) {

        self.currentProgress = targetProgress;
        
        
        if(self.isPositiveDirection && (fabs(self.currentProgress - 1) < ProgressOffset)) self.currentProgress = 1;
        else if(!self.isPositiveDirection && (self.currentProgress < ProgressOffset)) self.currentProgress = 0;
        
        _targetProgress = -1;
        
        
//        NSLog(@"%@",[NSDate date]);
        [self stopTimer];
        
        //动画结束后，通知代理做某事
        if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
            [self.mt_delegate doSomeThingForMe:self withOrder:MTRoundViewFinishRunningOrder];
    }
   
    
    [self setNeedsDisplay];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self testDemo];
}

-(NSTimer *)timer
{
    if(!_timer)
    {
        _timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(runing:) userInfo:nil repeats:YES];
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


//测试用例
-(void)testDemo
{
    static BOOL direction = false;
    CGFloat targetProgress = 0;
    
    if(direction)
    {
        targetProgress = self.targetProgress == -1 ? self.currentProgress : self.targetProgress;
        targetProgress += 0.1;
        
        if(fabs(targetProgress - 1) < 0.0001)
        {
            targetProgress = 1;
            direction = false;
        }
        self.targetProgress = targetProgress;
    }
    else
    {
        targetProgress = self.targetProgress == -1 ? self.currentProgress : self.targetProgress;
        targetProgress -= 0.1;
        
        if(targetProgress < 0.0001)
        {
            targetProgress = 0;
            direction = true;
        }
        self.targetProgress = targetProgress;
    }
}

@end
