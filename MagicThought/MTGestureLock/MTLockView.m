//
//  MTLockView.m
//  手势解锁
//
//  Created by monda on 2018/3/19.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTLockView.h"
#import "MTLockNode.h"
#import "MTLockViewConfig.h"
#import "MTConst.h"

@interface MTLockView()

/**选中的圆的集合*/
@property (nonatomic, strong) NSMutableArray *circleSet;

/**当前点*/
@property (nonatomic, assign) CGPoint currentPoint;

// 数组清空标志
@property (nonatomic, assign) BOOL hasClean;

@end

@implementation MTLockView

-(void)setModel:(MTLockViewConfig *)model
{
    _model = model;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        if(![subview isKindOfClass:[MTLockNode class]]) return;
        
        MTLockNode* circle = (MTLockNode*)subview;
        circle.model = model;
    }];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupDefault];
    }
    
    return self;
}


#pragma mark - 解锁视图准备
/*
 *  解锁视图准备
 */
-(void)setupDefault
{
    for (NSUInteger i=0; i<9; i++)
    {
        MTLockNode *circle = [MTLockNode new];
        // 设置tag -> 密码记录的单元
        circle.tag = i + 1;
        [self addSubview:circle];
    }
    
    self.model = [MTLockViewConfig new];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - self.model.edgeMargin * 2, [UIScreen mainScreen].bounds.size.width - self.model.edgeMargin * 2);
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height * 3/5);
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat itemViewWH = self.model.circleRadius * 2;
    CGFloat marginValue = (self.frame.size.width - 3 * itemViewWH) / 3.0f;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        NSUInteger row = idx % 3;
        
        NSUInteger col = idx / 3;
        
        CGFloat x = marginValue * row + row * itemViewWH + marginValue/2;
        
        CGFloat y = marginValue * col + col * itemViewWH + marginValue/2;
        
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        
        subview.frame = frame;
    }];
}



#pragma mark - touch began - moved - end
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self gestureEndResetMembers];
    
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.subviews enumerateObjectsUsingBlock:^(MTLockNode *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            circle.circleState = MTLockNodeStateSelected;
            
            [self.circleSet addObject:circle];
        }
    }];
    
    
    [self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.subviews enumerateObjectsUsingBlock:^(MTLockNode *circle, NSUInteger idx, BOOL *stop) {

        if (CGRectContainsPoint(circle.frame, point)) {
            if ([self.circleSet containsObject:circle]) {

            } else {
                [self.circleSet addObject:circle];
    
                // move过程中的连线（包含跳跃连线的处理）
                [self calAngleAndconnectTheJumpedCircle];
                
            }
        } else {

            self.currentPoint = point;
        }
    }];
    
    
    [self.circleSet enumerateObjectsUsingBlock:^(MTLockNode *circle, NSUInteger idx, BOOL *stop) {

        circle.circleState = MTLockNodeStateSelected;
    }];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHasClean:NO];
    
    NSString *gesture = [self getGestureResultFromCircleSet:self.circleSet];
    CGFloat length = [gesture length];
    
    if (length == 0) return;
    
    // 手势结束后是否错误回显重绘，取决于是否延时清空数组和状态复原
    [self errorToDisplay];

}

#pragma mark - 是否错误回显重绘
/**
 *  是否错误回显重绘
 */
- (void)errorToDisplay
{
    if ([self getCircleState] == MTLockNodeStateError) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self gestureEndResetMembers];
            
        });
        
    } else {
        
        [self gestureEndResetMembers];
    }
}

- (MTLockNodeState)getCircleState
{
    return [(MTLockNode *)[self.circleSet firstObject] circleState];
}

- (void)gestureEndResetMembers
{
    @synchronized(self) { // 保证线程安全
        if (!self.hasClean) {
            
            // 手势完毕，选中的圆回归普通状态
            [self changeCircleInCircleSetWithState:MTLockNodeStateNormal];
            
            // 清空数组
            [self.circleSet removeAllObjects];
            
            // 清空方向
            [self resetAllCirclesDirect];
            
            // 完成之后改变clean的状态
            [self setHasClean:YES];
        }
    }
}

#pragma mark - 清空所有子控件的方向
- (void)resetAllCirclesDirect
{
    [self.subviews enumerateObjectsUsingBlock:^(MTLockNode *obj, NSUInteger idx, BOOL *stop) {
        [obj setAngle:0];
    }];
}

#pragma mark - 改变选中数组CircleSet子控件状态
- (void)changeCircleInCircleSetWithState:(MTLockNodeState)state
{
    [self.circleSet enumerateObjectsUsingBlock:^(MTLockNode *circle, NSUInteger idx, BOOL *stop) {
        
        circle.circleState = state;
        
        // 如果是错误状态，那就将最后一个按钮特殊处理
//        if (state == CircleStateError) {
//            if (idx == self.circleSet.count - 1) {
//                [circle setState:CircleStateLastOneError];
//            }
//        }
        
    }];
    
    [self setNeedsDisplay];
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    // 如果没有任何选中按钮， 直接retrun
    if (self.circleSet == nil || self.circleSet.count == 0) return;
    
    UIColor *color;
    if ([self getCircleState] == MTLockNodeStateError) {
        color = self.model.errorLineColor;
    } else {
        color = self.model.normalLineColor;
    }
    
    [self connectCirclesInRect:rect lineColor:color];
}

#pragma mark - 连线绘制图案(以设定颜色绘制)
/**
 *  将选中的圆形以color颜色链接起来
 *
 *  @param rect  图形上下文
 *  @param color 连线颜色
 */

