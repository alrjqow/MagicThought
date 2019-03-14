//
//  UITextField+Word.m
//  8kqw
//
//  Created by 王奕聪 on 2017/5/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "UITextField+Word.h"

@implementation UITextField (Word)

-(UITextField*)setWordWithStyle:(MTWordStyle*)style
{
    self.text = style.wordName;
    
    if(style.wordColor)
        self.textColor = style.wordColor;
    if(style.wordColorValue)
        self.textColor = hex(style.wordColorValue);
    
    if(style.wordSize)
    {
        if((style.bold && style.thin) || (!style.bold && !style.thin) )
            self.font = [UIFont systemFontOfSize:style.wordSize];
        else if(style.bold)
            self.font = [UIFont boldSystemFontOfSize:style.wordSize];
        else if(style.thin)
        {
            if (@available(iOS 8.2, *))
                self.font = [UIFont systemFontOfSize:style.wordSize weight:UIFontWeightThin];
            else
                self.font = [UIFont systemFontOfSize:style.wordSize];
        }            
    }
    
    self.textAlignment = style.horizontalAlignment;
    
    return self;
}

-(UITextField*)setPlaceholderWithStyle:(MTWordStyle *)placeholderStyle
{
    if(!placeholderStyle.wordColor)
    {
        self.placeholder = placeholderStyle.wordName;
        return self;
    }
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:placeholderStyle.wordName];
    
    if(placeholderStyle.wordColor)
        [str addAttribute:NSForegroundColorAttributeName value:placeholderStyle.wordColor range:NSMakeRange(0, str.length)];
    
//    if(placeholderStyle.wordSize)
//        [str addAttribute:NSFontAttributeName value:@(placeholderStyle.wordSize) range:NSMakeRange(0, str.length)];
    
    self.attributedPlaceholder =  str;
    
    return self;
}

@end
