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
    [super setWithObject:obj];
    
    if([obj.mt_tagIdentifier isExist])
    {
        [self mj_setKeyValues:@{obj.mt_tagIdentifier : obj}];
        obj.mt_tagIdentifier = nil;
        return self;
    }
                        
    NSDictionary* dict;
    if([obj isKindOfClass:[NSDictionary class]])
        dict = (NSDictionary*)obj;
    else if([obj isKindOfClass:[NSString class]])
        dict = @{@"text" : obj};
    else if([obj isKindOfClass:[UIImage class]])
        dict = @{@"image" : obj};
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

+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    if([keyValues isKindOfClass:self])
        return keyValues;
    return [super mj_objectWithKeyValues:keyValues context:context];
}

-(void)setMt_tagIdentifier:(NSString *)mt_tagIdentifier
{
    if([self.mt_tagIdentifier isEqualToString:mt_tagIdentifier])
        return;
    
    [super setMt_tagIdentifier:mt_tagIdentifier];
    self.text = mt_tagIdentifier;
}

@end

@implementation MTBaseViewContentStateModel @end

MTBaseViewContentModel* _Nonnull mt_highlighted(MTBaseViewContentModel* _Nullable model)
{return (MTBaseViewContentModel*)model.bindTag(@"highlighted");}

MTBaseViewContentModel* _Nonnull mt_disabled(MTBaseViewContentModel* _Nullable model)
{return (MTBaseViewContentModel*)model.bindTag(@"disabled");}

MTBaseViewContentModel* _Nonnull mt_selected(MTBaseViewContentModel* _Nullable model)
{return (MTBaseViewContentModel*)model.bindTag(@"selected");}

NSString* _Nonnull mt_css(NSString* _Nullable str)
{return (NSString*)str.bindTag(@"cssClass");}

UIColor* _Nonnull mt_textColor(UIColor* _Nullable color)
{return (UIColor*)color.bindTag(@"textColor");}

NSObject* _Nonnull mt_image_bg(NSObject* _Nullable img_bg)
{return img_bg.bindTag(@"image_bg");}



@implementation MTBaseViewContentModel(MJExtension)

-(NSMutableDictionary *)mj_keyValues
{
    NSMutableDictionary* dict = [super mj_keyValues];
    dict[@"backgroundColor"] = self.backgroundColor;
    dict[@"textColor"] = self.textColor;
    dict[@"image"] = self.image;
    dict[@"image_bg"] = self.image_bg;
    return dict;
}

@end