- (void)connectCirclesInRect:(CGRect)rect lineColor:(UIColor *)color
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加路径
    CGContextAddRect(ctx, rect);
    
    //是否剪裁
    [self clipSubviewsWhenConnectInContext:ctx clip:false];
    
    //剪裁上下文
    CGContextEOClip(ctx);
    
    // 遍历数组中的circle
    for (int index = 0; index < self.circleSet.count; index++) {
        
        // 取出选中按钮
        MTLockNode *circle = self.circleSet[index];
        
        if (index == 0) { // 起点按钮
            CGContextMoveToPoint(ctx, circle.center.x, circle.center.y);
        }else{
            CGContextAddLineToPoint(ctx, circle.center.x, circle.center.y); // 全部是连线
        }
    }
    
    // 连接最后一个按钮到手指当前触摸得点
    if (CGPointEqualToPoint(self.currentPoint, CGPointZero) == NO) {
        
        [self.subviews enumerateObjectsUsingBlock:^(MTLockNode *circle, NSUInteger idx, BOOL *stop) {
            
            if ([self getCircleState] == MTLockNodeStateError) {
                // 如果是错误的状态下不连接到当前点
                
            } else {
                
                CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
                
            }
        }];
    }
    
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    // 设置绘图的属性
    CGContextSetLineWidth(ctx, self.model.circleConnectLineWidth);
    
    // 线条颜色
    [color set];
    
    //渲染路径
    CGContextStrokePath(ctx);
}

#pragma mark - 是否剪裁
/**
 *  是否剪裁子控件
 *
 *  @param ctx  图形上下文
 *  @param clip 是否剪裁
 */
- (void)clipSubviewsWhenConnectInContext:(CGContextRef)ctx clip:(BOOL)clip
{
    if (clip) {
        
        // 遍历所有子控件
        [self.subviews enumerateObjectsUsingBlock:^(MTLockNode *circle, NSUInteger idx, BOOL *stop) {
            
            CGContextAddEllipseInRect(ctx, circle.frame); // 确定"剪裁"的形状
        }];
    }
}


#pragma mark - 将circleSet数组解析遍历，拼手势密码字符串
- (NSString *)getGestureResultFromCircleSet:(NSMutableArray *)circleSet
{
    NSMutableString *gesture = [NSMutableString string];
    
    for (MTLockNode *circle in circleSet) {
        // 遍历取tag拼字符串
        [gesture appendFormat:@"%@", @(circle.tag)];
//        NSLog(@"%@",gesture);
    }
    
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
        [self.mt_delegate doSomeThingForMe:self withOrder:MTLockViewAfterGetGestureResultOrder withItem:[gesture copy]];
    
    return gesture;
}

#pragma mark - 每添加一个圆，就计算一次方向
-(void)calAngleAndconnectTheJumpedCircle{
    
    if(self.circleSet == nil || [self.circleSet count] <= 1) return;
    
    //取出最后一个对象
    MTLockNode *lastOne = [self.circleSet lastObject];
    
    //倒数第二个
    MTLockNode *lastTwo = [self.circleSet objectAtIndex:(self.circleSet.count -2)];
    
    //计算倒数第二个的位置
    CGFloat last_1_x = lastOne.center.x;
    CGFloat last_1_y = lastOne.center.y;
    CGFloat last_2_x = lastTwo.center.x;
    CGFloat last_2_y = lastTwo.center.y;
    
    // 1.计算角度（反正切函数）
    CGFloat angle = atan2(last_1_y - last_2_y, last_1_x - last_2_x) + M_PI_2;
    [lastTwo setAngle:angle];
    
    // 2.处理跳跃连线
//    CGPoint center = [self centerPointWithPointOne:lastOne.center pointTwo:lastTwo.center];
//
//    MTLockNode *centerCircle = [self enumCircleSetToFindWhichSubviewContainTheCenterPoint:center];
//
//    if (centerCircle != nil) {
//
//        // 把跳过的圆加到数组中，它的位置是倒数第二个
//        if (![self.circleSet containsObject:centerCircle]) {
//            [self.circleSet insertObject:centerCircle atIndex:self.circleSet.count - 1];
//        }
//    }
}


#pragma mark - 提供两个点，返回一个它们的中点
- (CGPoint)centerPointWithPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo
{
    CGFloat x1 = fmax(pointOne.x, pointTwo.x);
    CGFloat x2 = fmin(pointOne.x, pointTwo.x);
    CGFloat y1 = fmax(pointOne.y, pointTwo.y);
    CGFloat y2 = fmin(pointOne.y, pointTwo.y);
    
    return CGPointMake((x1+x2)/2, (y1 + y2)/2);
}

#pragma mark - 给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
/**
 *  给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
 *
 *  @param point 当前点
 *
 *  @return 点所在的圆
 */
- (MTLockNode *)enumCircleSetToFindWhichSubviewContainTheCenterPoint:(CGPoint)point
{
    MTLockNode *centerCircle;
    for (MTLockNode *circle in self.subviews) {
        if (CGRectContainsPoint(circle.frame, point)) {
            centerCircle = circle;
        }
    }
    
    if (![self.circleSet containsObject:centerCircle]) {
        // 这个circle的角度和倒数第二个circle的角度一致
        centerCircle.angle = [[self.circleSet objectAtIndex:self.circleSet.count - 2] angle];
    }
    
    return centerCircle; // 注意：可能返回的是nil，就是当前点不在圆内
}

- (NSMutableArray *)circleSet
{
    if (_circleSet == nil) {
        _circleSet = [NSMutableArray array];
    }
    return _circleSet;
}

@end
