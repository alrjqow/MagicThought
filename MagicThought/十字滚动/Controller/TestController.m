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

#import "MTDefine.h"
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


@interface TestTableViewController()<UITableViewDelegate>

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


@interface TestController ()<UITableViewDelegate>

@property (nonatomic,strong) MTTenScrollContentView* collectionView;

@property (nonatomic,strong) MTTenScrollTitleView* titleView;

@property (nonatomic,strong) MTTenScrollModel* model;

@property (nonatomic,strong) MTTenScrollView* tableView;

@end

@implementation TestController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.tableView.y = 64;
//    self.tableView.height -= 64;
//
//
    [self.tableView addTarget:self EmptyData:nil DataList:@"UITableViewCell".bandCount(20).bandHeight(44) SectionList:nil];
    [self.view addSubview:self.tableView];
    
//    UIScrollView* scrollView = [UIScrollView new];
//    scrollView.backgroundColor = [UIColor blueColor];
//    scrollView.frame = self.view.bounds;
//    scrollView.contentSize = CGSizeMake(0, self.view.height * 2);
//
//    UIScrollView* scrollView2 = [UIScrollView new];
//    scrollView2.backgroundColor = [UIColor redColor];
//    scrollView2.frame = self.view.bounds;
//    scrollView2.height -= 200;
//    scrollView2.y = self.view.height;
//    scrollView2.contentSize = CGSizeMake(0, self.view.height * 2);
//
//    UIView* view = [UIView new];
//    view.backgroundColor = [UIColor yellowColor];
//    view.frame = CGRectMake(50, self.view.height - 100, 100, 100);
//
//    [scrollView addSubview:view];
//    [scrollView addSubview:scrollView2];
    
//    MTTenScrollViewCell* cell = [MTTenScrollViewCell new];
//    cell.model = self.model;
//    cell.frame = self.view.bounds;
//    cell.y = 64 + self.view.height;
//    cell.height -= 64;
    
//    [scrollView addSubview:cell];
    
//    [self.view addSubview:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll");
}

#pragma mark - 懒加载

-(MTTenScrollContentView *)collectionView
{
    if(!_collectionView)
    {
        _collectionView = [MTTenScrollContentView new];
        _collectionView.frame = self.view.bounds;
        _collectionView.height -= kTabBarHeight_mt;
        _collectionView.backgroundColor = [UIColor redColor];
        
//        _collectionView.showsVerticalScrollIndicator = false;
        
//        [_collectionView addTarget:self EmptyData:nil DataList:self.infoArr SectionList:@[@"".bandSpacing(mt_collectionViewSpacingMake(10, 0, UIEdgeInsetsZero))]];
    }
    
    return _collectionView;
}

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

-(MTTenScrollTitleView *)titleView
{
    if(!_titleView)
    {
        _titleView = [MTTenScrollTitleView new];
        _titleView.frame = self.view.bounds;
        _titleView.height = 80;
        _titleView.y = 100;
        _titleView.backgroundColor = [UIColor redColor];
    }
    
    return _titleView;
}

-(MTTenScrollModel *)model
{
    if(!_model)
    {
        _model = [MTTenScrollModel new];        
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
                            mt_reuse([UIColor yellowColor]).band(@"TestSubController").bandTag(@"头号"),
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
