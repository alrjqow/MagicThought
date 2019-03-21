//
//  UILabel+Word.m
//  MyTool
//
//  Created by 王奕聪 on 2017/3/29.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "UILabel+Word.h"
#import "MTLabel.h"
#import "MTWordStyle.h"
#import "MTDefine.h"

@implementation UILabel (Word)

-(UILabel*)setWordWithStyle:(MTWordStyle*)style
{
    self.text = style.wordName;
    if(style.wordColor)
        self.textColor = style.wordColor;
    if(style.wordColorValue)
        self.textColor = hex(style.wordColorValue);
    if(style.wordSize)
    {
        if((style.wordBold && style.wordThin) || (!style.wordBold && !style.wordThin) )
            self.font = [UIFont systemFontOfSize:style.wordSize];
        else if(style.wordBold)
            self.font = [UIFont boldSystemFontOfSize:style.wordSize];
        else if(style.wordThin)
        {
            if (@available(iOS 8.2, *))
                self.font = [UIFont systemFontOfSize:style.wordSize weight:UIFontWeightThin];
            else
                self.font = [UIFont systemFontOfSize:style.wordSize];
        }
    }
    
    
    
    self.textAlignment = style.horizontalAlignment;
    
    if([self isKindOfClass:[MTLabel class]])
    {        
        ((MTLabel*)self).verticalAlignment = style.verticalAlignment;
    }
    
    return self;
}



@end
