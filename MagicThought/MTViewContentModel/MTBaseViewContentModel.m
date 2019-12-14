//
//  MTBaseViewContentModel.m
//  QXProject
//
//  Created by monda on 2019/12/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseViewContentModel.h"
#import <MJExtension.h>
#import "NSString+Exist.h"

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
    if(obj && [obj.mt_tagIdentifier isExist])
        return [self mj_setKeyValues:@{obj.mt_tagIdentifier : obj}];
    
    NSDictionary* dict;
    if([obj isKindOfClass:[NSDictionary class]])
        dict = (NSDictionary*)obj;
    else if([obj isKindOfClass:[NSString class]])
        dict = @{@"text" : obj};
    else if([obj isKindOfClass:[MTWordStyle class]])
        dict = @{@"wordStyle" : obj};
    else if([obj isKindOfClass:[MTBorderStyle class]])
        dict = @{@"borderStyle" : obj};
    else if([obj isKindOfClass:[UIColor class]])
        dict = @{@"backgroundColor" : obj};
    else if([obj isKindOfClass:[MTBaseViewContentModel class]])
        dict = obj.mj_keyValues;
    
    return [self mj_setKeyValues:dict];
}

@end

@implementation MTBaseButtonContentModel @end

NSString* _Nonnull mt_css(NSString* _Nullable str)
{
    return (NSString*)str.bindTag(@"cssClass");
}

UIColor* _Nonnull mt_btnTextColor(UIColor* _Nullable color)
{
    return (UIColor*)color.bindTag(@"textColor");
}

NSObject* _Nonnull mt_Img(NSObject* _Nullable img, NSString* identifier)
{
    return img.bindTag(identifier);
}


NSObject* _Nonnull mt_btnImg(NSObject* _Nullable img)
{
    return mt_Img(img, @"image");
}

NSObject* _Nonnull mt_btnImg_bg(NSObject* _Nullable img_bg)
{
    return mt_Img(img_bg, @"image_bg");
}
