//
//  MTDelegateCollectionView.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"


@interface MTDelegateCollectionView : UICollectionView

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;
    
- (void)addTarget:(id<MTDelegateProtocol, UICollectionViewDelegateFlowLayout>)target EmptyData:(NSObject*)emptyData DataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList;

- (void)reloadDataWithDataList:(NSArray*)dataList EmptyData:(NSObject*)emptyData;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList EmptyData:(NSObject*)emptyData;

-(void)loadData;

@end
