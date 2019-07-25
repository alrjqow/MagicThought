//
//  MTTableViewController.h
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTViewController.h"

#import "MTConst.h"
#import "MTDelegateTableView.h"
#import "MJRefresh.h"

#import "MTDelegateViewDataModel.h"

@interface MTTableViewController : MTViewController<MTDelegateViewDataProtocol>

@property (nonatomic,strong) MTDelegateViewDataModel* dataModel;

@property (nonatomic,strong) NSArray<NSDictionary*>* keyValueList;

@property (nonatomic,strong, readonly) NSString* modelClassName;

@end



