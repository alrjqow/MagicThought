//
//  MTTenScrollModel.h
//  DaYiProject
//
//  Created by monda on 2018/12/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTenScrollTitleViewModel.h"

extern NSString* MTTenScrollIdentifier;

@class MTTenScrollContentView;
@class MTTenScrollTitleView;
@class MTTenScrollView;

@interface MTTenScrollModel : NSObject

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) NSArray* dataList;

@property (nonatomic,strong,readonly) NSArray* titleList;

@property (nonatomic,weak) MTTenScrollView* tenScrollView;

@property (nonatomic,weak) MTTenScrollView* superTenScrollView;

@property (nonatomic,weak) MTTenScrollContentView* contentView;

@property (nonatomic,weak) MTTenScrollTitleView* titleView;

@property (nonatomic,strong) MTTenScrollTitleViewModel* titleViewModel;

@property (nonatomic,assign,readonly) BOOL isContentViewScrollEnd;

@property (nonatomic,weak) UIScrollView* currentView;

@property (nonatomic,assign) CGFloat tenScrollHeight;

@property (nonatomic,strong, readonly) NSObject* tenScrollData;

/**最大索引*/
@property (nonatomic,assign, readonly) NSInteger maxIndex;

/**即时索引*/
@property (nonatomic,assign) NSInteger immediateIndex;

/**之前的index*/
@property (nonatomic,assign) NSInteger preIndex;

/**是否减速*/
@property (nonatomic,assign) BOOL isDecelerate;



-(UIView*)getViewByIndex:(NSInteger)index;

-(void)titleViewWillBeginDragging;

-(void)titleViewDidScroll;

-(void)didTitleViewEndScroll;

-(void)didTitleViewSelectedItem;

-(void)didContentViewEndScrollWithDecelerate:(BOOL)decelerate;

-(void)contentViewWillBeginDragging;

-(void)contentViewDidScroll;

@end


