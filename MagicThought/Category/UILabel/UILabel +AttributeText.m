//
//  UILabel +AttributeText.m
//  MonDaProject
//
//  Created by monda on 2018/4/17.
//  Copyright © 2018年 monda. All rights reserved.
//

#import "UILabel +AttributeText.h"
#import "NSString+Exist.h"

@implementation UILabel (AttributeText)

-(void)setFirstWordWithAttribute:(NSDictionary*)attrDict
{
    [self setAttributeText:[self.text substringWithRange:NSMakeRange(0, 1)] WithAttribute:attrDict];
}

-(void)setLastWordWithAttribute:(NSDictionary*)attrDict
{
    if(![self.text isExist])
        return;
        
    [self setAttributeText:[self.text substringWithRange:NSMakeRange(self.text.length - 1, 1)] WithAttribute:attrDict];
}

-(void)setAttributeText:(NSString*)text WithAttribute:(NSDictionary*)attrDict;
{
    NSRange range = [self.text rangeOfString:text];
    if(range.location == NSNotFound)
        return;
    
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    
    [attrDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [attr addAttribute:key value:obj range:range];
    }];
    
    
    self.attributedText = attr;
}

@end
