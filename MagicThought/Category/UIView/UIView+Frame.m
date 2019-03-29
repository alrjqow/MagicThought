//
//  UIView+Frame.m
//  BuDeJie
//
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)



+ (instancetype)viewFromXib
{    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;

}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;

}

- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}


- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin
{
    return self.frame.origin;
}


-(CGFloat)halfWidth
{
    return self.frame.size.width * 0.5;
}

-(void)setHalfWidth:(CGFloat)halfWidth
{
    self.width = halfWidth * 2;
}

-(CGFloat)halfHeight
{
    return self.frame.size.height * 0.5;
}

-(void)setHalfHeight:(CGFloat)halfHeight
{
    self.height = halfHeight * 2;
}

-(CGFloat)midX
{
    return CGRectGetMidX(self.frame);
}

-(void)setMidX:(CGFloat)midX
{
    self.x = midX - self.halfWidth;
}

-(CGFloat)midY
{
    return CGRectGetMidY(self.frame);
}

-(void)setMidY:(CGFloat)midY
{
    self.y = midY - self.halfHeight;
}

-(CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

-(void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.frame.size.width;
}

-(CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

-(void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.frame.size.height;
}

@end


@implementation UIScrollView (ContentOffset)


-(CGFloat)offsetX
{
    return self.contentOffset.x;
}

-(void)setOffsetX:(CGFloat)offsetX
{
    CGPoint contentOffset = self.contentOffset;
    self.contentOffset = CGPointMake(offsetX, contentOffset.y);
}

-(CGFloat)offsetY
{
    return self.contentOffset.y;
}

-(void)setOffsetY:(CGFloat)offsetY
{
    CGPoint contentOffset = self.contentOffset;
    self.contentOffset = CGPointMake(contentOffset.x, offsetY);
}

@end

@implementation UIView (IsScrolling)

- (BOOL)isRolling{
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        
        if (scrollView.dragging || scrollView.decelerating) return YES;// 如果UIPickerView正在拖拽或者是正在减速，返回YES
        
    }
    
    for (UIView *subView in self.subviews) {
        if ([subView isRolling]) {
            return YES;
        }
    }
    return NO;
    
}


@end
