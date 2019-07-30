//
//  MTBorderStyle.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/9.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBorderStyle : NSObject

@property(nonatomic,assign) CGFloat borderWidth;
@property(nonatomic,assign) CGFloat borderRadius;
@property(nonatomic,strong) UIColor* borderColor;

@property(nonatomic,assign) CGRect borderRect;
@property(nonatomic,strong) UIColor* fillColor;

/**虚线*/
@property (nonatomic,assign) BOOL isWeak;

@end

CG_EXTERN MTBorderStyle* mt_BorderStyleMake(CGFloat borderWidth, CGFloat borderRadius,UIColor* borderColor);

CG_EXTERN MTBorderStyle* mt_BorderStyleAppend(MTBorderStyle* style, CGRect borderRect,UIColor* fillColor);
