//
//  MTDelegateView.h
//  8kqw
//
//  Created by 王奕聪 on 2016/12/24.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"


@interface MTDelegateView : UIView

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

-(void)setupDefault;

/**拿一些东西*/
-(NSDictionary*)giveSomeThingToYou;

/**拿一些东西给我做什么*/
-(void)giveSomeThingToMe:(id)obj WithOrder:(NSString*)order;

-(void)loadData;

@end



