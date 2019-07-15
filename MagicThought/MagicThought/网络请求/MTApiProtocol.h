//
//  MTApiProtocol.h
//  BoringProject
//
//  Created by monda on 2018/7/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import "YTKNetwork.h"
@class MTBaseDataModel;
@class MTBaseApi;

@protocol MTApiProtocol<YTKRequestDelegate, YTKBatchRequestDelegate>


/**当接收到数据*/
-(void)whenGetBaseModel:(MTBaseDataModel*)model;

/**当请求失败*/
-(void)whenRequestFail:(MTBaseDataModel*)model;

/**是否显示请求成功打印*/
-(BOOL)isShowSuccessLog:(MTBaseDataModel*)model;

@end


@protocol MTBaseDataModelProtocol

/**生成一个ytkrequest请求*/
-(MTBaseApi*)createApiWithIdentifier:(NSString*)identifier;

/**数据过滤1*/
-(BOOL)filterIsResponseFailBy:(NSDictionary*)responseObject;

/**数据过滤2*/
-(NSString*)adjustResponseMsgBy:(NSDictionary*)responseObject;


/**数据过滤4*/
-(id)adjustDataByUrl:(NSString*)url  sourceData:(NSDictionary*)data;

/**数据过滤5*/
-(NSString*)adjustErrorMsg;


@end
