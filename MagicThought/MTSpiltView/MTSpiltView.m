//
//  MTSpiltView.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/21.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTSpiltView.h"
#import "UIView+Circle.h"
#import "Masonry.h"
#import "MTConst.h"

NSString*  MTSpiltViewPanEndOrder = @"MTSpiltViewPanEndOrder";
@interface MTSpiltView ()

@property(nonatomic,weak) UIView* line;
@property(nonatomic,weak) UIView* lineBtn;

@property (strong, nonatomic)  NSLayoutConstraint *centerX;
@property (strong, nonatomic)  NSLayoutConstraint *centerY;

@end

@implementation MTSpiltView

-(void)setCircleToCenter:(CGFloat)circleToCenter
{
    if(circleToCenter  < -mt_ScreenH() * 0.375)
        self.centerY.constant = -mt_ScreenH() * 0.375;
    else if(circleToCenter  > mt_ScreenH() * 0.375)
        self.centerY.constant = mt_ScreenH() * 0.375;
    else
        self.centerY.constant = circleToCenter;
}

-(void)setLineBtnStyle:(MTBorderStyle *)lineBtnStyle
{
    lineBtnStyle.borderRadius = 15;
    [self.lineBtn becomeCircleWithBorder:lineBtnStyle];
}

-(void)setSpiltLineColor:(UIColor *)spiltLineColor
{
    self.line.backgroundColor = spiltLineColor;
}

-(void)defaultCenter
{
    _centerToRight = _centerToLeft = 0;
}

-(void)setCenterToLeft:(CGFloat)centerToLeft
{
    if(centerToLeft < mt_ScreenW() * 0.125 || centerToLeft > mt_ScreenW() * 0.5) return;
    _centerToRight = 0;
    
    _centerToLeft = centerToLeft - mt_ScreenW() * 0.5;
    self.centerX.constant = _centerToLeft;
}

-(void)setCenterToRight:(CGFloat)centerToRight
{
    if(centerToRight < mt_ScreenW() * 0.125 || centerToRight > mt_ScreenW() * 0.5) return;
    
    _centerToLeft = 0;
    _centerToRight = mt_ScreenW() * 0.5 - centerToRight;
    self.centerX.constant = _centerToRight;
}

+(instancetype _Nullable )spiltViewWithLeftView:( UIView* _Nonnull )leftView AndRightView:(UIView* _Nonnull)rightView
{
    return [[MTSpiltView alloc]initWithLeftView:leftView AndRightView:rightView];
}

-(instancetype _Nullable )initWithLeftView:( UIView* _Nonnull )leftView AndRightView:(UIView* _Nonnull)rightView
{
    if(self = [super init])
    {
        if((!leftView && rightView) || (leftView && !rightView))
        {
            UIView* view = leftView ? leftView : rightView;
            [self addSubview:view];
            
            __weak typeof (self) weakSelf = self;
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(weakSelf);
            }];
        }
   
        [self setupSubView:leftView Right:rightView];
    }
    
    return self;
}

-(void)setupSubView:(UIView*)left Right:(UIView*)right
{
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor blackColor];
    
    UIView* lineBtn = [UIView new];
    lineBtn.translatesAutoresizingMaskIntoConstraints = false;
    lineBtn.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:left];
    [self addSubview:right];
    [self addSubview:line];
    [self addSubview:lineBtn];
    
    __weak typeof (self) weakSelf = self;
    
    self.centerX = [NSLayoutConstraint constraintWithItem:lineBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    self.centerY = [NSLayoutConstraint constraintWithItem:lineBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:lineBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:30],
                           [NSLayoutConstraint constraintWithItem:lineBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30],
                           self.centerX,self.centerY
                           ]];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@1);
        make.top.and.bottom.equalTo(weakSelf);
        make.centerX.equalTo(lineBtn.mas_centerX);
    }];
    
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.and.bottom.equalTo(weakSelf);
        make.right.equalTo(line.mas_left);
    }];
    
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.right.and.bottom.equalTo(weakSelf);
        make.left.equalTo(line.mas_right);
    }];
    
    [lineBtn becomeCircleWithBorder:mt_BorderStyleMake(1, 15, [UIColor blackColor])];
    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [lineBtn addGestureRecognizer:pan];
    [lineBtn addGestureRecognizer:tap];
    self.lineBtn = lineBtn;
    self.line = line;
}


- (void)pan:(UIPanGestureRecognizer*) recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:self];
        
        self.centerX.constant += translation.x;
        self.centerY.constant += translation.y;
        
        
        [UIView animateWithDuration:0.1f animations:^{
            
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
        [recognizer setTranslation:CGPointZero inView:self];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if(self.centerX.constant < -(mt_ScreenW() * 0.375))
        {
            self.centerX.constant = -mt_ScreenW() * 0.5;
        }
        else if(self.centerX.constant > mt_ScreenW() * 0.375)
        {
            self.centerX.constant = mt_ScreenW() * 0.5;
        }
        
        if(self.centerY.constant < -mt_ScreenH() * 0.375)
        {
            self.centerY.constant = -mt_ScreenH() * 0.375;
        }
        else if(self.centerY.constant > mt_ScreenH() * 0.375)
        {
            self.centerY.constant = mt_ScreenH() * 0.375;
        }
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.25f animations:^{
            
            [weakSelf layoutIfNeeded];
        } completion:^(BOOL finished) {
                       
            if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
               [self.mt_delegate doSomeThingForMe:self withOrder:MTSpiltViewPanEndOrder withItem:[NSValue valueWithCGPoint:weakSelf.lineBtn.center]];
        }];
    }
}

-(void)tap:(UITapGestureRecognizer*)tap
{    
    self.centerX.constant = self.centerToLeft ? self.centerToLeft : self.centerToRight;//这个复位值可以自行定义
    
    [UIView animateWithDuration:0.25f animations:^{
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        __weak typeof (self) weakSelf = self;
        if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
            [self.mt_delegate doSomeThingForMe:self withOrder:MTSpiltViewPanEndOrder withItem:[NSValue valueWithCGPoint:weakSelf.lineBtn.center]];
    }];
}


@end
