//
//  MTWordStyle.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/19.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTWordStyle.h"

@implementation MTWordStyle

-(Bold)bold
{
    __weak __typeof(self) weakSelf = self;
    Bold wordBold = ^(BOOL bold){
      
        weakSelf.wordBold = bold;
        return weakSelf;
    };
    
    return wordBold;
}

-(Thin)thin
{
    __weak __typeof(self) weakSelf = self;
    Thin wordThin = ^(BOOL thin){
        
        weakSelf.wordThin = thin;
        return weakSelf;
    };
    
    return wordThin;
}

-(instancetype)init
{
    if(self = [super init])
    {
        self.horizontalAlignment = NSTextAlignmentNatural;
    }
    
    return self;
}

MTWordStyle* mt_WordStyleMake(CGFloat wordSize, NSString* wordName,UIColor* wordColor)
{
    MTWordStyle* word = [MTWordStyle new];
    
    word.wordSize = wordSize;
    word.wordName = wordName;
    word.wordColor = wordColor;
    
    return word;
}

MTWordStyle* mt_WordStyleValueMake(CGFloat wordSize, NSString* wordName, NSUInteger wordColorValue)
{
    MTWordStyle* word = [MTWordStyle new];
    
    word.wordSize = wordSize;
    word.wordName = wordName;
    word.wordColorValue = wordColorValue;
    
    return word;
}

MTWordStyle* mt_WordStyleAppend(MTWordStyle* style, VerticalAlignment verticalAlignment, NSTextAlignment  horizontalAlignment)
{
    style.verticalAlignment = verticalAlignment;
    
    style.horizontalAlignment = horizontalAlignment;
    
    return style;
}



@end
