//
//  MTDelegateCollectionReusableView.h
//  MonDaProject
//
//  Created by monda on 2018/6/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Delegate.h"


@interface MTDelegateCollectionReusableView : UICollectionReusableView
        
@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;
    
@property(nonatomic,assign) NSInteger section;

    
    
@end



