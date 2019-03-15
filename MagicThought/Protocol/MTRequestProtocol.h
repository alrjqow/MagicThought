//
//  MTRequestProtocol.h
//  8kqw
//
//  Created by 王奕聪 on 2017/7/25.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

@protocol MTRequestProtocol <NSObject>


@optional

/**调用请求成功方法前*/
-(BOOL)mt_beforeSuccessMethod:(NSURLSessionDataTask *_Nullable)task ResponseObject:(id _Nullable)responseObject URL:(NSString*_Nullable)url;

/**请求成功方法*/
-(BOOL)mt_requestSuccess:(NSURLSessionDataTask *_Nullable)task ResponseObject:(id _Nullable)responseObject URL:(NSString*_Nullable)url;

/**正在调用请求方法*/
-(void)mt_runningSuccessMethod:(NSURLSessionDataTask *_Nullable)task ResponseObject:(id _Nullable)responseObject URL:(NSString*_Nullable)url Identifier:(NSString*_Nullable)identifier;

/**调用请求成功方法后*/
-(void)mt_afterSuccessMethod:(NSURLSessionDataTask *_Nullable)task ResponseObject:(id _Nullable)responseObject URL:(NSString*_Nullable)url;


/**调用请求失败方法前*/
-(BOOL)mt_beforeRequestFailureMethod:(NSURLSessionDataTask * _Nullable)task Error:(NSError *_Nullable)error URL:(NSString*_Nullable)url;

/**调用失败方法*/
-(BOOL)mt_requestFailure:(NSURLSessionDataTask * _Nullable)task Error:(NSError *_Nullable)error URL:(NSString*_Nullable)url;

/**正在调用请求失败方法*/
-(void)mt_runningRequestFailureMethod:(NSURLSessionDataTask * _Nullable)task Error:(NSError *_Nullable)error URL:(NSString*_Nullable)url Identifier:(NSString*_Nullable)identifier;

/**调用请求失败方法后*/
-(void)mt_afterRequestFailureMethod:(NSURLSessionDataTask * _Nullable)task Error:(NSError *_Nullable)error URL:(NSString*_Nullable)url;



@end


