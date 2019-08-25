//
//  MTTenScrollModel.h
//  DaYiProject
//
//  Created by monda on 2018/12/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTenScrollTitleViewModel.h"
#import "MTDelegateProtocol.h"


extern NSString* MTTenScrollIdentifier;

@class MTTenScrollContentView;
@class MTTenScrollTitleView;
@class MTTenScrollView;

@interface MTTenScrollModel : NSObject

@property (nonatomic,weak) NSObject<MTDelegateViewDataProtocol>* delegate;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) NSArray* dataList;

@property (nonatomic,strong,readonly) NSArray* titleList;

@property (nonatomic,weak) MTTenScrollView* tenScrollView;

@property (nonatomic,weak) MTTenScrollView* superTenScrollView;

@property (nonatomic,weak) MTTenScrollContentView* contentView;

@property (nonatomic,weak) MTTenScrollTitleView* titleView;

@property (nonatomic,strong) MTTenScrollTitleViewModel* titleViewModel;

@property (nonatomic,weak) UIScrollView* currentView;

@property (nonatomic,assign) CGFloat tenScrollHeight;

@property (nonatomic,strong, readonly) NSObject* tenScrollData;

/**最大索引*/
@property (nonatomic,assign, readonly) NSInteger maxIndex;

/**contentView是否有被拖拽*/
@property (nonatomic,assign) BOOL isContentViewDragging;

/**contentView固定的偏移值*/
@property (nonatomic,assign) CGFloat contentViewFixOffset;

/**tenScrollView固定的偏移值*/
@property (nonatomic,assign) BOOL isChangeTenScrollViewMaxOffsetY;
@property (nonatomic,assign, readonly) NSInteger tenScrollViewMaxOffsetY;
@property (nonatomic,assign, readonly) NSInteger tenScrollViewMaxOffsetY2;

-(MTTenScrollModel*)getSubModel:(MTTenScrollModel*)model;

-(void)fixTenScrollViewScroll;

-(void)fixTenScrollTableViewScroll;

-(UIView*)getViewByIndex:(NSInteger)index;

-(void)tenScrollViewWillBeginDragging;

-(void)tenScrollViewDidScroll;

-(void)tenScrollViewEndScroll;

-(void)titleViewWillBeginDragging;

-(void)titleViewDidScroll;

-(void)didTitleViewEndScroll;

-(void)didTitleViewSelectedItem;

-(void)didContentViewEndScrollWithDecelerate:(BOOL)decelerate;

-(void)contentViewWillBeginDragging;

-(void)contentViewDidScroll;

@end


