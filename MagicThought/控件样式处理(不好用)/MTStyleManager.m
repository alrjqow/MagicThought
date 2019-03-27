//
//  MTStyleManager.m
//  DaYiProject
//
//  Created by monda on 2018/11/23.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTStyleManager.h"
#import "NSObject+Style.h"

NSString* mt_style = @"mt_style";
NSString* mt_extend = @"mt_extend";
NSString* mt_parent = @"mt_parent";
NSString* mt_delete = @"mt_delete";


@interface NSDictionary (Style)

-(NSDictionary*)findStyleWithName:(NSString*)name;

@end


@implementation MTStyle


-(void)configStyleWithObject:(NSObject*)obj
{
    if([obj isKindOfClass:[UITableView class]])
    {
        if([self.styleManager respondsToSelector:@selector(didSetTableView:WithStyle:)])
            [self.styleManager didSetTableView:(UITableView*)obj WithStyle:[self.tableViewStyle findStyleWithName:obj.mt_styleIdentifier]];
    }
    else if([obj isKindOfClass:[UIViewController class]])
    {
        if([self.styleManager respondsToSelector:@selector(didSetController:WithStyle:)])
            [self.styleManager didSetController:(UIViewController*)obj WithStyle:[self.controllerStyle findStyleWithName:obj.mt_styleIdentifier]];
    }
    else if([obj isKindOfClass:[UIButton class]])
    {
        if([self.styleManager respondsToSelector:@selector(didSetButton:WithStyle:)])
            [self.styleManager didSetButton:(UIButton*)obj WithStyle:[self.buttonStyle findStyleWithName:obj.mt_styleIdentifier]];
    }
    else if([obj isKindOfClass:[UILabel class]])
    {
        if([self.styleManager respondsToSelector:@selector(didSetLabel:WithStyle:)])
            [self.styleManager didSetLabel:(UILabel*)obj WithStyle:[self.labelStyle findStyleWithName:obj.mt_styleIdentifier]];
    }
    
}


#pragma mark - 懒加载

+(instancetype)style
{
    return [self manager];
}

-(NSDictionary *)tableViewStyle
{
    return nil;
}

-(NSDictionary *)controllerStyle
{
    return nil;
}

-(NSDictionary *)buttonStyle
{
    return nil;
}


-(NSDictionary *)labelStyle
{
    return nil;
}

@end




@implementation NSDictionary (Style)

-(NSDictionary*)findStyleWithName:(NSString*)name
{
    return [self findStyleWithName:name ChildrenName:name OriginalChildName:name];
}

-(NSDictionary*)findStyleWithName:(NSString*)name ChildrenName:(NSString*)childrenName OriginalChildName:originalChildName
{
    NSDictionary* style = self[name];
    if(![style isKindOfClass:[NSDictionary class]])
        return nil;
    
    NSDictionary* extend = style[mt_extend];
    style = style[mt_style];
    if(![extend isKindOfClass:[NSDictionary class]])
        return style;
    
    
    NSArray* parent = extend[mt_parent];
    if(![parent isKindOfClass:[NSArray class]] || (parent.count < 1))
        return style;
    
    NSMutableDictionary* sumStyle = [NSMutableDictionary dictionary];
    
    NSDictionary* delete = extend[mt_delete];
    if(![delete isKindOfClass:[NSDictionary class]])
        delete = nil;
    
    for(NSString* pName in parent)
    {
        if([pName isEqualToString:childrenName])
            continue;
        if([pName isEqualToString:originalChildName])
            continue;
        
        NSDictionary* pStyle = [self findStyleWithName:pName ChildrenName:name OriginalChildName:originalChildName];
        if(!pStyle)
            continue;
        
        NSMutableDictionary* mpStyle = [pStyle mutableCopy];
        
        NSArray* deleteArr = delete[pName];
        if([deleteArr isKindOfClass:[NSArray class]])
            [deleteArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mpStyle removeObjectForKey:obj];
            }];
        
        [sumStyle setValuesForKeysWithDictionary:[mpStyle copy]];
    }
    
    [sumStyle setValuesForKeysWithDictionary:style];
    
    return sumStyle;
}


@end
