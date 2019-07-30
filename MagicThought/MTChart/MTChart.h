//
//  MTChart.h
//  MagicThought
//
//  Created by monda on 2019/7/30.
//  Copyright © 2019 monda. All rights reserved.
//


#import "MTLineChartView.h"
#import "MTLineChartViewConfig.h"
#import "MTLineChartContentView.h"
#import "MTVernierView.h"
#import "MTXAxisView.h"
#import "MTYAxisView.h"



/**
@interface ViewController ()

@property (nonatomic,strong) MTLineChartView* lineView;

@property (nonatomic,strong) MTLineChartViewConfig* config;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 15; i++) {
        
        //        [xArray addObject:[NSString stringWithFormat:@"%.1f",3+0.1*i]];
        [yArray addObject:[NSString stringWithFormat:@"%u",100 * arc4random_uniform(16)]];
        
    }
    yArray[0] = @"300";
    yArray[2] = @"600";
    yArray[14] = @"50.13";
    
    
    xArray[0] = @"03.18";
    xArray[1] = @"03.18";
    xArray[2] = @"03.18";
    xArray[3] = @"05.20";
    xArray[4] = @"03.18";
    
    xArray[5] = @"03.18";
    xArray[6] = @"03.18";
    xArray[7] = @"04.29";
    xArray[8] = @"05.20";
    xArray[9] = @"06.17";
    
    xArray[10] = @"03.18";
    xArray[11] = @"04.08";
    xArray[12] = @"04.29";
    xArray[13] = @"05.20";
    xArray[14] = @"06.17";
    
    
    MTLineChartViewConfig* config = [MTLineChartViewConfig new];
    config.xTitleArray = xArray;
    config.yValueArray = yArray;
    config.yMin = 0;
    config.yMax = 1500.12;
    self.config = config;
    
    MTLineChartView *wsLine = [[MTLineChartView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 500) Config:config];
    [self.view addSubview:wsLine];
    self.lineView = wsLine;
    
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"click" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 100);
    
    [self.view addSubview:btn];
}

-(void)click
{
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 15; i++) {
        
        //        [xArray addObject:[NSString stringWithFormat:@"%.1f",3+0.1*i]];
        [yArray addObject:[NSString stringWithFormat:@"%u",100 * arc4random_uniform(16)]];
        
    }
    yArray[0] = @"300";
    yArray[2] = @"600";
    yArray[14] = @"50";
    
    
    xArray[0] = @"03.03";
    xArray[1] = @"04.11";
    xArray[2] = @"04.24";
    xArray[3] = @"05.56";
    xArray[4] = @"06.62";
    
    xArray[5] = @"03.12";
    xArray[6] = @"04.77";
    xArray[7] = @"04.30";
    xArray[8] = @"05.47";
    xArray[9] = @"06.28";
    
    xArray[10] = @"03.36";
    xArray[11] = @"04.66";
    xArray[12] = @"04.27";
    xArray[13] = @"05.03";
    xArray[14] = @"05.38";
    
    
    //    __weak __typeof(self) weakSelf = self;
    self.config.detailMsg = ^(NSInteger currentIndex){
        
        return @"aslkdasd";
    };
    
    
    
    [self.lineView refreshWithXTitleArray:xArray YValueArray:yArray];
}




@end
**/
