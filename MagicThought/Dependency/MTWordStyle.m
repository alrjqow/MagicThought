//
//  MTWordStyle.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/19.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTWordStyle.h"

#import <MJExtension.h>

@implementation MTWordStyle

+(NSArray *)mj_ignoredPropertyNames
{
    return @[@"lineSpacing", @"verticalAlignment", @"horizontalAlignment", @"bold", @"thin"];
}


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

-(VerticalAlignment)verticalAlignment
{
    __weak __typeof(self) weakSelf = self;
    VerticalAlignment verticalAlignment = ^(MTVerticalAlignment verticalAlignment){
        
        weakSelf.wordVerticalAlignment = verticalAlignment;
        return weakSelf;
    };
    
    return verticalAlignment;
}

-(HorizontalAlignment)horizontalAlignment
{
    __weak __typeof(self) weakSelf = self;
    HorizontalAlignment horizontalAlignment = ^(NSTextAlignment horizontalAlignment){
        
        weakSelf.wordHorizontalAlignment = horizontalAlignment;
        return weakSelf;
    };
    
    return horizontalAlignment;
}

-(LineSpacing)lineSpacing
{
    __weak __typeof(self) weakSelf = self;
       LineSpacing lineSpacing = ^(CGFloat lineSpacing){
           
           weakSelf.wordLineSpacing = lineSpacing;
           return weakSelf;
       };
       
       return lineSpacing;
}

-(instancetype)init
{
    if(self = [super init])
    {
        self.wordHorizontalAlignment = NSTextAlignmentNatural;
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

MTWordStyle* mt_AttributedWordStyleMake(CGFloat wordSize, NSAttributedString* attributedWordName,UIColor* wordColor)
{
    MTWordStyle* word = [MTWordStyle new];
    
    word.wordSize = wordSize;
    word.attributedWordName = attributedWordName;
    word.wordColor = wordColor;
    
    return word;
}

@end
