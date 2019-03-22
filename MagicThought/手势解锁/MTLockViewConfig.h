//
//  MTLockViewConfig.h
//  手势解锁
//
//  Created by monda on 2018/3/19.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MTLockViewStateSetting , // 设置手势密码
   MTLockViewStateVerify       // 验证
    
}MTLockViewState;

@interface MTLockViewConfig : NSObject

/**lockView现在是何种状态？验证还是设置?*/
@property (nonatomic,assign) MTLockViewState state;

//**空心圆圆环宽度*/
@property (nonatomic,assign) CGFloat edgeWidth;

/**外层是否选择填充*/
@property (nonatomic,assign) BOOL isEdgeFill;

/**内部实心圆占空心圆的比例系数*/
@property (nonatomic,assign) CGFloat circleRadio;

/**三角形长度*/
@property (nonatomic,assign) CGFloat trangleLength;

/**是否有箭头*/
@property (nonatomic, assign) BOOL arrow;

/**正常线颜色*/
@property (nonatomic, strong) UIColor* normalLineColor;

/**错误线颜色*/
@property (nonatomic, strong) UIColor* errorLineColor;

/**连线宽度*/
@property (nonatomic,assign) CGFloat  circleConnectLineWidth;

/**单个圆的半径*/
@property (nonatomic,assign) CGFloat  circleRadius;

/**解锁视图边距*/
@property (nonatomic,assign) CGFloat  edgeMargin;

@property (nonatomic,strong) NSArray<UIColor*>* trangleColors;
@property (nonatomic,strong) NSArray<UIColor*>* inCircleColors;
@property (nonatomic,strong) NSArray<UIColor*>* outCircleColors;

-(void)setupDefault;

@end
