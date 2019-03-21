//
//  MTDelegateCollectionViewCell.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateCollectionViewCell.h"

@implementation MTDelegateCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {        
        [self setupDefault];
    }
    
    return self;
}


-(void)setupDefault
{
    
}

-(void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= (self.marginBottom + self.marginTop);
    rect.origin.y += self.marginTop;
    rect.origin.x += self.marginLeft;
    rect.size.width -= (self.marginLeft + self.marginRight);
    
    [super setFrame:rect];
}

-(void)whenGetResponseObject:(NSObject*)object
{
    
}

-(NSDictionary*)giveSomeThingToYou
{
    return @{};
}

/**拿一些东西给我做什么*/
-(void)giveSomeThingToMe:(id)obj WithOrder:(NSString*)order
{
    
}

@end
