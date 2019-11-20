//
//  MTDelegateViewDataModel.m
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateViewDataModel.h"
#import "MTListController.h"


@interface MTDelegateViewDataModel ()

@property (nonatomic,weak) MTListController* controller;



@end

@implementation MTDelegateViewDataModel


+(instancetype)modelForController:(MTListController*)controller
{
    MTDelegateViewDataModel* model = [MTDelegateViewDataModel new];
    model.controller = controller;    
    [model setValue:NSStringFromClass([controller class]) forKey:@"className"];
        
    return model;
}



@end
