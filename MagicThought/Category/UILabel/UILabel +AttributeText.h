//
//  UILabel +AttributeText.h
//  MonDaProject
//
//  Created by monda on 2018/4/17.
//  Copyright © 2018年 monda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AttributeText)

-(void)setAttributeText:(NSString*)text WithAttribute:(NSDictionary*)attrDict;

-(void)setLastWordWithAttribute:(NSDictionary*)attrDict;

-(void)setFirstWordWithAttribute:(NSDictionary*)attrDict;

@end
