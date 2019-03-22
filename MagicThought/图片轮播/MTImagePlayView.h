//
//  MTImagePlayView.h
//  8kqw
//
//  Created by 王奕聪 on 2017/4/7.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTDelegateView.h"

@interface MTImagePlayView : MTDelegateView

@property (weak, nonatomic)  UIPageControl *pagePoint;

@property (weak, nonatomic, readonly)  UICollectionView *collectionView;

@property (nonatomic,weak) id<UICollectionViewDelegate,UICollectionViewDataSource> playViewDelegate;

@property (nonatomic, strong) NSArray<NSString*>* imageURLs;

@property(nonatomic,strong) UIImage* placeholderImage;

@property(nonatomic,assign) CGFloat scrollTime;

@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;

/**是否滚动有限*/
@property (nonatomic,assign) BOOL isScrollLimit;

/**是否关闭自动滚动*/
@property (nonatomic,assign) BOOL isStopTimer;

@end
