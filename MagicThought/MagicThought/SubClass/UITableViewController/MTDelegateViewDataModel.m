//
//  MTDelegateViewDataModel.m
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTDelegateViewDataModel.h"
#import "MTTableViewController.h"


@interface MTDelegateViewDataModel ()

@property (nonatomic,weak, readonly) MTTableViewController* controller;



@end

@implementation MTDelegateViewDataModel


+(instancetype)modelForController:(MTTableViewController*)controller
{
    MTDelegateViewDataModel* model = [MTDelegateViewDataModel new];    
    [model setValue:controller forKey:@"controller"];
    [model setValue:NSStringFromClass([controller class]) forKey:@"className"];
        
    return model;
}



@end
