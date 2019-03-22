//
//  MTDataSource.h
//  MonDaProject
//
//  Created by monda on 2018/6/15.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"

@interface MTDataSource : NSObject<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,weak) id<MTDelegateProtocol, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate> delegate;

@property (nonatomic,strong) NSArray* dataList;

@property (nonatomic,strong) NSArray* sectionList;

@property (nonatomic,strong) NSObject* emptyData;

@end
