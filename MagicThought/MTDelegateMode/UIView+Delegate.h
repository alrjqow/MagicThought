//
//  UIView+Delegate.h
//  MDKit
//
//  Created by monda on 2019/5/15.
//  Copyright © 2019 monda. All rights reserved.
//

#import "NSObject+CommonProtocol.h"

@interface UIView (Delegate) <MTExchangeDataProtocol>

@property (nonatomic,strong) NSObject<MTViewModelProtocol>* viewModel;

@property (nonatomic,strong, readonly) NSString* viewModelClass;

@end


@interface UIScrollView (MTList)<MTListDataProtocol>

- (void)addTarget:(id)target;

- (void)addTarget:(id)target EmptyData:(NSObject*)emptyData DataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList;

- (void)reloadDataWithDataList:(NSArray*)dataList EmptyData:(NSObject*)emptyData;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList EmptyData:(NSObject*)emptyData;

@end

@interface UIScrollView (Direction)

/**< 0 向左， > 0 向右， = 0 不变*/
@property (nonatomic,assign,readonly) NSInteger directionXTag;

/**< 0 向下， > 0 上， = 0 不变*/
@property (nonatomic,assign,readonly) NSInteger directionYTag;

@end

