//
//  NSObject+ReuseIdentifier.h
//  MTEasyController
//
//  Created by monda on 2018/4/23.
//  Copyright © 2018年 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
{
    CGFloat minLineSpacing;
    CGFloat minItemSpacing;
    UIEdgeInsets sectionInset;
} MTDelegateCollectionViewSpacing;

CG_EXTERN MTDelegateCollectionViewSpacing mt_collectionViewSpacingMake(CGFloat minLineSpacing, CGFloat minItemSpacing,UIEdgeInsets sectionInset);

@interface NSReuseObject : NSObject

@property (nonatomic,strong) id data;

@end

CG_EXTERN NSReuseObject* mt_reuse(id data);

@interface NSObject (ReuseIdentifier)

@property (nonatomic,strong) NSString* mt_tagIdentifier;

@property (nonatomic,strong) NSString* mt_reuseIdentifier;

@property (nonatomic,assign) CGFloat mt_itemHeight;

@property (nonatomic,assign) CGSize mt_itemSize;
    
@property (nonatomic,assign) MTDelegateCollectionViewSpacing mt_spacing;

@property (nonatomic,assign) BOOL mt_open3dTouch;

@property (nonatomic,assign) BOOL mt_headerEmptyShow;

@end


typedef NSObject* (^BandTagIdentifier) (NSString* tagIdentifier);
typedef NSObject* (^BandReuseIdentifier) (NSString* reuseIdentifier);
typedef NSObject* (^BandArrayReuseIdentifier) (NSString* reuseIdentifier);
typedef NSObject* (^BandRowHeight) (CGFloat height);
typedef NSObject* (^BandRowsHeight) (NSArray<NSNumber*>* heights);
typedef NSArray* (^BandCount) (NSInteger count);
typedef NSObject* (^BandItemSize) (CGSize itemSize);
typedef NSObject* (^BandArrayItemSize) (CGSize itemSize);
typedef NSObject* (^BandItemsSize) (NSArray<NSValue*>* itemSize);
typedef NSObject* (^BandItemSpacing) (MTDelegateCollectionViewSpacing spacing);
typedef NSObject* (^BandItemsSpacing) (NSArray<NSValue*>* spacing);
typedef NSObject* (^Band3dTouch) (void);
typedef NSObject* (^BandHeaderEmptyShow) (void);


@interface NSObject (BandReuseIdentifier)

@property (nonatomic,copy,readonly)  BandTagIdentifier bandTag;

@property (nonatomic,copy,readonly)  BandCount bandCount;

@property (nonatomic,copy,readonly)  BandReuseIdentifier band;

@property (nonatomic,copy,readonly)  BandArrayReuseIdentifier arrBand;

@property (nonatomic,copy,readonly)  BandRowHeight bandHeight;

@property (nonatomic,copy,readonly)  BandRowsHeight bandRowsHeight;

@property (nonatomic,copy,readonly)  BandItemSize bandSize;

@property (nonatomic,copy,readonly)  BandArrayItemSize arrBandSize;

@property (nonatomic,copy,readonly)  BandItemsSize bandItemsSize;

@property (nonatomic,copy,readonly)  BandItemSpacing bandSpacing;

@property (nonatomic,copy,readonly)  BandItemsSpacing bandItemsSpacing;
    
@property (nonatomic,copy,readonly)  Band3dTouch band3dTouch;

@property (nonatomic,copy,readonly)  BandHeaderEmptyShow bandHeaderEmptyShow;


@end

@interface NSObject (Copy)

- (NSObject*)copyObject;

- (BOOL)isContainProperty:(NSString*)propertyName;

@end



