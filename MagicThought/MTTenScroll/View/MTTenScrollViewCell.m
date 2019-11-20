//
//  MTTenScrollViewCell.m
//  DaYiProject
//
//  Created by monda on 2018/12/25.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTenScrollViewCell.h"
#import "MTTenScrollViewCellDelegateModel.h"


@implementation MTTenScrollViewCell

-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:NSClassFromString(@"MTTenScrollModel")])
        return;
     
    ((MTTenScrollViewCellDelegateModel*)self.viewModel).model = (MTTenScrollModel*)object;
}

-(NSString *)viewModelClass
{
    return @"MTTenScrollViewCellDelegateModel";
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    if([self.viewModel respondsToSelector:@selector(giveSomeThingToMe:WithOrder:)])
        [self.viewModel giveSomeThingToMe:self.contentView WithOrder:nil];
}


@end


@implementation MTTenScrollViewCellX

-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:NSClassFromString(@"MTTenScrollModel")])
        return;
     
    ((MTTenScrollViewCellDelegateModel*)self.viewModel).model = (MTTenScrollModel*)object;
}

-(NSString *)viewModelClass
{
    return @"MTTenScrollViewCellDelegateModel";
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    if([self.viewModel respondsToSelector:@selector(giveSomeThingToMe:WithOrder:)])
        [self.viewModel giveSomeThingToMe:self WithOrder:nil];
}

@end
