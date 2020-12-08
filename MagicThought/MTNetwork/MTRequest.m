//
//  MTRequest.m
//  QXProject
//
//  Created by monda on 2020/11/25.
//  Copyright © 2020 monda. All rights reserved.
//

#import "MTRequest.h"
#import "NSString+Exist.h"
#import <MJExtension.h>

typedef void(^MTRequestCallbackHandlerCallback)(id obj, NSString *mssage, BOOL success, MTRequest* request);

@interface MTRequestCallbackHandler ()

@property (nonatomic,weak) id<MTEndRefreshStatusProtocol> object;

@property (nonatomic,copy) MTEndRefreshStatusCallback endRefreshStatusCallback;

@property (nonatomic,copy, readonly) MTRequestCallbackHandlerCallback callBack;

@end

@implementation MTRequestCallbackHandler

-(MTRequestCallbackHandlerCallback)callBack
{
    __weak __typeof(self) weakSelf = self;
    MTRequestCallbackHandlerCallback callBack  = ^(id obj, NSString *message, BOOL success, MTRequest* request){
                
        if(weakSelf.endRefreshStatusCallback)
            [weakSelf.object setEndRefreshStatus:weakSelf.endRefreshStatusCallback(obj, &message, success, request) Message:message];
    };
    
    return callBack;
}

@end

@interface MTRequest ()

@property (nonatomic,strong) MTRequestCallbackHandler* callBackHandler;

@end

@implementation MTRequest

-(instancetype)init
{
    if(self = [super init])
    {
        self.requestContentType = YTKRequestSerializerTypeHTTP;
        self.responseContentType = YTKResponseSerializerTypeJSON;
    }
    
    return self;
}

-(instancetype)setWithObject:(NSObject *)obj
{
    NSObject* data = [obj isKindOfClass:[NSReuseObject class]] ? ((NSReuseObject*)obj).data : obj;
    if([obj.mt_keyName isExist])
    {
        if(data)
           [self setValue:data forKey:obj.mt_keyName];
        return self;
    }
    
    if([obj isKindOfClass:[NSString class]])
        self.urlString = (NSString*)obj;
    else if([obj isKindOfClass:[NSDictionary class]])
        self.paramters = (NSDictionary*)obj;
        
    return self;
}

- (NSString *)requestUrl {
    return _urlString;
}

- (YTKRequestMethod)requestMethod{
        return _method;
}

- (id)requestArgument {
    return _paramters;
}

- (NSTimeInterval)requestTimeoutInterval{
    return 15;
}

- (YTKRequestSerializerType)requestSerializerType {
    return _requestContentType;
}

- (YTKResponseSerializerType)responseSerializerType {
    return _responseContentType;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *Request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    NSString *cookie = [Request objectForKey:@"Cookie"];
    if (cookie) {
        return @{@"Cookie": cookie};
    } else {
        return nil;
    }
}

-(void)requestCompleteFilter
{
    NSLog(@"%@\n%@", self.description, self.responseJSONObject);
    [self JsonConvertModel];
}

-(void)requestFailedFilter
{
    NSLog(@"%@\n%@", self.description, self.error);
    
    _responeMessage = @"网络不给力";
}

///json转model的具体方法
- (void)JsonConvertModel {
        
    _success = YES;
    if ([self.responseJSONObject isKindOfClass:[NSDictionary class]]) {
        
        if([self.responseModelCls isSubclassOfClass:[MTResponseModel class]])
        {
            MTResponseModel* responseModel = [self.responseModelCls mj_objectWithKeyValues:self.responseJSONObject];
            _responeMessage = responseModel.responeMessage;
            _success = responseModel.success;
            
            if (self.cls && responseModel.keyData) {
                //如果返回的result是个数组
                if ([responseModel.keyData isKindOfClass:[NSArray class]])
                    self.responseJSONModel = [self.cls mj_objectArrayWithKeyValuesArray:responseModel.keyData];
                else
                    self.responseJSONModel = [self.cls mj_objectWithKeyValues:responseModel.keyData] ;
            }
        }
    } else if ([self.responseJSONObject isKindOfClass:[NSArray class]] && self.cls)
        self.responseJSONModel = [self.cls mj_objectArrayWithKeyValuesArray:self.responseJSONObject];
}


-(MTStartRequestCallbackHandler)startHandle
{
    __weak __typeof(self) weakSelf = self;
    MTStartRequestCallbackHandler startHandle  = ^(MTRequestCallbackHandler* handler){
        __strong typeof(self) strongSelf = weakSelf;//第一层
        
        strongSelf.setHandle(handler);
        [strongSelf start];
    };
    
    return startHandle;
}

