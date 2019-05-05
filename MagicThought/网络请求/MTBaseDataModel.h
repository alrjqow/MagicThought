//
//  MTBaseDataModel.h
//  BoringProject
//
//  Created by monda on 2018/7/18.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MTBaseDataModel : NSObject

@property (nonatomic,strong) NSString* identifier;

@property (nonatomic,strong) NSString* ipAddress;

@property (nonatomic,strong) NSString* url;

@property (nonatomic,assign) BOOL isResponseFail;

@property (nonatomic,assign) BOOL isRequestError;

@property (nonatomic,strong) NSString* msg;

@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) YTKResponseSerializerType responseSerializerType;

@property (nonatomic,strong) id data;

@property (nonatomic,strong) id failData;

@end



