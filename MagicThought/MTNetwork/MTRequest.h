//
//  MTRequest.h
//  QXProject
//
//  Created by monda on 2020/11/25.
//  Copyright © 2020 monda. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "MTBaseListController.h"

typedef enum : NSUInteger {
    MTEndRefreshStatusDefault,
    MTEndRefreshStatusDefaultWithMsg,
    MTEndRefreshStatusDefaultWithErrorMsg,
    MTEndRefreshStatusDefaultWithCenterToastMsg,    
    MTEndRefreshStatusDefaultFooterNoMoreData,
    MTEndRefreshStatusNotStop
} MTEndRefreshStatus;

@protocol MTEndRefreshStatusProtocol

-(void)setEndRefreshStatus:(MTEndRefreshStatus)endRefreshStatus Message:(NSString*)message;

@end

@interface MTRequestCallbackHandler : NSObject @end

@class MTRequest;
typedef MTRequest* (^MTSetRequestCallbackHandler)(MTRequestCallbackHandler* handler);
typedef void (^MTStartRequestCallbackHandler)(MTRequestCallbackHandler* handler);
typedef MTEndRefreshStatus (^MTEndRefreshStatusCallback)(id obj, NSString **mssage, BOOL success, MTRequest* request);



@interface MTResponseModel : NSObject

@property (nonatomic,strong) NSDictionary* keyData;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, copy) NSString *responeMessage;

@end

@interface MTRequest : YTKRequest

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSDictionary *paramters;

@property (nonatomic, strong) Class cls;

@property (nonatomic,strong) Class responseModelCls;

@property (nonatomic, assign) YTKRequestMethod method;

@property (nonatomic, assign) YTKRequestSerializerType requestContentType;

@property (nonatomic, assign) YTKResponseSerializerType responseContentType;

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *responeMessage;

@property (nonatomic, strong) id responseJSONModel;


@property (nonatomic,copy, readonly) MTSetRequestCallbackHandler setHandle;
@property (nonatomic,copy, readonly) MTStartRequestCallbackHandler startHandle;

@end



CG_EXTERN NSObject* _Nonnull cls_mtRequest(Class cls);
CG_EXTERN NSObject* _Nonnull responseModelCls_mtRequest(Class responseModelCls);
CG_EXTERN NSObject* _Nonnull method_mtRequest(YTKRequestMethod method);

CG_EXTERN NSObject* _Nonnull requestContentType_mtRequest(YTKRequestSerializerType requestContentType);
CG_EXTERN NSObject* _Nonnull responseContentType_mtRequest(YTKResponseSerializerType responseContentType);




typedef MTRequestCallbackHandler* (^MTCreateRequestCallbackHandlerCallback)(MTEndRefreshStatusCallback);

@interface MTBaseListController (EndRefresh)<MTEndRefreshStatusProtocol>

@property (nonatomic,copy, readonly) MTCreateRequestCallbackHandlerCallback callBack;

@end


@interface MTBatchRequest : YTKBatchRequest

+ (instancetype)requestWithArray:(NSArray<MTRequest *> *)requestArray;

@property (nonatomic,copy, readonly) MTStartRequestCallbackHandler startHandle;

@end
