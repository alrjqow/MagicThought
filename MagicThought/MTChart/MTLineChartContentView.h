//
//  LineChartView.h
//  WSLineChart
//
//  Created by monda on 2019/7/5.
//  Copyright © 2019 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTLineChartViewConfig.h"


@interface MTLineChartContentView : UIView

@property (nonatomic,weak) MTLineChartViewConfig* config;

@property (assign, nonatomic) CGPoint screenLoc; //相对于屏幕位置



@end
