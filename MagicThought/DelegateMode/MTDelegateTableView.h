//
//  MTDelegateTableView.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"

@interface MTDelegateTableView : UITableView<UITableViewDelegate, MTDelegateProtocol>

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@property (nonatomic,weak, readonly) id<MTDelegateProtocol, UITableViewDelegate> target;

/**判断滚动方向*/
@property (nonatomic,assign, readonly) BOOL isScrollTop;

- (void)addTarget:(id)target;
- (void)addTarget:(id<MTDelegateProtocol, UITableViewDelegate>)target EmptyData:(NSObject*)emptyData DataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList;

- (void)reloadDataWithDataList:(NSArray*)dataList EmptyData:(NSObject*)emptyData;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList EmptyData:(NSObject*)emptyData;

@end