-(MTSetRequestCallbackHandler)setHandle
{
    __weak __typeof(self) weakSelf = self;
    MTSetRequestCallbackHandler setHandle  = ^(MTRequestCallbackHandler* handler){
        __strong typeof(self) strongSelf = weakSelf;//第一层
        weakSelf.callBackHandler = handler;
        
        __weak typeof(self) weakSelf2 = strongSelf;
        [strongSelf setCompletionBlockWithSuccess:^(__kindof MTRequest * _Nonnull request) {
            __strong typeof(self) strongSelf2 = weakSelf2;//第二层
            
            if(strongSelf2.callBackHandler.callBack)
                strongSelf2.callBackHandler.callBack(request.responseJSONModel, request.responeMessage, request.success, request);
        } failure:^(__kindof MTRequest * _Nonnull request) {
            
            __strong typeof(self) strongSelf2 = weakSelf2;//第二层
            if(strongSelf2.callBackHandler.callBack)
                strongSelf2.callBackHandler.callBack(nil, request.responeMessage, false, request);
        }];
        
        return weakSelf;
    };
    
    return setHandle;
}

@end

@implementation MTResponseModel @end

NSObject* _Nonnull cls_mtRequest(Class cls)
{return mt_reuse(cls).bindKey(@"cls");}

NSObject* _Nonnull responseModelCls_mtRequest(Class responseModelCls)
{return mt_reuse(responseModelCls).bindKey(@"responseModelCls");}

NSObject* _Nonnull method_mtRequest(YTKRequestMethod method)
{return mt_reuse(@(method)).bindKey(@"method");}

NSObject* _Nonnull requestContentType_mtRequest(YTKRequestSerializerType requestContentType)
{return mt_reuse(@(requestContentType)).bindKey(@"requestContentType");}

NSObject* _Nonnull responseContentType_mtRequest(YTKResponseSerializerType responseContentType)
{return mt_reuse(@(responseContentType)).bindKey(@"responseContentType");}





@implementation MTBaseListController (EndRefresh)

-(void)setEndRefreshStatus:(MTEndRefreshStatus)endRefreshStatus Message:(NSString *)message
{
    switch (endRefreshStatus) {
            
        case MTEndRefreshStatusDefaultFooterNoMoreData:
        {
            [self dismissIndicator];
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshingWithNoMoreData];
            break;
        }
            
        case MTEndRefreshStatusDefaultWithCenterToastMsg:
        {
            [self showCenterToast:message];
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshing];
            break;
        }
                        
        case MTEndRefreshStatusDefaultWithErrorMsg:
        {
            [self showError:message];
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshing];
            break;
        }
            
        case MTEndRefreshStatusDefaultWithMsg:
        {
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshing];
            break;
        }
            
        case MTEndRefreshStatusNotStop:
            break;
            
        default:
        {
            [self dismissIndicator];
            [self.listView.mj_header endRefreshing];
            [self.listView.mj_footer endRefreshing];
            break;
        }
    }
}

-(MTCreateRequestCallbackHandlerCallback)callBack
{
    __weak typeof(self) weakSelf = self;
      MTCreateRequestCallbackHandlerCallback callBack  = ^(MTEndRefreshStatusCallback endRefreshStatusCallback){
          
          MTRequestCallbackHandler* handler = [MTRequestCallbackHandler new];
          handler.endRefreshStatusCallback = endRefreshStatusCallback;
          handler.object = weakSelf;
          return handler;
      };
      
      return callBack;
}

@end


@implementation MTBatchRequest

-(instancetype)initWithRequestArray:(NSArray<YTKRequest *> *)requestArray
{
    NSMutableArray* requestArrayM = NSMutableArray.new;
    for(YTKRequest* request in requestArray)
    {
        if([request isKindOfClass:[MTRequest class]])
            [requestArrayM addObject:request];
    }
    
    self = [super initWithRequestArray:requestArrayM];
        
    return self;
}

+ (instancetype)requestWithArray:(NSArray<MTRequest *> *)requestArray
{
    return [[self alloc] initWithRequestArray:requestArray];
}

-(MTStartRequestCallbackHandler)startHandle
{
    __weak __typeof(self) weakSelf = self;
    MTStartRequestCallbackHandler startHandle  = ^(MTRequestCallbackHandler* handler){
        __strong typeof(self) strongSelf = weakSelf;//第一层
                
        [strongSelf startWithCompletionBlockWithSuccess:^(__kindof YTKBatchRequest * _Nonnull batchRequest) {
            
            for(MTRequest* request in batchRequest.requestArray)
            {
                if(![request isKindOfClass:[MTRequest class]])
                    continue;
                
                if(request.callBackHandler)
                    request.callBackHandler.callBack(request.responseJSONModel, request.responeMessage, request.success, request);
            }

            handler.callBack(nil, nil, YES, nil);
        } failure:^(__kindof YTKBatchRequest * _Nonnull batchRequest) {
                        
            MTRequest* failedRequest = (MTRequest*)batchRequest.failedRequest;
            handler.callBack(nil, failedRequest.responeMessage, false, failedRequest);
        }];
    };
    
    return startHandle;
}

@end
