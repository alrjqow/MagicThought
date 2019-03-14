//
//  UIButton+Word.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/11.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIButton+Word.h"
#import "MTWordStyle.h"

@implementation UIButton (Word)

-(UIButton*)setWordWithStyle:(MTWordStyle*)style
{
    [self setTitle:style.wordName forState:UIControlStateNormal];
    if(style.wordColor)
        [self setTitleColor:style.wordColor forState:UIControlStateNormal];
    if(style.wordColorValue)
        [self setTitleColor:hex(style.wordColorValue) forState:UIControlStateNormal];
    if(style.wordSize)
    {
        if((style.wordBold && style.wordThin) || (!style.wordBold && !style.wordThin) )
            self.titleLabel.font = [UIFont systemFontOfSize:style.wordSize];
        else if(style.wordBold)
            self.titleLabel.font = [UIFont boldSystemFontOfSize:style.wordSize];
        else if(style.wordThin)
        {
            if (@available(iOS 8.2, *)) 
                self.titleLabel.font = [UIFont systemFontOfSize:style.wordSize weight:UIFontWeightThin];
             else
                self.titleLabel.font = [UIFont systemFontOfSize:style.wordSize];
        }
    }
        
    self.titleLabel.textAlignment = style.horizontalAlignment;
    
    return self;
}

@end
