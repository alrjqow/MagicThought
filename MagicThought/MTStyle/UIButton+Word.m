//
//  UIButton+Word.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/11.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UIButton+Word.h"


@implementation UIButton (Word)

-(instancetype)setWordWithStyle:(MTWordStyle*)style
{
    if(style.wordColor)
        [self setTitleColor:style.wordColor forState:UIControlStateNormal];
    
    if(style.wordSize)
    {
        if((style.wordBold && style.wordThin) || (!style.wordBold && !style.wordThin))
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
        
    self.titleLabel.textAlignment = style.wordHorizontalAlignment;
    [self setTitle:style.wordName forState:UIControlStateNormal];
    [self sizeToFit];
    return self;
}

@end
