//
//  MTDragCollectionView.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/19.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateCollectionView.h"

@interface MTDragCollectionView : MTDelegateCollectionView

@property(nonatomic,weak) NSMutableArray* dragItems;

@end
