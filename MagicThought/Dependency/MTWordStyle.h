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
    MTVerticalAlignmentMiddle = 0, // default
    MTVerticalAlignmentTop,
    MTVerticalAlignmentBottom,
} MTVerticalAlignment;

@class MTWordStyle;

typedef MTWordStyle* (^Bold)(BOOL bold);
typedef MTWordStyle* (^Thin)(BOOL thin);
typedef MTWordStyle* (^VerticalAlignment)(MTVerticalAlignment verticalAlignment);
typedef MTWordStyle* (^HorizontalAlignment)(NSTextAlignment horizontalAlignment);
typedef MTWordStyle* (^LineSpacing)(CGFloat lineSpacing);

@interface MTWordStyle : NSObject

@property(nonatomic,assign) CGFloat wordSize;
@property(nonatomic,strong) NSString* wordName;
@property(nonatomic,strong) UIColor* wordColor;
@property(nonatomic,strong) NSAttributedString *attributedWordName;

@property(nonatomic,assign) MTVerticalAlignment wordVerticalAlignment;
@property(nonatomic,assign) NSTextAlignment  wordHorizontalAlignment;

@property (nonatomic,assign) BOOL wordThin;
@property (nonatomic,assign) BOOL wordBold;

@property(nonatomic,assign) CGFloat wordLineSpacing;


@property (nonatomic,copy,readonly)  LineSpacing lineSpacing;
@property (nonatomic,copy,readonly)  VerticalAlignment verticalAlignment;
@property (nonatomic,copy,readonly)  HorizontalAlignment horizontalAlignment;
@property (nonatomic,copy,readonly)  Bold bold;
@property (nonatomic,copy,readonly)  Thin thin;

@end


CG_EXTERN MTWordStyle* mt_WordStyleMake(CGFloat wordSize, NSString* wordName,UIColor* wordColor);
CG_EXTERN MTWordStyle* mt_AttributedWordStyleMake(CGFloat wordSize, NSAttributedString* attributedWordName,UIColor* wordColor);

