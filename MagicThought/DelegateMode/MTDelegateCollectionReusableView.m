//
//  MTDelegateCollectionReusableView.m
//  MonDaProject
//
//  Created by monda on 2018/6/19.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTDelegateCollectionReusableView.h"

@interface MTDelegateCollectionReusableViewLayer : CALayer @end

@implementation MTDelegateCollectionReusableViewLayer
- (CGFloat) zPosition {
    return 0;
}
@end

@implementation MTDelegateCollectionReusableView

-(void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height -= (self.marginBottom + self.marginTop);
    rect.origin.y += self.marginTop;
    rect.origin.x += self.marginLeft;
    rect.size.width -= (self.marginLeft + self.marginRight);
    
    [super setFrame:rect];
}

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

-(void)whenGetResponseObject:(NSObject*)object
{
    
}

+(Class)layerClass
{
return [MTDelegateCollectionReusableViewLayer class];
}

@end
