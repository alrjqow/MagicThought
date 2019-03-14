//
//  UITextView+Word.m
//  8kqw
//
//  Created by 王奕聪 on 2017/5/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "UITextView+Word.h"

@implementation UITextView (Word)

-(UITextView*)setWordWithStyle:(MTWordStyle*)style
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


@end
