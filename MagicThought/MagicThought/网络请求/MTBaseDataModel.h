//
//  MTBaseDataModel.h
//  BoringProject
//
//  Created by monda on 2018/7/18.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetwork.h"

@interface MTBaseDataModel : NSObject

/**标识，用于区分同一请求接口，每次数据请求，主要用于数据上传时作区分*/
@property (nonatomic,strong) NSString* identifier;

/**请求域名*/
@property (nonatomic,strong) NSString* ipAddress;

/**这里URL 是指 请求的 uri*/
@property (nonatomic,strong) NSString* url;

/**判断请求成功，但数据结构不正确的情况*/
@property (nonatomic,assign) BOOL isResponseFail;

/**判断是否请求错误，即请求是不成功的*/
@property (nonatomic,assign) BOOL isRequestError;

/**请求完成后，接收的响应信息*/
@property (nonatomic,strong) NSString* msg;

/**请求错误时才有值，用于分析请求错误的原因*/
@property (nonatomic, strong) NSError *error;

/**用于 响应数据类型，根据 MTBaseApi 的响应类型确定，*/
@property (nonatomic, assign) YTKResponseSerializerType responseSerializerType;

/**响应数据，该数据可以通过 MTBaseDataModelProtocol代理 进行加工*/
@property (nonatomic,strong) id data;

/**请求错误、或请求成功但数据错误的情况，会把错误数据放入该属性*/
@property (nonatomic,strong) id failData;


@end



