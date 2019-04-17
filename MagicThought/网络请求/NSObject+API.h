//
//  NSObject+API.h
//  BoringProject
//
//  Created by monda on 2018/7/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MTApiProtocol.h"


@interface NSObject (API)<MTApiProtocol>

/**发起请求*/
-(void)startWithApi:(NSString*)api postParameter:(NSDictionary*)parameter;
/**发起上传数据请求*/
-(void)startWithApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block;

@end


