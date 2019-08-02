//
//  MTDelegateTableView.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateTableView.h"
#import "MTDelegateHeaderFooterView.h"
#import "MTDelegateTableViewCell.h"
#import "MTConst.h"
#import "NSObject+ReuseIdentifier.h"
#import "MTDataSource.h"





@interface MTDelegateTableView()

@property (nonatomic,strong) MTDataSource* mt_dataSource;


@end

@implementation MTDelegateTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self = [super initWithFrame:frame style:style])
    {
        [self setupDefault];
    }
    
    return self;
}

- (void)reloadDataWithDataList:(NSArray*)dataList
{
    [self reloadDataWithDataList:dataList EmptyData:nil];
}

- (void)reloadDataWithDataList:(NSArray*)dataList EmptyData:(NSObject*)emptyData
{
    [self reloadDataWithDataList:dataList SectionList:nil EmptyData:emptyData];
}

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList
{
    [self reloadDataWithDataList:dataList SectionList:sectionList EmptyData:nil];
}

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList EmptyData:(NSObject*)emptyData
{
    self.mt_dataSource.emptyData = emptyData;
    self.mt_dataSource.dataList = dataList;
    self.mt_dataSource.sectionList = sectionList;
    
    [self reloadData];
}

- (void)addTarget:(id)target
{
    [self addTarget:target EmptyData:nil DataList:nil SectionList:nil];
}

- (void)addTarget:(id)target EmptyData:(NSObject*)emptyData DataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;
{
    MTDataSource* dataSource = [MTDataSource new];
                                                                
    [dataSource setValue:self forKey:@"tableView"];
    
    if(target != self)
        _target = target;
    dataSource.delegate = self;
    
    dataSource.emptyData = emptyData;
    dataSource.dataList = dataList;
    dataSource.sectionList = sectionList;
        
    self.dataSource = dataSource;
    self.delegate = dataSource;
    self.mt_dataSource = dataSource;
}

#pragma mark - tableView代理

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.target respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [self.target tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - scrollView代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([self.target respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.target scrollViewDidScroll:scrollView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([self.target respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.target scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([self.target respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.target scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.target respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.target scrollViewDidEndDecelerating:scrollView];
}

-(void)doSomeThingForMe:(id)obj withOrder:(NSString *)order
{
    if([self.target respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.target doSomeThingForMe:obj withOrder:order];
}

-(void)doSomeThingForMe:(id)obj withOrder:(NSString *)order withItem:(id)item
{
    if([self.target respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
        [self.target doSomeThingForMe:obj withOrder:order withItem:item];
}

#pragma mark - 懒加载

-(void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self withOrder:MTScrollViewDidScrollOrder];
}



@end


