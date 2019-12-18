//
//  NSArray+Alert.h
//  QXProject
//
//  Created by monda on 2019/12/11.
//  Copyright © 2019 monda. All rights reserved.
//


#import <Foundation/Foundation.h>

@class MTAlertViewConfig;
typedef void (^Alert) (void);

@interface NSObject (Alert)

@property (nonatomic,copy,readonly) Alert _Nonnull alert_mt;
@property (nonatomic,copy,readonly) MTAlertViewConfig* _Nonnull alertConfig;

@end


extern NSObject* _Nullable mtAppTitle(void);
extern NSObject* _Nullable mtTitle(NSObject* _Nullable object);
extern NSObject* _Nullable mtLogo(NSObject* _Nullable object);
extern NSObject* _Nullable mtContent(NSObject* _Nullable object);
extern NSObject* _Nullable mtButtons(NSObject* _Nullable object);
