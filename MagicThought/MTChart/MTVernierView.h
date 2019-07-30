//
//  MTVernierView.h
//  WSLineChart
//
//  Created by monda on 2019/7/11.
//  Copyright © 2019 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLineChartViewConfig.h"

@interface MTVernierView : UIView

@property (nonatomic,weak) MTLineChartViewConfig* config;

@end

@interface VernierLineView : UIView

@property (nonatomic,weak) MTLineChartViewConfig* config;

@end
