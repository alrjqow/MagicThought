//
//  MTDelegateCollectionReusableView.h
//  MonDaProject
//
//  Created by monda on 2018/6/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"



@interface MTDelegateCollectionReusableView : UICollectionReusableView
        
@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;
    
@property(nonatomic,assign) NSInteger section;
    
@property (nonatomic,assign) CGFloat marginBottom;
@property (nonatomic,assign) CGFloat marginTop;
@property (nonatomic,assign) CGFloat marginLeft;
@property (nonatomic,assign) CGFloat marginRight;
    
-(void)setupDefault;
    
    /**当接收到数据*/
-(void)whenGetResponseObject:(NSObject*)object;
    
    
    
    @end



