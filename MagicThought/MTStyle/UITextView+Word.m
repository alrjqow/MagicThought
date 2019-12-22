//
//  UITextView+Word.m
//  8kqw
//
//  Created by 王奕聪 on 2017/5/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "UITextView+Word.h"
#import "MTConst.h"

@implementation UITextView (Word)

-(instancetype)setWordWithStyle:(MTWordStyle*)style
{
    if(style.wordLineSpacing && [self isKindOfClass:NSClassFromString(@"MTTextView")])
        [self setValue:@(style.wordLineSpacing) forKey:@"lineSpacing"];
    
    if(style.wordColor)
        self.textColor = style.wordColor;
        
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
    
    self.textAlignment = style.wordHorizontalAlignment;
    
    if(style.attributedWordName)
        self.attributedText = style.attributedWordName;
    else
        self.text = style.wordName;
    
    [self sizeToFit];
    return self;
}


@end
