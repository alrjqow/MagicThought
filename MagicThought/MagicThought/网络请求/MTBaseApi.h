//
//  MTBaseApi.h
//  BoringProject
//
//  Created by monda on 2018/7/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import "YTKNetwork.h"


@interface MTBaseApi : YTKRequest

@property (nonatomic,strong) NSString* identifier;

@property (nonatomic,strong) NSString* baseAddress;

@property (nonatomic,strong) NSString* url;

@property (nonatomic,strong) NSMutableDictionary* postParameter;

@end


@interface MTBatchApi : YTKBatchRequest

@property (nonatomic,strong) NSString* identifier;

@end


