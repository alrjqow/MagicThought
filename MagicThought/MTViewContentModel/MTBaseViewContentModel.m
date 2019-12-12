//
//  MTBaseViewContentModel.m
//  QXProject
//
//  Created by monda on 2019/12/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseViewContentModel.h"
#import <MJExtension.h>

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
        dict = @{@"cssClass" : obj};
    else if([obj isKindOfClass:[UIColor class]])
        dict = @{@"backgroundColor" : obj};
    else if([obj isKindOfClass:[MTBaseViewContentModel class]])
        dict = obj.mj_keyValues;
    
    return [self mj_setKeyValues:dict];
}

@end

@implementation MTBaseButtonContentModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if(![oldValue isKindOfClass:[NSString class]])
        return oldValue;
    if(![property.srcClass isKindOfClass:[UIImage class]])
        return oldValue;
    
    return [UIImage imageNamed:oldValue];
}

@end




@implementation CSSString @end

CSSString* mt_css(NSString* str)
{
    return [CSSString stringWithFormat:@"%@", str];
}
