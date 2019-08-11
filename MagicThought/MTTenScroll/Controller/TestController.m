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

@interface TestSubController : UIViewController

@end

@implementation TestSubController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

-(void)whenGetBaseModel:(MTBaseDataModel *)model
{
    [super whenGetBaseModel:model];
    
    if([model.identifier isEqualToString:MTTenScrollIdentifier])
    {
        UIColor* color = (UIColor*)model.data;
        if(!color)
            color = [UIColor yellowColor];
        
        self.view.backgroundColor = color;
    }
}

@end

@interface TestTableViewController : UIViewController

@property (nonatomic,strong) MTDelegateTenScrollTableView* tableView;

@end

@implementation TestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}


-(void)whenGetBaseModel:(MTBaseDataModel *)model
{
    [super whenGetBaseModel:model];
    
    if([model.identifier isEqualToString:MTTenScrollIdentifier])
    {
        
    }
}

-(MTDelegateTenScrollTableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [MTDelegateTenScrollTableView new];
        _tableView.frame = self.view.bounds;
        [_tableView addTarget:self EmptyData:nil DataList:@"UITableViewCell".bandCount(20).bandHeight(44) SectionList:nil];
    }
    
    return _tableView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll2");
}

@end


@interface TestController ()

@property (nonatomic,strong) MTTenScrollModel* model;

@property (nonatomic,strong) MTTenScrollView* tableView;

@end

@implementation TestController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.tableView addTarget:self EmptyData:nil DataList:@"UITableViewCell".bandCount(6).bandHeight(44) SectionList:nil];
    [self.view addSubview:self.tableView];
}



#pragma mark - 懒加载



-(MTTenScrollView *)tableView
{
    if(!_tableView)
    {
        _tableView = [MTTenScrollView new];
        _tableView.frame = self.view.bounds;
        _tableView.model = self.model;
        _tableView.delegate = self;
    }
    
    return _tableView;
}


-(MTTenScrollModel *)model
{
    if(!_model)
    {
        _model = [MTTenScrollModel new];
//        _model.tenScrollHeight = kScreenHeight_mt() - kNavigationBarHeight_mt();
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
        _model.dataList = @[
                            mt_reuse([UIColor yellowColor]).band(@"TestController2").bandTag(@"头号"),
                            mt_reuse([UIColor purpleColor]).band(@"TestTableViewController").bandTag(@"掌经号"),
                            mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"精选视频"),
                            mt_reuse([UIColor blueColor]).band(@"TestTableViewController").bandTag(@"生活"),
                            mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"好物"),
                            mt_reuse([UIColor yellowColor]).band(@"TestTableViewController").bandTag(@"大头鱼")
                            ];
    }
    
    return _model;
}

@end



@interface TestController2 : UIViewController

@property (nonatomic,strong) MTTenScrollModel* model;

@property (nonatomic,strong) MTTenScrollView* tableView;

@end

@implementation TestController2


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addTarget:self EmptyData:nil DataList:@"UITableViewCell".bandCount(5).bandHeight(44) SectionList:nil];
    [self.view addSubview:self.tableView];
}



#pragma mark - 懒加载



-(MTTenScrollView *)tableView
{
    if(!_tableView)
    {
        _tableView = [MTTenScrollView new];
        _tableView.frame = self.view.bounds;
        _tableView.model = self.model;
        _tableView.delegate = self;
    }
    
    return _tableView;
}


-(MTTenScrollModel *)model
{
    if(!_model)
    {
        _model = [MTTenScrollModel new];
                _model.tenScrollHeight = kScreenHeight_mt() - _model.titleViewModel.titleViewHeight;
                _model.dataList = @[
                                    mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"头号"),
                                    mt_reuse([UIColor purpleColor]).band(@"TestSubController").bandTag(@"掌经号"),
                                    mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"精选视频"),
                                    mt_reuse([UIColor blueColor]).band(@"TestSubController").bandTag(@"生活"),
                                    mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"好物"),
                                    mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"大头鱼")
                                    ];
//        _model.dataList = @[
//                            mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"头号"),
//                            mt_reuse([UIColor purpleColor]).band(@"TestTableViewController").bandTag(@"掌经号"),
//                            mt_reuse([UIColor redColor]).band(@"TestSubController").bandTag(@"精选视频"),
//                            mt_reuse([UIColor blueColor]).band(@"TestTableViewController").bandTag(@"生活"),
//                            mt_reuse([UIColor greenColor]).band(@"TestSubController").bandTag(@"好物"),
//                            mt_reuse([UIColor yellowColor]).band(@"TestTableViewController").bandTag(@"大头鱼")
//                            ];
    }
    
    return _model;
}

@end
