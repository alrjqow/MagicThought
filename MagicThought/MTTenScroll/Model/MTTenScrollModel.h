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

@property (nonatomic,strong,readonly) NSObject* tenScrollData;

/**contentView是否有被拖拽*/
@property (nonatomic,assign,readonly) BOOL isContentViewDragging;

@property (nonatomic,weak) UIScrollView* currentView;

@property (nonatomic,strong) MTTenScrollTitleViewModel* titleViewModel;

@property (nonatomic,assign) CGFloat tenScrollHeight;

/**contentView固定的偏移值*/
@property (nonatomic,assign) CGFloat contentViewFixOffset;

/**titleView固定的偏移值*/
@property (nonatomic,assign) CGFloat titleViewFixOffset;

@property (nonatomic,strong) NSMutableDictionary* subModelList;

/**固定样式*/
@property (nonatomic,assign) BOOL wordStyleChange;

/**tenScrollView固定的偏移值*/
@property (nonatomic,assign, readonly) NSInteger tenScrollViewMaxOffsetY;
@property (nonatomic,assign, readonly) NSInteger tenScrollViewMaxOffsetY2;

-(MTTenScrollModel*)getSubModel:(MTTenScrollModel*)model;

-(UIView*)getViewByIndex:(NSInteger)index;

-(void)tenScrollTableViewScrollDidScroll;

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


