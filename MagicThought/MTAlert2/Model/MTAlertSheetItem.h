//
//  MTAlertSheetItem.h
//  SimpleProject
//
//  Created by monda on 2019/6/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTAlertWordItem.h"



@interface MTAlertSheetItem : MTAlertWordItem

@property (nonatomic,assign) CGFloat marginBottom;

@property (nonatomic,assign) CGFloat itemHeight;

@end



@interface MTAlertSheetCancelItem : MTAlertSheetItem @end
