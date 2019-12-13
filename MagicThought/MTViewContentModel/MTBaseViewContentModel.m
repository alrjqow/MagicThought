//
//  MTBaseViewContentModel.m
//  QXProject
//
//  Created by monda on 2019/12/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseViewContentModel.h"
#import <MJExtension.h>
#import "NSObject+ReuseIdentifier.h"

@interface CSSString : NSReuseObject  @end
@implementation CSSString @end

@interface ButtonTextColor : NSReuseObject  @end
@implementation ButtonTextColor @end

@interface ButtonImage : NSReuseObject  @end
@implementation ButtonImage @end

@interface ButtonBgImage : NSReuseObject  @end
@implementation ButtonBgImage @end

@implementation MTBaseViewContentModel

-(instancetype)init
{
    if(self = [super init])
    {
        [self setupDefault];
    }
    
    return self;
}

-(instancetype)setWithObject:(NSObject *)obj
{
    NSDictionary* dict;
    if([obj isKindOfClass:[NSDictionary class]])
        dict = (NSDictionary*)obj;
    else if([obj isKindOfClass:[NSString class]])
        dict = @{@"text" : obj};
    else if([obj isKindOfClass:[MTWordStyle class]])
        dict = @{@"wordStyle" : obj};
    else if([obj isKindOfClass:[MTBorderStyle class]])
        dict = @{@"borderStyle" : obj};
    else if([obj isKindOfClass:[CSSString class]])
    {
        id data = ((NSReuseObject*)obj).data;
        if(data)
            dict = @{@"cssClass" : data};
    }
    else if([obj isKindOfClass:[UIColor class]])
        dict = @{@"backgroundColor" : obj};
    else if([obj isKindOfClass:[MTBaseViewContentModel class]])
        dict = obj.mj_keyValues;
    
    return [self mj_setKeyValues:dict];
}

@end

@implementation MTBaseButtonContentModel

-(instancetype)setWithObject:(NSObject *)obj
{
    [super setWithObject:obj];
    
    NSDictionary* dict;
    if([obj isKindOfClass:[NSReuseObject class]])
    {
        id data = ((NSReuseObject*)obj).data;
        if(data)
        {
            NSString* key;
            if([obj isKindOfClass:[ButtonTextColor class]])
                key = @"textColor";
            else if([obj isKindOfClass:[ButtonImage class]])
                key = @"image";
            else if([obj isKindOfClass:[ButtonBgImage class]])
                key = @"image_bg";
            
            if(key)
                dict = @{key : data};
        }
    }
    
    return [self mj_setKeyValues:dict];
}

@end




NSObject* mt_css(NSString* str)
{
    return CSSString.new(str);
}

NSObject* _Nonnull mt_btnTextColor(UIColor* _Nullable color)
{
    return ButtonTextColor.new(color);
}

NSObject* _Nonnull mt_Img(NSObject* _Nullable img, NSString* className)
{
    Class c = NSClassFromString(className);
    
    if(![c isSubclassOfClass: [NSReuseObject class]])
        return [NSObject new];
    
    NSObject* obj = [c new];
    return obj.setObjects(img);
}


NSObject* _Nonnull mt_btnImg(NSObject* _Nullable img)
{
    return mt_Img(img, @"ButtonImage");
}

NSObject* _Nonnull mt_btnImg_bg(NSObject* _Nullable img_bg)
{
    return mt_Img(img_bg, @"ButtonBgImage");
}
