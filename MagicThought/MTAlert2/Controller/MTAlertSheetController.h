//
//  MTAlertSheetController.h
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTBaseAlertController.h"


@class MTAlertSheetItem;
@interface MTAlertSheetController : MTBaseAlertController

@property (nonatomic,strong) NSArray<MTAlertSheetItem*>* alertItemArr;

@end




