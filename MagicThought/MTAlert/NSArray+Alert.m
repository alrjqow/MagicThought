//
//  NSArray+Alert.m
//  QXProject
//
//  Created by monda on 2019/12/11.
//  Copyright © 2019 monda. All rights reserved.
//

#import "NSArray+Alert.h"
#import "NSObject+ReuseIdentifier.h"
#import "NSString+Exist.h"

#import "MTCloud.h"
#import "MTConst.h"
#import "MTAlertViewConfig.h"

#import <MJExtension.h>

NSObject* appTitle_mtAlert()
{
    return title_mtAlert(mt_AppName());
}

NSObject* title_mtAlert(NSObject* object)
{
    return object.bindTag(@"title");
}

NSObject* logo_mtAlert(NSObject* object)
{
    return object.bindTag(@"img");
}

NSObject* content_mtAlert(NSObject* object)
{
    return object.bindTag(@"content");
}

NSObject* buttons_mtAlert(NSObject* object)
{
    NSArray* arr = (NSArray*)object;
    if(![arr isKindOfClass:[NSArray class]])
        arr = @[arr];
    
    return arr.bindTag(@"buttonModelList");
}

@interface NSArray (Alert)

-(void)Alert;
-(MTAlertViewConfig*)createAlertConfig;

@end

@implementation NSObject (Alert)

-(Alert)alert_mt
{
    __weak __typeof(self) weakSelf = self;
    Alert alert  = ^{
        
        if([weakSelf isKindOfClass:[MTAlertViewConfig class]])
            [(MTAlertViewConfig*)weakSelf alert];
        else if([weakSelf isKindOfClass:[NSArray class]])
            [(NSArray*)weakSelf Alert];
        else
            [@[weakSelf] Alert];
    };
    
    return alert;
}


-(MTAlertViewConfig *)alertConfig
{
    if([self isKindOfClass:[MTAlertViewConfig class]])
        return (MTAlertViewConfig*)self;
    else if([self isKindOfClass:[NSArray class]])
        return [(NSArray*)self createAlertConfig];
    else
        return [@[self] createAlertConfig];
}

@end

@implementation NSArray (Alert)

-(MTAlertViewConfig*)createAlertConfig
{
    NSString* reuseIdentifier = self.mt_reuseIdentifier;
    if(![reuseIdentifier isExist])
        reuseIdentifier = [MTCloud shareCloud].alertViewConfigName;
    
    Class configClassName = NSClassFromString(reuseIdentifier);
    
    if(![configClassName isSubclassOfClass:[MTAlertViewConfig class]])
        configClassName = [MTAlertViewConfig class];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    for (NSObject* obj in self) {
        
        if(![obj isKindOfClass:[NSObject class]])
            continue;
        
        if(![obj.mt_tagIdentifier isExist])
            continue;
        
        dict[obj.mt_tagIdentifier] = obj;
        obj.mt_tagIdentifier = nil;
    }
    
    MTAlertViewConfig* config = [configClassName mj_objectWithKeyValues:dict];
    
    return config;
}

-(void)Alert
{
    [[self createAlertConfig] alert];
}





@end
