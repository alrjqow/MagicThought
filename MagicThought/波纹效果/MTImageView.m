//
//  MTImageView.m
//  8kqw
//
//  Created by 王奕聪 on 2017/4/20.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTImageView.h"
#import "UIView+Tap.h"

@implementation MTImageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {        
        [self openTapEffect];
    }
    return self;
}


-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if(self = [super initWithImage:image highlightedImage:highlightedImage])
    {
        [self openTapEffect];
    }
    return self;
}



@end
