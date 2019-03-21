//
//  MTDelegateTableViewCell.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTDelegateTableViewCell.h"
#import "MTConst.h"


@implementation MTDelegateTableViewCell

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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupDefault];
    }
    
    return self;
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


-(void)setupDefault
{
    
}

@end



@implementation MTEmptyTableViewCell


-(void)setupDefault
{
    [super setupDefault];
    
    _emptyLogo = self.imageView;
    _title = self.textLabel;
    _content = self.detailTextLabel;        
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self isAlreadyLoadYes];
}

-(void)isAlreadyLoadYes
{
    if(!self.isAlreadyLoad)
        return;
    
    if([self.delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.delegate doSomeThingForMe:self withOrder:MTDelegateTableViewCellEmptyDataOrder];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])
    {
        
    }
    
    return self;
}

@end

