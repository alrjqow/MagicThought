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


extern NSObject* _Nullable MTAppTitle(void);
extern NSObject* _Nullable MTTitle(NSObject* _Nullable object);
extern NSObject* _Nullable MTLogo(NSObject* _Nullable object);
extern NSObject* _Nullable MTContent(NSObject* _Nullable object);
extern NSObject* _Nullable MTButtons(NSObject* _Nullable object);
