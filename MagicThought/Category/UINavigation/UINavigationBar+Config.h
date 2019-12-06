//
//  UINavigationBar+Config.h
//  test
//
//  Created by monda on 2018/3/29.
//  Copyright © 2018年 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Config)


/**设置背景透明度,局部的*/
@property (nonatomic,assign) CGFloat backgroundAlpha;

/**设置是否全局透明*/
@property (nonatomic,assign) BOOL globalAlpha;

/**无视translucent设置颜色，若传nil,则根据translucent显示*/
@property (nonatomic,strong) UIColor* ignoreTranslucentBarTintColor;

/**底部的线*/
@property (nonatomic,strong,readonly) UIView* bottomLine;

/**更新标题颜色*/
- (void)updateForTitleColor:(UIColor *)titleColor;

@end






