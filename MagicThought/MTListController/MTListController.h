//
//  MTListController.h
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseListController.h"
#import "MTConst.h"
#import "MJRefresh.h"

/**使用列表请直接用此类*/
@interface MTListController : MTBaseListController<MTDelegateViewDataProtocol>

@property (nonatomic,strong, readonly) NSString* dataModelClassName;

//配合使用
@property (nonatomic,strong) NSArray<NSDictionary*>* keyValueList;
//此为需要转成对应模型的类名
@property (nonatomic,strong, readonly) NSString* modelClassName;

@end




