//
//  MTWordStyle.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/19.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentMiddle = 0, // default
    VerticalAlignmentTop,
    VerticalAlignmentBottom,
} VerticalAlignment;

@class MTWordStyle;

typedef MTWordStyle* (^Bold)(BOOL);
typedef MTWordStyle* (^Thin)(BOOL);

@interface MTWordStyle : NSObject

@property (nonatomic,assign) BOOL wordThin;
@property (nonatomic,assign) BOOL wordBold;

@property(nonatomic,assign) CGFloat wordSize;
@property(nonatomic,strong) NSString* wordName;
@property(nonatomic,strong) UIColor* wordColor;
@property(nonatomic,assign) NSUInteger wordColorValue;

@property(nonatomic,assign) VerticalAlignment verticalAlignment;
@property(nonatomic,assign) NSTextAlignment  horizontalAlignment;

@property (nonatomic,copy,readonly)  Bold bold;
@property (nonatomic,copy,readonly)  Thin thin;

@end

CG_EXTERN MTWordStyle* mt_WordStyleValueMake(CGFloat wordSize, NSString* wordName, NSUInteger wordColorValue);

CG_EXTERN MTWordStyle* mt_WordStyleMake(CGFloat wordSize, NSString* wordName,UIColor* wordColor);

CG_EXTERN MTWordStyle* mt_WordStyleAppend(MTWordStyle* style, VerticalAlignment verticalAlignment, NSTextAlignment  horizontalAlignment);
