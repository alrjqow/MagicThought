//
//  MTPopButtonItem.h
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MTPopButtonItemHandler)(NSInteger index);

typedef NS_ENUM(NSUInteger, MTPopButtonItemType) {
    MTPopButtonItemTypeNormal,
    MTPopButtonItemTypeHighlight,
    MTPopButtonItemTypeDisabled
};

@class MTWordStyle;
@interface MTPopButtonItem : NSObject

@property (nonatomic, assign) BOOL     highlight;

@property (nonatomic,strong) MTWordStyle* word;

@property (nonatomic,strong) NSString* order;

@property (nonatomic,strong) UIColor* backgroundColor;

@property (nonatomic,assign) BOOL isCustom;


@property (nonatomic, assign) BOOL     disabled;

@property (nonatomic, copy)   MTPopButtonItemHandler handler;

@end

CG_EXTERN MTPopButtonItem* MTPopButtonItemMakeCustom(MTWordStyle* word, UIColor* backgroundColor, NSString* order);

CG_EXTERN MTPopButtonItem* MTPopButtonItemMake(NSString* title, BOOL isHighlight, NSString* order);

CG_EXTERN MTPopButtonItem* MTPopButtonItemMakeWithHandler(NSString* title, MTPopButtonItemType type, MTPopButtonItemHandler handler);
