//
//  MTDelegateProtocol.h
//  8kqw
//
//  Created by 王奕聪 on 2016/12/24.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTDelegateProtocol <NSObject>

@optional
-(void)doSomeThingForMe:(id)obj withOrder:(NSString*)order;
-(id)getSomeThingForMe:(id)obj withOrder:(NSString*)order;
-(void)doSomeThingForMe:(id)obj withOrder:(NSString*)order withItem:(id)item;
-(id)getSomeThingForMe:(id)obj withOrder:(NSString*)order withItem:(id)item;

@end



@protocol MTDelegateViewDataProtocol

@optional
-(NSArray*)dataList;

-(NSArray*)tenScrollDataList;

-(NSArray*)sectionList;

-(NSObject*)emptyData;

@end

@protocol MTExchangeDataProtocol

@optional

/**当接收到数据，请不要在此方法中调用 [super whenGetResponseObject]，可能会因为数据类型不对而报错，要调用 super 请使用 [self setSuperResponseObject]*/
-(void)whenGetResponseObject:(NSObject*)object;

/**拿一些东西*/
-(NSDictionary*)giveSomeThingToYou;

/**拿一些东西给我做什么*/
-(void)giveSomeThingToMe:(id)obj WithOrder:(NSString*)order;

/**接收数据的类型*/
-(Class)classOfResponseObject;

/**设置父类数据*/
-(void)setSuperResponseObject:(NSObject*)object;

@end


@protocol MTListDataProtocol <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@optional

- (NSArray*)newDataList:(NSArray*)dataList;

@end


@protocol MTViewModelProtocol<MTListDataProtocol, MTExchangeDataProtocol>


@end
