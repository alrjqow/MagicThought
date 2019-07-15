//
//  MTDelegateTableCollectionViewCell.h
//  8kqw
//
//  Created by 王奕聪 on 2017/8/31.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateTableViewCell.h"

@interface MTDelegateTableCollectionViewCell : MTDelegateTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionViewLayout* collectionViewLayout;

@property(nonatomic, strong, readonly) UICollectionView* collectionView;

@end
