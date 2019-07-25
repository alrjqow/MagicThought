//
//  UIColor+ColorfulColor.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorfulColor)

+(UIColor*)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;
+(UIColor*)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

+(UIColor*)colorWithHex:(NSUInteger)hex;
+(UIColor*)colorWithHex:(NSUInteger)hex WithAlpha:(CGFloat)a;


@end


@interface UIView (ColorfulColor)



/**默认线性角度为中线*/
-(void)createJianBianBackgroundColorWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor;

/**自行调整线性角度*/
-(void)createJianBianBackgroundColorWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**生成渐变图片,默认线性角度为中线*/
-(UIImage*)createJianBianImageWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**生成渐变图片,自行调整线性角度*/
-(UIImage*)createJianBianImageWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor;

@end
