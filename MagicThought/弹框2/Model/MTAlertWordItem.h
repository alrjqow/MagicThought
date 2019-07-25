//
//  MTAlertWordItem.h
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTAlertItem.h"

#import "MTWordStyle.h"
#import "MTConst.h"

@interface MTAlertWordItem : MTAlertItem

+(instancetype)itemWithOrder:(NSString*)order Title:(NSString*)title;

@property (nonatomic,strong) MTWordStyle* word;

@property (nonatomic,assign) BOOL isCancel;

@end

@interface MTAlertWordCancelItem : MTAlertWordItem

@end

