//
//  NSObject+ReuseIdentifier.m
//  MTEasyController
//
//  Created by monda on 2018/4/23.
//  Copyright © 2018年 monda. All rights reserved.
//

#import "NSObject+ReuseIdentifier.h"
#import "NSString+Exist.h"
#import "MJExtension.h"
#import "objc/runtime.h"

@implementation NSReuseObject

@end


@implementation NSObject (ReuseIdentifier)

static const void *mtObjectTagIdentifierKey = @"mtObjectTagIdentifierKey";
-(void)setMt_tagIdentifier:(NSString *)mt_tagIdentifier
{
    objc_setAssociatedObject(self, mtObjectTagIdentifierKey, mt_tagIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)mt_tagIdentifier
{
    NSString* tagIdentifier  = objc_getAssociatedObject(self, mtObjectTagIdentifierKey);
    
    return [tagIdentifier isExist] ? tagIdentifier : @"";
}

static const void *mtObjectReuseIdentifierKey = @"mtObjectReuseIdentifierKey";
-(void)setMt_reuseIdentifier:(NSString *)mt_reuseIdentifier
{
    objc_setAssociatedObject(self, mtObjectReuseIdentifierKey, mt_reuseIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)mt_reuseIdentifier
{
    NSString* reuseIdentifier  = objc_getAssociatedObject(self, mtObjectReuseIdentifierKey);
    
    return [reuseIdentifier isExist] ? reuseIdentifier : @"none";
}

static const void *mtItemHeightKey = @"mtItemHeightKey";
-(void)setMt_itemHeight:(CGFloat)mt_itemHeight
{
    objc_setAssociatedObject(self, mtItemHeightKey, @(mt_itemHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)mt_itemHeight
{
    NSNumber* height = objc_getAssociatedObject(self, mtItemHeightKey);
    
    return height.floatValue;
}


static const void *mtItemSizeKey = @"mtItemSizeKey";
-(void)setMt_itemSize:(CGSize)mt_itemSize
{
    objc_setAssociatedObject(self, mtItemSizeKey, [NSValue valueWithCGSize:mt_itemSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(CGSize)mt_itemSize
{
    NSValue* size = objc_getAssociatedObject(self, mtItemSizeKey);
    
    return size ? size.CGSizeValue : CGSizeZero;
}

static const void *mtSpacingKey = @"mtSpacingKey";
-(void)setMt_spacing:(MTDelegateCollectionViewSpacing)mt_spacing
{
    //结构体转换成对象
    objc_setAssociatedObject(self, mtSpacingKey, [NSValue valueWithBytes:&mt_spacing objCType:@encode(MTDelegateCollectionViewSpacing)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(MTDelegateCollectionViewSpacing)mt_spacing
{
    MTDelegateCollectionViewSpacing spacing = {0, 0, UIEdgeInsetsZero};
    NSValue* value = objc_getAssociatedObject(self, mtSpacingKey);
    [value getValue:&spacing];
    
    return spacing;
}

static const void *mtOpen3dTouchKey = @"mtOpen3dTouchKey";
-(void)setMt_open3dTouch:(BOOL)mt_open3dTouch
{
    objc_setAssociatedObject(self, mtOpen3dTouchKey, @(mt_open3dTouch), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)mt_open3dTouch
{
    NSNumber* open3dTouch = objc_getAssociatedObject(self, mtOpen3dTouchKey);
    
    return open3dTouch.boolValue;
}


static const void *mtHeaderEmptyShowKey = @"mtHeaderEmptyShowKey";
-(void)setMt_headerEmptyShow:(BOOL)mt_headerEmptyShow
{
    objc_setAssociatedObject(self, mtHeaderEmptyShowKey, @(mt_headerEmptyShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)mt_headerEmptyShow
{
    NSNumber* headerEmptyShow = objc_getAssociatedObject(self, mtHeaderEmptyShowKey);
    
    return headerEmptyShow.boolValue;
}

@end



@implementation NSObject (BandReuseIdentifier)

-(BandCount)bandCount
{
    __weak __typeof(self) weakSelf = self;
    BandCount bandCount  = ^(NSInteger count){
        
        NSMutableArray* arr = [NSMutableArray array];
        
        for(NSInteger i = 0; i < count; i++)            
        [arr addObject:mt_reuse(weakSelf)];
        
        return [arr copy];
    };
    
    return bandCount;
}

-(BandReuseIdentifier)band
{
    __weak __typeof(self) weakSelf = self;
    BandReuseIdentifier band  = ^(NSString* reuseIdentifier){
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            obj.mt_reuseIdentifier = reuseIdentifier;
            
            return weakSelf;
        }
        
        weakSelf.mt_reuseIdentifier = reuseIdentifier;
        return weakSelf;
    };
    
    return band;
}

-(BandTagIdentifier)bandTag
{
    __weak __typeof(self) weakSelf = self;
    BandTagIdentifier bandTag  = ^(NSString* tagIdentifier){
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
                obj.mt_tagIdentifier = tagIdentifier;
            
            return weakSelf;
        }
        
        weakSelf.mt_tagIdentifier = tagIdentifier;
        return weakSelf;
    };
    
    return bandTag;
}

-(BandArrayReuseIdentifier)arrBand
{
__weak __typeof(self) weakSelf = self;
BandArrayReuseIdentifier arrBand  = ^(NSString* reuseIdentifier){
    
    if(![weakSelf isKindOfClass:[NSArray class]])
        return weakSelf;
    
    weakSelf.mt_reuseIdentifier = reuseIdentifier;
    return weakSelf;
};

return arrBand;
}

-(BandRowHeight)bandHeight
{
    __weak __typeof(self) weakSelf = self;
    BandRowHeight bandHeight  = ^(CGFloat itemHeight){
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            obj.mt_itemHeight = itemHeight;
            
            return weakSelf;
        }
        
        weakSelf.mt_itemHeight = itemHeight;
        return weakSelf;
    };
    
    return bandHeight;
}

-(BandRowsHeight)bandRowsHeight
{
    __weak __typeof(self) weakSelf = self;
    BandRowsHeight bandRowsHeight  = ^(NSArray<NSNumber*>* heights){
        
        if(![weakSelf isKindOfClass:[NSArray class]])
        return weakSelf;
        
        NSArray* arr = (NSArray*)weakSelf;
        for(NSInteger i = 0; i < arr.count; i++)
        {
            if(i >= heights.count)
            break;
            
            if(![arr[i] isKindOfClass:[NSObject class]])
            continue;
            
            NSObject* obj =arr[i];
            obj.mt_itemHeight = heights[i].floatValue;
        }
        return weakSelf;
        
    };
    
    return bandRowsHeight;
}

-(BandItemSize)bandSize
{
    __weak __typeof(self) weakSelf = self;
    BandItemSize bandSize  = ^(CGSize size){
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            obj.mt_itemSize = size;
            
            return weakSelf;
        }
        
        weakSelf.mt_itemSize = size;
        return weakSelf;
    };
    
    return bandSize;
}

-(BandArrayItemSize)arrBandSize
{
__weak __typeof(self) weakSelf = self;
BandArrayItemSize bandSize  = ^(CGSize size){
    
    if(![weakSelf isKindOfClass:[NSArray class]])
        return weakSelf;
    
    weakSelf.mt_itemSize = size;
    return weakSelf;
};

return bandSize;
}

-(BandItemsSize)bandItemsSize
{
    __weak __typeof(self) weakSelf = self;
    BandItemsSize bandItemsSize  = ^(NSArray<NSValue*>* sizes){
        
        if(![weakSelf isKindOfClass:[NSArray class]])
        return weakSelf;
        
        NSArray* arr = (NSArray*)weakSelf;
        for(NSInteger i = 0; i < arr.count; i++)
        {
            if(i >= sizes.count)
            break;
            
            if(![arr[i] isKindOfClass:[NSObject class]])
            continue;
            
            NSObject* obj =arr[i];
            obj.mt_itemSize = sizes[i].CGSizeValue;
        }
        return weakSelf;
        
    };
    
    return bandItemsSize;
}


-(BandItemSpacing)bandSpacing
{
    __weak __typeof(self) weakSelf = self;
    BandItemSpacing bandSpacing  = ^(MTDelegateCollectionViewSpacing spacing){
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            obj.mt_spacing = spacing;
            
            return weakSelf;
        }
        
        weakSelf.mt_spacing = spacing;
        return weakSelf;
    };
    
    return bandSpacing;
}

-(BandItemsSpacing)bandItemsSpacing
{
    __weak __typeof(self) weakSelf = self;
    BandItemsSpacing bandItemsSpacing  = ^(NSArray<NSValue*>* itemSpacing){
        
        if(![weakSelf isKindOfClass:[NSArray class]])
        return weakSelf;
        
        NSArray* arr = (NSArray*)weakSelf;
        for(NSInteger i = 0; i < arr.count; i++)
        {
            if(i >= itemSpacing.count)
            break;
            
            if(![arr[i] isKindOfClass:[NSObject class]])
            continue;
            
            MTDelegateCollectionViewSpacing spacing = {0, 0, UIEdgeInsetsZero};
            [itemSpacing[i] getValue:&spacing];
            
            NSObject* obj =arr[i];
            obj.mt_spacing = spacing;
        }
        return weakSelf;
        
    };
    
    return bandItemsSpacing;
}

- (Band3dTouch)band3dTouch
{
__weak __typeof(self) weakSelf = self;
Band3dTouch band3dTouch  = ^(){
    if([weakSelf isKindOfClass:[NSArray class]])
    {
        NSArray* arr = (NSArray*)weakSelf;
        for(NSObject* obj in arr)
        obj.mt_open3dTouch = YES;
        
        return weakSelf;
    }
    
    weakSelf.mt_open3dTouch = YES;
    return weakSelf;
};

return band3dTouch;
}

-(BandHeaderEmptyShow)bandHeaderEmptyShow
{
__weak __typeof(self) weakSelf = self;
BandHeaderEmptyShow bandHeaderEmptyShow  = ^(){
    if([weakSelf isKindOfClass:[NSArray class]])
    {
        NSArray* arr = (NSArray*)weakSelf;
        for(NSObject* obj in arr)
            obj.mt_headerEmptyShow = YES;
        
        return weakSelf;
    }
    
    weakSelf.mt_headerEmptyShow = YES;
    return weakSelf;
};

return bandHeaderEmptyShow;
}

@end





@implementation NSObject (Copy)

- (NSObject*)copyObject
{
    return  [[self class] mj_objectWithKeyValues:[self mj_keyValues]];
}

- (BOOL)isContainProperty:(NSString*)propertyName
{
    Class myClass = [self class];
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++)
    {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSLog(@"%@",keyName);
        if ([keyName isEqualToString:propertyName])
        return YES;
    }
    return NO;
}

@end



MTDelegateCollectionViewSpacing mt_collectionViewSpacingMake(CGFloat minLineSpacing, CGFloat minItemSpacing,UIEdgeInsets sectionInset)
{
MTDelegateCollectionViewSpacing spacing = {minLineSpacing, minItemSpacing, sectionInset};
return spacing;
}


NSReuseObject* mt_reuse(id data)
{
NSReuseObject* obj = [NSReuseObject new];
obj.data = data;

return obj;
}
