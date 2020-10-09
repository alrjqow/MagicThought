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
#import "MTApiProtocol.h"
#import "MTCloud.h"
#import "NSString+Exist.h"

@implementation NSObject (API)

/**当接收的为Json数据时*/
-(void)adjustJsonModel:(MTBaseDataModel*)model AfterSuccessFilterBy:(YTKBaseRequest *)request
{
    if(![request.responseObject isKindOfClass:[NSDictionary class]])
    {
        model.isResponseFail = YES;
        model.msg = @"未能识别的数据";
        model.failData = request.responseObject;
        return;
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
}

/**当接收的为HTTP数据时*/
-(void)adjustHttpModel:(MTBaseDataModel*)model AfterSuccessFilterBy:(YTKBaseRequest *)request
{
    model.msg = @"请求成功";
    model.data = request.responseObject;
}

/**当接收的为XML数据时*/
-(void)adjustXmlModel:(MTBaseDataModel*)model AfterSuccessFilterBy:(YTKBaseRequest *)request
{
    model.msg = @"请求成功";
    model.data = request.responseObject;
}

/**可在这个代理方法对需要的数据做过滤*/
-(MTBaseDataModel*)createBaseModelAfterSuccessFilterBy:(YTKBaseRequest *)request
{
    MTBaseDataModel* model = [MTBaseDataModel new];
    model.ipAddress = request.baseUrl;
    model.url = request.requestUrl;
    model.responseSerializerType = request.responseSerializerType;
    
    switch (request.responseSerializerType) {
        case YTKResponseSerializerTypeHTTP:
        {
            [self adjustHttpModel:model AfterSuccessFilterBy:request];
            break;
        }
        case YTKResponseSerializerTypeJSON:
        {
            [self adjustJsonModel:model AfterSuccessFilterBy:request];
            break;
        }
        case YTKResponseSerializerTypeXMLParser:
        {
            [self adjustXmlModel:model AfterSuccessFilterBy:request];
            break;
        }
            
        default:
            break;
    }
    
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
        [self showFailLog:model];
        [self whenRequestFail:model];
        return false;
    }
    
    if([[MTCloud shareCloud].apiManager respondsToSelector:@selector(adjustDataByUrl:sourceData:)])
    {
        NSDictionary* data = [[MTCloud shareCloud].apiManager adjustDataByUrl:model.url sourceData:model.data];
        if(data)
            model.data = data;
    }
    
    [self showSuccessLog:model];
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
    
    [self showFailLog:model];
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
    [self showSuccessLog:model];
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
    
    [self showFailLog:model];
    [self whenRequestFail:model];
}

#pragma mark - MTApiProtocol代理

/**可在这个代理方法对需要的数据做处理*/
-(void)whenRequestFail:(MTBaseDataModel *)model{}

-(void)showFailLog:(MTBaseDataModel *)model
{
    NSLog(@"请求链接：%@",model.ipAddress ? [model.ipAddress stringByAppendingString:model.url] : model.url);
    NSLog(@"请求失败,%@：%@",model.isResponseFail ? @"服务器返回数据不正确" : @"请求错误，可能是网络问题", model.msg);
    NSLog(@"%@",model.error);
    NSLog(@"%@",model.failData);
}

/**可在这个代理方法对需要的数据做处理*/
-(void)whenGetBaseModel:(MTBaseDataModel *)model{}

-(void)showSuccessLog:(MTBaseDataModel *)model
{
    if([model.identifier isEqualToString:@"MDTenScrollIdentifier"])
        return;
    NSLog(@"请求链接：%@",model.ipAddress ? [model.ipAddress stringByAppendingString:model.url] : model.url);
    NSLog(@"请求成功");
    
    if([self isShowSuccessLog:model])
        NSLog(@"%@",model.data);
}

-(BOOL)isShowSuccessLog:(MTBaseDataModel *)model
{
    return YES;
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

/**创建请求*/
-(MTBaseApi*)createApi:(NSString*)api postParameter:(NSDictionary*)parameter
{
    MTBaseApi* baseApi = [self createApi:api];
    baseApi.url = api;
    if(parameter)
        [baseApi.postParameter setValuesForKeysWithDictionary:parameter];
    baseApi.delegate = self;
    
    return baseApi;
}

-(MTBaseApi*)createApi:(NSString*)api
{
    if(![[MTCloud shareCloud].apiManager respondsToSelector:@selector(apiRequestList)])
        return [MTBaseApi new];
                
    NSDictionary<NSString*,  NSArray<NSString*>*> * apiRequestList = [MTCloud shareCloud].apiManager.apiRequestList;
        
    __block MTBaseApi* baseApi;
    [apiRequestList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSInteger index = [obj indexOfObject:api];
       if(index >= 0 && index < obj.count)
       {
           Class c = NSClassFromString(key);
            if([c isSubclassOfClass:[MTBaseApi class]])
            {
                baseApi = c.new;
                *stop = YES;
            }
       }
    }];
    
    if(!baseApi)
        baseApi = [MTBaseApi new];
    
    return baseApi;
}

/**创建上传数据请求*/
-(MTBaseApi*)createApi:(NSString*)api Identifier:(NSString*)identifier UpLoadBlock:(AFConstructingBlock)block
{
    MTBaseApi* baseApi = [self createApi:api];
    baseApi.identifier = identifier;
    baseApi.url = api;
    baseApi.constructingBodyBlock = block;
    baseApi.delegate = self;
    
    return baseApi;
}





@end
