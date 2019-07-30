//
//  MTLineChartView.h
//  WSLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLineChartViewConfig.h"


@interface MTLineChartView : UIView


- (id)initWithFrame:(CGRect)frame Config:(MTLineChartViewConfig*)config;

- (void)refreshWithXTitleArray:(NSArray*)xTitleArray YValueArray:(NSArray*)yValueArray;


@end
