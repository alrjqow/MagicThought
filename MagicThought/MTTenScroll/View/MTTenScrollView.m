//
//  MTTenScrollView.m
//  DaYiProject
//
//  Created by monda on 2018/12/26.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollView.h"
#import "MTTenScrollViewDelegateModel.h"


@implementation MTTenScrollView

-(NSString *)scrollViewModelClass
{
    return @"MTTenScrollViewDelegateModel";
}

@end

@implementation MTTenScrollViewX


-(NSString *)scrollViewModelClass
{
    return @"MTTenScrollViewDelegateModel";
}

@end


@implementation MTDelegateTenScrollView

-(NSString *)scrollViewModelClass
{
    return @"MTDelegateTenScrollViewDelegateModel";
}

@end

@implementation MTDelegateTenScrollViewX

-(NSString *)scrollViewModelClass
{
    return @"MTDelegateTenScrollViewDelegateModel";
}

@end




@implementation UIScrollView (MTTenScrollModel)

-(void)setMt_tenScrollModel:(MTTenScrollModel *)mt_tenScrollModel
{
    ((MTTenScrollViewBaseDelegateModel*)self.viewModel).model = mt_tenScrollModel;
}

-(MTTenScrollModel *)mt_tenScrollModel
{
    return ((MTTenScrollViewBaseDelegateModel*)self.viewModel).model;
}

@end
