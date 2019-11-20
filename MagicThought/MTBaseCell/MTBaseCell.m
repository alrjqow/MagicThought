//
//  MTBaseCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/8.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCell.h"
#import "UIView+Frame.h"


@interface MTBaseCell ()

@property (nonatomic,assign) BOOL closeSepLine;

@property (nonatomic,assign) BOOL isAlert;

@end

@implementation MTBaseCell

-(void)whenGetResponseObject:(NSDictionary *)dict
{    
    self.accessoryType = [dict[@"arrow"] boolValue] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    self.closeSepLine = [dict[@"closeSepLine"] boolValue];
    self.isAlert = [dict[@"isAlert"] boolValue];
    
    self.textLabel.text = dict[@"title"];
    self.detailTextLabel.text = dict[@"content"];
    
    if(dict[@"img"])
        self.imageView.image = [UIImage imageNamed:dict[@"img"]];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])
    {
        
    }
    
    return self;
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.sepLineWidth = -1;
    self.accessoryMarginRight = -1;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.isAlert && [self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self withOrder:MTBaseCellAlertOrder];
    else
        [super touchesBegan:touches withEvent:event];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSMutableArray<UIView*>* arr = [NSMutableArray array];
    for(UIView* subView in self.subviews)
    {
        //寻找分割线
        if([subView isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")])
            [arr addObject:subView];
        
        //寻找箭头
        if([subView isKindOfClass:[UIButton class]] && self.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
        {
            _arrow = subView;
            if(!CGRectEqualToRect(CGRectZero, self.accessoryBounds))
                subView.bounds = self.accessoryBounds;
            if(self.accessoryMarginRight > 0)
                subView.maxX = self.width - self.accessoryMarginRight;
        }
    }
    
    
    //设置分割线
    for(NSInteger i = 0; i < arr.count; i++)
    {
        if(i == 0 && arr.count > 1)
        {
            arr[i].width = 0;
            continue;
        }
        
        if(self.sepLineWidth < 0)
            break;
        arr[i].width = self.closeSepLine ? 0 : self.sepLineWidth;
        arr[i].centerX = self.width * 0.5;
        arr[i].centerY = self.contentView.height - arr[i].halfHeight;
    }
    
}

@end


@implementation MTNoSepLineBaseCell

-(CGFloat)sepLineWidth
{
    return 0;
}


@end


@implementation MTSubBaseCell

-(void)setupDefault
{
    [super setupDefault];
    
    self.detailTextLabel2 = [UILabel new];
    
    [self addSubview:self.detailTextLabel2];
}

-(void)whenGetResponseObject:(NSDictionary *)object
{
    [self setSuperResponseObject:object];
    
    self.detailTextLabel2.text = object[@"content2"];
}

@end



