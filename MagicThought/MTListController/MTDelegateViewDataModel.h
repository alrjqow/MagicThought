//
//  MTDelegateViewDataModel.h
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import <Foundation/Foundation.h>




@class MTListController;
@interface MTDelegateViewDataModel : NSObject

+(instancetype)modelForController:(MTListController*)controller;

@property (nonatomic,strong,readonly) NSString* className;

@property (nonatomic,strong) NSArray* dataList;

@property (nonatomic,strong) NSArray* sectionList;

@property (nonatomic,strong) NSObject* emptyData;

@end


