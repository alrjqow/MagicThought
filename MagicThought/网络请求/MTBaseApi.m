//
//  MTBaseApi.m
//  BoringProject
//
//  Created by monda on 2018/7/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTBaseApi.h"

@implementation MTBatchApi @end

@implementation MTBaseApi

-(NSString *)baseUrl
{
    return self.baseAddress ? self.baseAddress : [YTKNetworkConfig sharedConfig].baseUrl;
}

- (NSString *)requestUrl{
    return self.url;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 10;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}


- (YTKResponseSerializerType)responseSerializerType{
    return YTKResponseSerializerTypeJSON;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    
    return @{@"Cookie" : @""};
}

- (id)requestArgument
{
    return self.postParameter;
}

-(NSMutableDictionary *)postParameter
{
    if(!_postParameter)
    {
        _postParameter = [NSMutableDictionary dictionary];
    }
    
    return _postParameter;
}

@end
