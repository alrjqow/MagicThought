//
//  MTDelegateView.m
//  8kqw
//
//  Created by 王奕聪 on 2016/12/24.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateView.h"

@implementation MTDelegateView


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupDefault];
    }
    
    return self;
}

-(void)setupDefault
{
    
}

-(void)loadData{}

/**拿一些东西*/
-(NSDictionary*)giveSomeThingToYou
{
    return @{};
}

/**拿一些东西给我做什么*/
-(void)giveSomeThingToMe:(id)obj WithOrder:(NSString*)order
{
    
}


@end



