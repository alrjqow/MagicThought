//
//  MTDelegateProtocol.h
//  8kqw
//
//  Created by 王奕聪 on 2016/12/24.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

@protocol MTDelegateProtocol <NSObject>

@optional
-(void)doSomeThingForMe:(id)obj withOrder:(NSString*)order;
-(id)getSomeThingForMe:(id)obj withOrder:(NSString*)order;
-(void)doSomeThingForMe:(id)obj withOrder:(NSString*)order withItem:(id)item;
-(id)getSomeThingForMe:(id)obj withOrder:(NSString*)order withItem:(id)item;

@end



