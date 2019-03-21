//
//  MTDelegatePickerView.h
//  DaYiProject
//
//  Created by monda on 2018/9/20.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MTDelegatePickerView : UIPickerView

@property(nonatomic,strong) UIColor* separatorColor;

- (void)addTarget:(id<UIPickerViewDataSource,UIPickerViewDelegate>)target EmptyData:(NSObject*)emptyData DataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList;

- (void)reloadDataWithDataList:(NSArray*)dataList EmptyData:(NSObject*)emptyData;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList;

- (void)reloadDataWithDataList:(NSArray*)dataList SectionList:(NSArray*)sectionList EmptyData:(NSObject*)emptyData;

@end

