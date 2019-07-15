//
//  NSObject+API.h
//  BoringProject
//
//  Created by monda on 2018/7/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MTApiProtocol.h"

@class MTBaseApi;
@interface NSObject (API)<MTApiProtocol>

/**发起请求*/
-(void)startWithApi:(NSString*)api postParameter:(NSDictionary*)parameter;
-(void)startWithApi:(NSString*)api postParameter:(NSDictionary*)parameter ApiIdentifier:(NSString*)apiIdentifier;

/**发起上传数据请求*/
-(void)startWithApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block;
-(void)startWithApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block ApiIdentifier:(NSString*)apiIdentifier;

/**创建请求*/
-(MTBaseApi*)createApi:(NSString*)api postParameter:(NSDictionary*)parameter;
-(MTBaseApi*)createApi:(NSString*)api postParameter:(NSDictionary*)parameter ApiIdentifier:(NSString*)apiIdentifier;

/**创建上传数据请求*/
-(MTBaseApi*)createApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block;
-(MTBaseApi*)createApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block ApiIdentifier:(NSString*)apiIdentifier;


@end


