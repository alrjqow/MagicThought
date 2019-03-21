//
//  MTApiProtocol.h
//  BoringProject
//
//  Created by monda on 2018/7/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import "YTKNetwork.h"

@class MTBaseDataModel;

@protocol MTApiProtocol<YTKRequestDelegate, YTKBatchRequestDelegate>

/**当接收到数据*/
-(void)whenGetBaseModel:(MTBaseDataModel*)model;

/**当请求失败*/
-(void)whenRequestFail:(MTBaseDataModel*)model;


@end


@protocol MTBaseDataModelProtocol

/**数据过滤1*/
-(BOOL)filterIsResponseFailBy:(NSDictionary*)responseObject;

/**数据过滤2*/
-(NSString*)adjustResponseMsgBy:(NSDictionary*)responseObject;


/**数据过滤4*/
-(id)adjustDataByUrl:(NSString*)url  sourceData:(NSDictionary*)data;

/**数据过滤5*/
-(NSString*)adjustErrorMsg;


@end
