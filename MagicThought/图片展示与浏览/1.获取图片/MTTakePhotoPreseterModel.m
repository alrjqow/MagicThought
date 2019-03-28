//
//  MTTakePhotoPreseterModel.m
//  DaYiProject
//
//  Created by monda on 2018/8/24.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTakePhotoPreseterModel.h"
#import "MTBaseAlertController.h"

@implementation MTTakePhotoPreseterModel

-(instancetype)init
{
    if(self = [super init])
    {
        self.maxCount = 9;
        self.columnNumber = 4;
    }
    
    return self;
}

-(void)dismissAlertController
{
    [self.alertController dismissViewControllerAnimated:false completion:nil];
}

@end
