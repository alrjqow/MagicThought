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

/* MTDelegateViewDataModel 类类名，该类用于将 controller 中通用的数据抽离放在一起，避免在 controller 中写重复的数据源*/
@property (nonatomic,strong, readonly) NSString* dataModelClassName;

@end




