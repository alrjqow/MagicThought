//
//  MTHeaderFooterRefreshListController.m
//  MDKit
//
//  Created by monda on 2019/5/17.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTHeaderFooterRefreshListController.h"

#import "UIView+Frame.h"
#import "NSObject+ReuseIdentifier.h"

@interface MTHeaderFooterRefreshListController ()

@end

@implementation MTHeaderFooterRefreshListController

-(void)setupDefault
{
    [super setupDefault];
    
    if(!self.isRemoveMJFooter)
        self.listView.mj_footer = self.mj_footer;
    
    self.page = 1;
    
    __weak __typeof(self) weakSelf = self;
    if(!self.mj_Block)
        self.mj_Block = ^{
            
            [weakSelf.itemArr removeAllObjects];
            weakSelf.page = 1;
            [weakSelf.listView.mj_footer resetNoMoreData];
            [weakSelf startRequest];
        };
}

#pragma mark - 重载方法

-(void)whenEndRefreshing:(BOOL)isSuccess Model:(MTBaseDataModel *)model
{
    [super whenEndRefreshing:isSuccess Model:model];
    
    self.listView.mj_footer.hidden = !self.itemArr.count;
    if(!self.infoModel.hasNext)
        [self.listView.mj_footer endRefreshingWithNoMoreData];
    else
    {
        [self.listView.mj_footer endRefreshing];
        self.page++;
    }
}

#pragma mark - 成员方法

//-(CGFloat)getTableViewFillCellHeight
//{
//    static CGFloat originBottomOffset;
//    if(!originBottomOffset)
//        originBottomOffset = self.listView.contentInset.bottom;
//
//
//    CGFloat headerH = 0;//need
//    if([self.listView isKindOfClass:[UITableView class]])
//        headerH = ((UITableView*)self.listView).tableHeaderView.height;//need
//    CGFloat topOffset = self.listView.contentInset.top;//need
//    CGFloat cellH = 0;//need
//    CGFloat sectionHeaderFooterH = 0;//need
//    CGFloat footerH = 0;//need
//    if([self.listView isKindOfClass:[UITableView class]])
//        footerH = ((UITableView*)self.listView).tableFooterView.height;//need
//
//    UIEdgeInsets inset = self.listView.contentInset;
//    if(self.listView.mj_footer)
//        inset.bottom = 0;
//
//    CGFloat bottomOffset = self.listView.contentInset.bottom;//need
//
//
//    //获取所有cell占据的高度
//    CGFloat sectionCount = 1;
//    CGFloat allArrH = 0;
//    CGFloat singleArrH = 0;
//    BOOL isAllArr = YES;
//    for(NSObject* obj in self.itemArr)
//    {
//        if([obj isKindOfClass:[NSArray class]])
//            continue;
//
//        isAllArr = false;
//        break;
//    }
//
//    if(isAllArr)
//    {
//        for(NSArray* arr in self.itemArr)
//        {
//            for (NSObject* obj in arr) {
//                allArrH += obj.mt_itemHeight;
//            }
//        }
//    }
//    else
//    {
//        for(NSObject* obj in self.itemArr)
//            singleArrH += obj.mt_itemHeight;
//    }
//
//    cellH = isAllArr ? allArrH : singleArrH;
//    sectionCount = isAllArr ? self.itemArr.count : 1;
//
//    //获取组头、组尾占据的高度
//    BOOL isSingle = false;
//    for(id obj in self.dataModel.sectionList)
//    {
//        if([obj isKindOfClass:[NSArray class]])
//            continue;
//
//        isSingle = YES;
//        break;
//    }
//
//    if(isSingle)
//    {
//        for(NSObject* obj in self.dataModel.sectionList)
//        {
//            NSInteger index = [self.dataModel.sectionList indexOfObject:obj];
//            if(index >= sectionCount)
//                break;
//            sectionHeaderFooterH += obj.mt_itemHeight;
//        }
//    }
//    else
//    {
//        for(NSArray* arr in self.dataModel.sectionList)
//        {
//            NSInteger index = [self.dataModel.sectionList indexOfObject:arr];
//            if(index >= 2)
//                break;
//
//            for(NSObject* obj in arr)
//            {
//                NSInteger index = [arr indexOfObject:obj];
//                if(index >= sectionCount)
//                    break;
//                sectionHeaderFooterH += obj.mt_itemHeight;
//            }
//        }
//    }
    
    //    NSLog(@"%lf",self.listView.height);
    //    NSLog(@"%lf",headerH);
    //    NSLog(@"%lf",footerH);
    //    NSLog(@"%lf",topOffset);
    //    NSLog(@"%lf",bottomOffset);
    //    NSLog(@"%lf",cellH);
    //    NSLog(@"%lf",sectionHeaderFooterH);
    
//    CGFloat fillH = self.listView.height - (headerH + footerH + topOffset + bottomOffset + cellH + sectionHeaderFooterH);
    
    //这个可以在超出屏幕时仍然可以fill
    //    CGFloat fillH = self.listView.height - (headerH + footerH + topOffset + bottomOffset + cellH + sectionHeaderFooterH) % self.listView.height;
//    if(fillH < 0)
//    {
//        fillH = 0;
//        inset.bottom = originBottomOffset;
//    }
//
//
//    self.listView.contentInset = inset;
//    return fillH;
//}

#pragma mark - 懒加载

-(NSArray *)dataList
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.itemArr];
    
//    if(self.itemArr.count)
//        [arr addObject:@"DYNoSepLineBaseCell".bindHeight([self getTableViewFillCellHeight])];
    
    return [arr copy];
}

-(MJRefreshFooter<MJRefreshFooterProtocol> *)mj_footer
{
    if(!_mj_footer)
    {
            __weak __typeof(self) weakSelf = self;
        
        Class footerClass = self.footerClass;
        if(![footerClass isSubclassOfClass:[MJRefreshFooter class]])
            footerClass = [MTRefreshBackNormalFooter class];
                    
        MJRefreshFooter<MJRefreshFooterProtocol>* footer = [footerClass new];
        footer.refreshingBlock = ^{
             if(weakSelf.mj_footer_Block)
                   weakSelf.mj_footer_Block();
        };
        _mj_footer = footer;
    }
    
    return _mj_footer;
}

-(Class)footerClass
{
    return MTRefreshBackNormalFooter.class;
}

-(MTBlock)mj_footer_Block
{
    if(!_mj_footer_Block)
    {
        __weak __typeof(self) weakSelf = self;
        _mj_footer_Block = ^{
            
            [weakSelf.listView.mj_footer endRefreshing];
        };
    }
    
    return _mj_footer_Block;
}

-(NSMutableArray *)itemArr
{
    if(!_itemArr)
    {
        _itemArr = [NSMutableArray array];
    }
    
    return _itemArr;
}

@end
