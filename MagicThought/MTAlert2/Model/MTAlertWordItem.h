//
//  MTAlertWordItem.h
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//


#import "MTBaseViewContentModel.h"

@interface MTAlertWordItem : MTBaseViewContentModel

@property (nonatomic,assign) BOOL isCancel;

@end

@interface MTAlertWordCancelItem : MTAlertWordItem @end


@interface MTAlertPickerItem : MTBaseViewContentStateModel @end
