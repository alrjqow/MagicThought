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

@interface NSBindObject : NSObject @end

@interface NSReuseObject : NSObject

@property (nonatomic,strong) id _Nullable data;

@end

CG_EXTERN NSString* _Nonnull MTBanClickOrder;
CG_EXTERN NSString* _Nonnull MTBindNewObjectOrder;

CG_EXTERN MTDelegateCollectionViewSpacing mt_collectionViewSpacingMake(CGFloat minLineSpacing, CGFloat minItemSpacing,UIEdgeInsets sectionInset);

CG_EXTERN NSReuseObject* _Nonnull mt_reuse(id _Nullable data);

#define mt_bind NSBindObject.new

#define mt_content(...) MTBaseViewContentModel.new(__VA_ARGS__)
#define mt_stateContent(...) MTBaseViewContentStateModel.new(__VA_ARGS__)
#define new(...) new.setObjects(@[__VA_ARGS__])

typedef BOOL (^MTClick)(NSString* _Nullable order);

@interface NSObject (ReuseIdentifier)

@property (nonatomic,strong) NSString* _Nullable mt_order;

@property (nonatomic,strong) NSString* _Nullable mt_tagIdentifier;

@property (nonatomic,strong) NSString* _Nullable mt_reuseIdentifier;

@property (nonatomic,assign) CGFloat mt_itemHeight;

@property (nonatomic,assign) CGSize mt_itemSize;
    
@property (nonatomic,assign) MTDelegateCollectionViewSpacing mt_spacing;

@property (nonatomic,assign) BOOL mt_open3dTouch;

@property (nonatomic,assign) BOOL mt_headerEmptyShow;

@property (nonatomic,copy) MTClick _Nullable mt_click;

@end

typedef NSObject* _Nonnull (^BindNewObjectOrder) (void);
typedef NSObject* _Nonnull (^BindOrder) (NSString* _Nonnull order);
typedef NSObject* _Nonnull (^BindTagIdentifier) (NSString* _Nonnull tagIdentifier);
typedef id _Nonnull (^BindTagText) (NSString* _Nonnull tagIdentifier);
typedef  NSObject* _Nonnull  (^BindReuseIdentifier) (NSString* _Nonnull reuseIdentifier);
typedef NSObject* _Nonnull (^BindArrayReuseIdentifier) (NSString* _Nonnull reuseIdentifier);
typedef NSObject* _Nonnull (^BindRowHeight) (CGFloat height);
typedef NSObject* _Nonnull (^BindRowsHeight) (NSArray<NSNumber*>* _Nonnull heights);
typedef NSArray* _Nonnull (^BindCount) (NSInteger count);
typedef NSObject* _Nonnull (^BindItemSize) (CGSize itemSize);
typedef NSObject* _Nonnull (^BindArrayItemSize) (CGSize itemSize);
typedef NSObject* _Nonnull (^BindItemsSize) (NSArray<NSValue*>* _Nonnull itemSize);
typedef NSObject* _Nonnull (^BindItemSpacing) (MTDelegateCollectionViewSpacing spacing);
typedef NSObject* _Nonnull (^BindItemsSpacing) (NSArray<NSValue*>* _Nonnull spacing);
typedef NSObject* _Nonnull (^Bind3dTouch) (void);
typedef NSObject* _Nonnull (^BindHeaderEmptyShow) (void);
typedef NSObject* _Nonnull (^BindClick) (MTClick _Nullable);
typedef id _Nonnull (^MTSetWithObjects) (NSObject* _Nullable objects);

@interface NSObject (BindReuseIdentifier)

@property (nonatomic,copy,readonly) BindClick _Nonnull bindClick;

@property (nonatomic,copy,readonly) BindOrder _Nonnull bindOrder;

@property (nonatomic,copy,readonly) BindNewObjectOrder _Nonnull bindNewObjectOrder;

@property (nonatomic,copy,readonly) BindTagText _Nonnull bindTagText;
@property (nonatomic,copy,readonly) BindTagIdentifier _Nonnull bindTag;

@property (nonatomic,copy,readonly) BindCount _Nonnull bindCount;

@property (nonatomic,copy,readonly) BindReuseIdentifier _Nonnull bind;

@property (nonatomic,copy,readonly) BindArrayReuseIdentifier _Nonnull arrBind;

@property (nonatomic,copy,readonly) BindRowHeight _Nonnull bindHeight;

@property (nonatomic,copy,readonly) BindRowsHeight _Nonnull bindRowsHeight;

@property (nonatomic,copy,readonly) BindItemSize _Nonnull bindSize;

@property (nonatomic,copy,readonly) BindArrayItemSize _Nonnull arrBindSize;

@property (nonatomic,copy,readonly) BindItemsSize _Nonnull bindItemsSize;

@property (nonatomic,copy,readonly) BindItemSpacing _Nonnull bindSpacing;

@property (nonatomic,copy,readonly) BindItemsSpacing _Nonnull bindItemsSpacing;
    
@property (nonatomic,copy,readonly) Bind3dTouch _Nonnull bind3dTouch;

@property (nonatomic,copy,readonly) BindHeaderEmptyShow _Nonnull bindHeaderEmptyShow;

@property (nonatomic,copy,readonly) MTSetWithObjects _Nonnull setObjects;
- (instancetype _Nullable)setWithObject:(NSObject* _Nullable)obj;
- (instancetype _Nullable)copyBindWithObject:(NSObject* _Nullable)obj;
@end

@interface NSObject (Copy)

- (instancetype _Nullable)copyObject;

- (BOOL)isContainProperty:(NSString* _Nullable)propertyName;

@end



@interface NSArray (ReuseIdentifier)

-(NSObject* _Nonnull)getDataByIndex:(NSInteger)index;

@end
