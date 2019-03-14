//
//  MTStyleManager.h
//  DaYiProject
//
//  Created by monda on 2018/11/23.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTManager.h"
#import "MTStyleProtocol.h"
#import "MTConst.h"


MT_EXTERN NSString* mt_style;
MT_EXTERN NSString* mt_extend;
MT_EXTERN NSString* mt_parent;
MT_EXTERN NSString* mt_delete;


@interface MTStyle : MTManager

@property (nonatomic,strong, readonly) NSDictionary* tableViewStyle;

@property (nonatomic,strong,readonly) NSDictionary* controllerStyle;

@property (nonatomic,strong,readonly) NSDictionary* buttonStyle;

@property (nonatomic,strong,readonly) NSDictionary* labelStyle;

@property (nonatomic,strong) NSObject<MTStyleProtocol>* styleManager;

+(instancetype)style;

-(void)configStyleWithObject:(NSObject*)obj;

@end


