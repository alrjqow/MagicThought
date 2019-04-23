//
//  NSObject+API.m
//  BoringProject
//
//  Created by monda on 2018/7/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import "NSObject+API.h"
#import "MTBaseApi.h"
#import "MTBaseDataModel.h"
#import "MTCloud.h"
#import "NSString+Exist.h"

@implementation NSObject (API)


/**可在这个代理方法对需要的数据做过滤*/
-(MTBaseDataModel*)createBaseModelAfterSuccessFilterBy:(YTKBaseRequest *)request
{
    MTBaseDataModel* model = [MTBaseDataModel new];
    model.ipAddress = request.baseUrl;
    model.url = request.requestUrl;
    
    if(![request.responseObject isKindOfClass:[NSDictionary class]])
    {
        model.isResponseFail = YES;
        model.msg = @"未能识别的数据";
        model.failData = request.responseObject;
        return model;
    }
    
    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(filterIsResponseFailBy:)])
        model.isResponseFail = [[MTCloud shareCloud].apiManager filterIsResponseFailBy:request.responseObject];
    
    model.msg = model.isResponseFail ? @"请求未成功" : @"请求成功";
    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(adjustResponseMsgBy:)])
    {
        NSString* msg = [[MTCloud shareCloud].apiManager adjustResponseMsgBy:request.responseObject];
        if([msg isExist])
            model.msg = msg;
    }
    
    if(model.isResponseFail)
        model.failData = request.responseObject;
    else
        model.data = request.responseObject;
    
    return model;
}

-(BOOL)whenGetYTKBaseRequest:(YTKBaseRequest *)request FailIdentifier:(NSString*)identifier
{
    MTBaseDataModel* model = [self createBaseModelAfterSuccessFilterBy:request];
    if([request isKindOfClass:[MTBaseApi class]])
        model.identifier = ((MTBaseApi*)request).identifier;
    
    if(model.isResponseFail)
    {
        if([identifier isExist])
        {
            model.ipAddress = nil;
            model.url = identifier;
        }
        [self whenRequestFail:model];
        return false;
    }

    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(adjustDataByUrl:sourceData:)])
    {
        NSDictionary* data = [[MTCloud shareCloud].apiManager adjustDataByUrl:model.url sourceData:model.data];
        if(data)
            model.data = data;
    }
    
    [self whenGetBaseModel:model];
    return YES;
}

/*-----------------------------------华丽分割线-----------------------------------*/

#pragma mark - YTKRequestDelegate代理

-(void)requestFinished:(YTKBaseRequest *)request
{
    [self whenGetYTKBaseRequest:request FailIdentifier:nil];
}

-(void)requestFailed:(YTKBaseRequest *)request
{
    MTBaseDataModel* model = [MTBaseDataModel new];
    if([request isKindOfClass:[MTBaseApi class]])
        model.identifier = ((MTBaseApi*)request).identifier;
    
    model.ipAddress = request.baseUrl;
    model.url = request.requestUrl;
    model.isRequestError = YES;
    model.failData = request;
    
    model.msg = request.error.code == -1009 ? @"暂无网络链接，请检查您的网络状态" : @"请求未成功，请检查网络连接";
    model.error = request.error;
    
    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(adjustErrorMsg)])
    {
        NSString* errorMsg = [[MTCloud shareCloud].apiManager adjustErrorMsg];
        if([errorMsg isExist])
            model.msg = errorMsg;
    }
    
    [self whenRequestFail:model];
}


#pragma mark - YTKBatchRequestDelegate代理
- (void)batchRequestFinished:(YTKBatchRequest *)batchRequest
{
    NSString* identifier = [batchRequest isKindOfClass:[MTBatchApi class]] ? ((MTBatchApi*)batchRequest).identifier : nil;
    
    for(YTKRequest* request in batchRequest.requestArray)
    {
        if(![self whenGetYTKBaseRequest:request FailIdentifier:identifier])
            return;
    }
    
    MTBaseDataModel* model = [MTBaseDataModel new];
    model.url = identifier;
    [self whenGetBaseModel:model];
}

- (void)batchRequestFailed:(YTKBatchRequest *)batchRequest
{
    MTBaseDataModel* model = [MTBaseDataModel new];
    
    YTKRequest* request = batchRequest.failedRequest;
    if([batchRequest isKindOfClass:[MTBatchApi class]])
        model.url = ((MTBatchApi*)batchRequest).identifier;
    model.isRequestError = YES;
    model.failData = request;
    
    model.msg = request.error.code == -1009 ? @"暂无网络链接，请检查您的网络状态" : @"请求未成功，请检查网络连接";
    model.error = request.error;
    
    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(adjustErrorMsg)])
    {
        NSString* errorMsg = [[MTCloud shareCloud].apiManager adjustErrorMsg];
        if([errorMsg isExist])
            model.msg = errorMsg;
    }
    
    [self whenRequestFail:model];
}

#pragma mark - MTApiProtocol代理

/**可在这个代理方法对需要的数据做处理*/
-(void)whenRequestFail:(MTBaseDataModel *)model
{
    NSLog(@"请求链接：%@",model.ipAddress ? [model.ipAddress stringByAppendingString:model.url] : model.url);
    NSLog(@"请求失败,%@：%@",model.isResponseFail ? @"服务器返回数据不正确" : @"请求错误，可能是网络问题", model.msg);
    NSLog(@"%@",model.error);
    NSLog(@"%@",model.failData);
}

/**可在这个代理方法对需要的数据做处理*/
-(void)whenGetBaseModel:(MTBaseDataModel *)model
{
    if([model.identifier isEqualToString:@"MTTenScrollIdentifier"])
        return;
    NSLog(@"请求链接：%@",model.ipAddress ? [model.ipAddress stringByAppendingString:model.url] : model.url);
    NSLog(@"请求成功");
    NSLog(@"%@",model.data);
}


#pragma mark - 创建API

-(void)startWithApi:(NSString*)api postParameter:(NSDictionary*)parameter
{
    [[self createApi:api postParameter:parameter] start];
}


-(void)startWithApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block
{
    [[self createApi:api Identifier:identifier UpLoadBlock:block] start];
}

-(MTBaseApi*)createApi:(NSString*)api postParameter:(NSDictionary*)parameter
{
    MTBaseApi* baseApi;
    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(createApiWithUrl:)])
        baseApi = [[MTCloud shareCloud].apiManager createApiWithUrl:api];
    if(!baseApi)
        baseApi = [MTBaseApi new];
    baseApi.url = api;
    if(parameter)
        [baseApi.postParameter setValuesForKeysWithDictionary:parameter];
    baseApi.delegate = self;
    
    return baseApi;
}

-(MTBaseApi*)createApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block
{
    MTBaseApi* baseApi;
    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(createApiWithUrl:)])
        baseApi = [[MTCloud shareCloud].apiManager createApiWithUrl:api];
    if(!baseApi)
        baseApi = [MTBaseApi new];
    
    baseApi.identifier = identifier;
    baseApi.url = api;
    baseApi.constructingBodyBlock = block;
    baseApi.delegate = self;
    
    return baseApi;
}
@end
