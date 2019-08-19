//
//  TestController.m
//  DaYiProject
//
//  Created by monda on 2018/12/3.
//  Copyright © 2018 monda. All rights reserved.
//

#import "TestController.h"
#import "MTTenScrollContentView.h"
#import "MTTenScrollTitleView.h"
#import "MTTenScrollModel.h"
#import "MTTenScrollView.h"
#import "MTTenScrollViewCell.h"


#import "MTRefresh.h"
#import "MTConst.h"
#import "UIDevice+DeviceInfo.h"
#import "UIView+Frame.h"

#import "NSObject+ReuseIdentifier.h"

#import "NSObject+API.h"
#import "MTBaseDataModel.h"

@interface TestSubController : MTViewController

@end

@implementation TestSubController

-(void)setupDefault
{
    [super setupDefault];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

-(void)whenGetTenScrollDataModel:(MTBaseDataModel *)model
{
    UIColor* color = (UIColor*)model.data;
    if(!color)
        color = [UIColor yellowColor];
    
    self.view.backgroundColor = color;
}

@end

@interface TestTableViewController : MTTenScrollTableViewController



@end

@implementation TestTableViewController

-(void)whenGetTenScrollDataModel:(MTBaseDataModel *)model
{
    
}

-(NSArray *)dataList
{
    return (NSArray*)@"UITableViewCell".bandCount(20).bandHeight(44);
}

@end


@interface TestController ()


@end

@implementation TestController


#pragma mark - 懒加载

-(NSArray *)dataList
{
    return (NSArray*)@"UITableViewCell".bandCount(6).bandHeight(44);
}

-(NSArray *)tenScrollDataList
{
    //        _model.dataList = @[
    //                            mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"头号"),
    //                            mt_reuse([UIColor purpleColor]).band(@"TestSubController").bandTag(@"掌经号"),
    //                            mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"精选视频"),
    //                            mt_reuse([UIColor blueColor]).band(@"TestSubController").bandTag(@"生活"),
    //                            mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"好物"),
    //                            mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"大头鱼"),
    //                            mt_reuse([UIColor purpleColor]).band(@"TestSubController").bandTag(@"大易有塑7"),
    //                            mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"大易有塑18"),
    //                            mt_reuse([UIColor blueColor]).band(@"TestSubController").bandTag(@"手机号"),
    //                            mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"尾号"),
    //                            ];
    
    return @[
             mt_reuse([UIColor yellowColor]).band(@"TestController2").bandTag(@"头号"),
             mt_reuse([UIColor purpleColor]).band(@"TestController2").bandTag(@"掌经号"),
             mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"精选视频"),
             mt_reuse([UIColor blueColor]).band(@"TestSubController").bandTag(@"生活"),
             mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"好物"),
             mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"大头鱼")
             ];
}




@end



@interface TestController2 : MTTenScrollController


@end

@implementation TestController2

-(void)setupDefault
{
    [super setupDefault];
    
    self.tenScrollModel.tenScrollHeight = kScreenHeight_mt() - self.tenScrollModel.titleViewModel.titleViewHeight;
}



#pragma mark - 懒加载

-(NSArray *)dataList
{
    return (NSArray*)@"UITableViewCell".bandCount(6).bandHeight(44);
}

-(NSArray *)tenScrollDataList
{
//    return        @[
//                    mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"头号"),
//                    mt_reuse([UIColor purpleColor]).band(@"TestSubController").bandTag(@"掌经号"),
//                    mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"精选视频"),
//                    mt_reuse([UIColor blueColor]).band(@"TestSubController").bandTag(@"生活"),
//                    mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"好物"),
//                    mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"大头鱼")
//                    ];
              return      @[
                                mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"头号"),
                                mt_reuse([UIColor purpleColor]).band(@"TestTableViewController").bandTag(@"掌经号"),
                                mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"精选视频"),
                                mt_reuse([UIColor blueColor]).band(@"TestTableViewController").bandTag(@"生活"),
                                mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"好物"),
                                mt_reuse([UIColor yellowColor]).band(@"TestTableViewController").bandTag(@"大头鱼")
                                ];
}

@end
