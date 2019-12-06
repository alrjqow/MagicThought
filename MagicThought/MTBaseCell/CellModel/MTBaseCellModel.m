//
//  MTBaseCellModel.m
//  QXProject
//
//  Created by monda on 2019/12/6.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCellModel.h"

@implementation MTBaseCellModel

// -1 表示不作任何修改
-(CGFloat)sepLineWidth
{
    return -1;
}

-(CGFloat)accessoryMarginRight
{
    return -1;
}

@end



NSString*  MTEmptyBaseCellRefreshOrder = @"MTEmptyBaseCellRefreshOrder";
@implementation MTEmptyBaseCellModel

-(NSString *)refreshOrder
{
    return MTEmptyBaseCellRefreshOrder;
}

@end




