//
//  MTDelegatePickerView.m
//  DaYiProject
//
//  Created by monda on 2018/9/20.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTDelegatePickerView.h"
#import "MTDataSource.h"




@interface MTDelegatePickerView()

@property (nonatomic,strong) MTDataSource* mt_dataSource;

@end


@implementation MTDelegatePickerView



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
    
    [self reloadAllComponents];
}

- (void)addTarget:(id)target EmptyData:(NSObject*)emptyData DataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;
{
    MTDataSource* dataSource = [MTDataSource new];
    
    [dataSource setValue:self forKey:@"pickView"];
    dataSource.delegate = target;
    
    dataSource.emptyData = emptyData;
    dataSource.dataList = dataList;
    dataSource.sectionList = sectionList;
    
    self.dataSource = dataSource;
    self.delegate = target;
    self.mt_dataSource = dataSource;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if(self.separatorColor)
        for(UIView *singleLine in self.subviews)
            if (singleLine.frame.size.height < 1)
                singleLine.backgroundColor = self.separatorColor;
}

@end
