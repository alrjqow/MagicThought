//
//  NSObject+ReuseIdentifier.m
//  MTEasyController
//
//  Created by monda on 2018/4/23.
//  Copyright © 2018年 monda. All rights reserved.
//

#import "NSObject+ReuseIdentifier.h"
#import "MJExtension.h"
#import "objc/runtime.h"
#import "NSString+Exist.h"

NSString* MTBanClickOrder = @"MTBanClickOrder";
NSString* MTBindNewObjectOrder = @"MTBindNewObjectOrder";

@implementation NSBindObject @end

@implementation NSReuseObject @end


@implementation NSObject (ReuseIdentifier)

-(void)setMt_order:(NSString *)mt_order
{
    objc_setAssociatedObject(self, @selector(mt_order), mt_order, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)mt_order
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setMt_click:(MTClick)mt_click
{
    objc_setAssociatedObject(self, @selector(mt_click), mt_click, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(MTClick)mt_click
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setMt_tagIdentifier:(NSString *)mt_tagIdentifier
{
    objc_setAssociatedObject(self, @selector(mt_tagIdentifier), mt_tagIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)mt_tagIdentifier
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setMt_reuseIdentifier:(NSString *)mt_reuseIdentifier
{
    objc_setAssociatedObject(self, @selector(mt_reuseIdentifier), mt_reuseIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)mt_reuseIdentifier
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setMt_itemHeight:(CGFloat)mt_itemHeight
{
    objc_setAssociatedObject(self, @selector(mt_itemHeight), @(mt_itemHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)mt_itemHeight
{
    NSNumber* height = objc_getAssociatedObject(self, _cmd);
    
    return height.floatValue;
}


-(void)setMt_itemSize:(CGSize)mt_itemSize
{
    objc_setAssociatedObject(self, @selector(mt_itemSize), [NSValue valueWithCGSize:mt_itemSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(CGSize)mt_itemSize
{
    NSValue* size = objc_getAssociatedObject(self, _cmd);
    
    return size ? size.CGSizeValue : CGSizeZero;
}

-(void)setMt_spacing:(MTDelegateCollectionViewSpacing)mt_spacing
{
    //结构体转换成对象
    objc_setAssociatedObject(self, @selector(mt_spacing), [NSValue valueWithBytes:&mt_spacing objCType:@encode(MTDelegateCollectionViewSpacing)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(MTDelegateCollectionViewSpacing)mt_spacing
{
    MTDelegateCollectionViewSpacing spacing = {0, 0, UIEdgeInsetsZero};
    NSValue* value = objc_getAssociatedObject(self, _cmd);
    [value getValue:&spacing];
    
    return spacing;
}

-(void)setMt_open3dTouch:(BOOL)mt_open3dTouch
{
    objc_setAssociatedObject(self, @selector(mt_open3dTouch), @(mt_open3dTouch), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)mt_open3dTouch
{
    NSNumber* open3dTouch = objc_getAssociatedObject(self, _cmd);
    
    return open3dTouch.boolValue;
}


-(void)setMt_headerEmptyShow:(BOOL)mt_headerEmptyShow
{
    objc_setAssociatedObject(self, @selector(mt_headerEmptyShow), @(mt_headerEmptyShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)mt_headerEmptyShow
{
    NSNumber* headerEmptyShow = objc_getAssociatedObject(self, _cmd);
    
    return headerEmptyShow.boolValue;
}

@end



@implementation NSObject (BindReuseIdentifier)

-(BindClick)bindClick
{
    __weak __typeof(self) weakSelf = self;
    BindClick bindClick  = ^(MTClick click){
        
        if(!click)
            return weakSelf;
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            {
                if(!obj.mt_click)
                    obj.mt_click = click;
            }
        }
        
        weakSelf.mt_click = click;
        return weakSelf;
    };
    
    return bindClick;
}

-(BindCount)bindCount
{
    __weak __typeof(self) weakSelf = self;
    BindCount bindCount  = ^(NSInteger count){
        
        NSMutableArray* arr = [NSMutableArray array];
        
        for(NSInteger i = 0; i < count; i++)
            [arr addObject:mt_reuse(weakSelf)];
        
        return [arr copy];
    };
    
    return bindCount;
}

-(BindReuseIdentifier)bind
{
    __weak __typeof(self) weakSelf = self;
    BindReuseIdentifier bind  = ^(NSString* reuseIdentifier){
        
        if(reuseIdentifier.length <= 0)
            return weakSelf;
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            {
                if(![obj.mt_reuseIdentifier isExist])
                    obj.mt_reuseIdentifier = reuseIdentifier;
            }
                
        }
        
        weakSelf.mt_reuseIdentifier = reuseIdentifier;
        return weakSelf;
    };
    
    return bind;
}

-(BindOrder)bindOrder
{
    __weak __typeof(self) weakSelf = self;
    BindOrder bindOrder  = ^(NSString* order){
        
        if(order.length <= 0)
            return weakSelf;
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            {
                if(![obj.mt_order isExist])
                    obj.mt_order = order;
            }
                            
            return weakSelf;
        }
        
        weakSelf.mt_order = order;
        return weakSelf;
    };
    
    return bindOrder;
}

-(BindNewObjectOrder)bindNewObjectOrder
{
    __weak __typeof(self) weakSelf = self;
       BindNewObjectOrder bindNewObjectOrder  = ^{
                      
           weakSelf.mt_order = MTBindNewObjectOrder;
           return weakSelf;
       };
       
       return bindNewObjectOrder;
}

-(BindTagIdentifier)bindTag
{
    __weak __typeof(self) weakSelf = self;
    BindTagIdentifier bindTag  = ^(NSString* tagIdentifier){
        
        if(tagIdentifier.length <= 0)
            return weakSelf;
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            {
                if(![obj.mt_tagIdentifier isExist])
                    obj.mt_tagIdentifier = tagIdentifier;
            }
                
            
            return weakSelf;
        }
        
        weakSelf.mt_tagIdentifier = tagIdentifier;
        return weakSelf;
    };
    
    return bindTag;
}

-(BindTagText)bindTagText
{
    __weak __typeof(self) weakSelf = self;
       BindTagText bindTagText  = ^(NSString* tagIdentifier){
           
           if(tagIdentifier.length <= 0)
               return weakSelf;
           
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
       
       return bindTagText;
}

-(BindArrayReuseIdentifier)arrBind
{
    __weak __typeof(self) weakSelf = self;
    BindArrayReuseIdentifier arrBind  = ^(NSString* reuseIdentifier){
        
        if(![weakSelf isKindOfClass:[NSArray class]])
            return weakSelf;
        
        weakSelf.mt_reuseIdentifier = reuseIdentifier;
        return weakSelf;
    };
    
    return arrBind;
}

-(BindRowHeight)bindHeight
{
    __weak __typeof(self) weakSelf = self;
    BindRowHeight bindHeight  = ^(CGFloat itemHeight){
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            {
                if(!obj.mt_itemHeight)
                    obj.mt_itemHeight = itemHeight;
            }
        }
        
        weakSelf.mt_itemHeight = itemHeight;
        return weakSelf;
    };
    
    return bindHeight;
}

-(BindRowsHeight)bindRowsHeight
{
    __weak __typeof(self) weakSelf = self;
    BindRowsHeight bindRowsHeight  = ^(NSArray<NSNumber*>* heights){
        
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
    
    return bindRowsHeight;
}

-(BindItemSize)bindSize
{
    __weak __typeof(self) weakSelf = self;
    BindItemSize bindSize  = ^(CGSize size){
        
        if([weakSelf isKindOfClass:[NSArray class]])
        {
            NSArray* arr = (NSArray*)weakSelf;
            for(NSObject* obj in arr)
            {
                if(CGSizeEqualToSize(CGSizeZero, obj.mt_itemSize))
                    obj.mt_itemSize = size;
            }
                
            return weakSelf;
        }
        
        weakSelf.mt_itemSize = size;
        return weakSelf;
    };
    
    return bindSize;
}

-(BindArrayItemSize)arrBindSize
{
    __weak __typeof(self) weakSelf = self;
    BindArrayItemSize bindSize  = ^(CGSize size){
        
        if(![weakSelf isKindOfClass:[NSArray class]])
            return weakSelf;
        
        weakSelf.mt_itemSize = size;
        return weakSelf;
    };
    
    return bindSize;
}

-(BindItemsSize)bindItemsSize
{
    __weak __typeof(self) weakSelf = self;
    BindItemsSize bindItemsSize  = ^(NSArray<NSValue*>* sizes){
        
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
    
    return bindItemsSize;
}


-(BindItemSpacing)bindSpacing
{
    __weak __typeof(self) weakSelf = self;
    BindItemSpacing bindSpacing  = ^(MTDelegateCollectionViewSpacing spacing){
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
    
    return bindSpacing;
}

-(BindItemsSpacing)bindItemsSpacing
{
    __weak __typeof(self) weakSelf = self;
    BindItemsSpacing bindItemsSpacing  = ^(NSArray<NSValue*>* itemSpacing){
        
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
    
    return bindItemsSpacing;
}

- (Bind3dTouch)bind3dTouch
{
    __weak __typeof(self) weakSelf = self;
    Bind3dTouch bind3dTouch  = ^(){
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
    
    return bind3dTouch;
}

-(BindHeaderEmptyShow)bindHeaderEmptyShow
{
    __weak __typeof(self) weakSelf = self;
    BindHeaderEmptyShow bindHeaderEmptyShow  = ^(){
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
    
    return bindHeaderEmptyShow;
}

- (instancetype)setWithObject:(NSObject*)obj{
    
    if([obj isKindOfClass:[NSBindObject class]])
    {
        [self copyBindWithObject:obj];
    }
    
    return self;
}
- (instancetype _Nullable)copyBindWithObject:(NSObject* _Nullable)obj
{
    self.bind(obj.mt_reuseIdentifier).bindClick(obj.mt_click).bindOrder(obj.mt_order).bindTag(obj.mt_tagIdentifier);
    return self;
}

-(MTSetWithObjects)setObjects
{
    __weak __typeof(self) weakSelf = self;
    MTSetWithObjects setObjects  = ^(NSObject* objects){
        
        if([objects isKindOfClass:[NSArray class]])
        {
            for (NSObject* obj in (NSArray*)objects)
            {
                [weakSelf setWithObject:obj];
            }
        }
        else
            [weakSelf setWithObject:objects];
                
        return weakSelf;
    };
    
    return setObjects;
}

@end





@implementation NSObject (Copy)

- (instancetype)copyObject
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




@implementation NSArray(ReuseIdentifier)

-(NSObject*)getDataByIndex:(NSInteger)index
{
    if(index >= self.count)
        return nil;
    
    NSObject* data = self[index];
    
    if(![data isKindOfClass:[NSObject class]])
        return nil;
    
    if(!data.mt_reuseIdentifier && [data isKindOfClass:[NSString class]])
        data.mt_reuseIdentifier = (NSString*)data;
    
    if(!data.mt_reuseIdentifier && [data isKindOfClass:[NSReuseObject class]] && [((NSReuseObject*)data).data isKindOfClass:[NSString class]])
        data.mt_reuseIdentifier = (NSString*)((NSReuseObject*)data).data;
    
    return data;
}


@end

