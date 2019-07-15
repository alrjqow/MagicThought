//
//  MTDelegateCollectionView.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateCollectionView.h"
#import "MTDataSource.h"
#import "MTDelegateCollectionViewCell.h"
#import "MTDelegateCollectionReusableView.h"

@interface MTDelegateCollectionView()
    
@property (nonatomic,strong) MTDataSource* mt_dataSource;
    
@end


@implementation MTDelegateCollectionView
    
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
    
- (void)addTarget:(id<MTDelegateProtocol, UICollectionViewDelegateFlowLayout>)target
{
    [self addTarget:target EmptyData:nil DataList:nil SectionList:nil];
}
    
- (void)addTarget:(id)target EmptyData:(NSObject*)emptyData DataList:(NSArray*)dataList SectionList:(NSArray*)sectionList
{
        MTDataSource* dataSource = [MTDataSource new];
    
        [dataSource setValue:self forKey:@"collectionView"];
        dataSource.delegate = target;
        
        dataSource.emptyData = emptyData;
        dataSource.dataList = dataList;
        dataSource.sectionList = sectionList;
        
        self.dataSource = dataSource;
        self.delegate = dataSource;
        self.mt_dataSource = dataSource;
    }
    


    
    @end
