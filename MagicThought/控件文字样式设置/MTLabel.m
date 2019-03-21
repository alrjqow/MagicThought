//
//  MTLabel.m
//  8kqw
//
//  Created by 王奕聪 on 2017/5/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTLabel.h"

@implementation MTLabel


- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
//    if(UIEdgeInsetsEqualToEdgeInsets(self.inset, UIEdgeInsetsZero))
//    {
//        CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
//        [super drawTextInRect:actualRect];
//        return;
//    }
    
     return [super drawTextInRect:UIEdgeInsetsInsetRect(self.verticalAlignment == VerticalAlignmentMiddle ? requestedRect : actualRect, self.inset)];
}

@end
