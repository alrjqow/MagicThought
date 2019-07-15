//
//  MTBaseAlertCollectionController.h
//  SimpleProject
//
//  Created by monda on 2019/6/14.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseAlertGroupController.h"

#import "MTDragCollectionView.h"

@interface MTBaseAlertCollectionController : MTBaseAlertGroupController<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) MTDragCollectionView* collectionView;


@end


