//
//  MTAlertView.m
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTAlertView.h"
#import "MTAlertViewConfig.h"
#import "MTTextView.h"
#import "MTCloud.h"
#import "NSString+Exist.h"

@interface MTAlertView()

@property (nonatomic, strong) MTTextView *detailTextView;

@property (nonatomic, strong) UIView* buttonView;

@property (nonatomic,strong) UIView* customView;


@end

@implementation MTAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:CGRectZero])
    {
        [self initWithConfig:nil CustomView:nil];
    }
    return self;
}

+ (instancetype) alertWithConfig:(MTAlertViewConfig*)config
{
    return  [self alertWithConfig:config CustomView:nil];
}

+ (instancetype) alertWithConfig:(MTAlertViewConfig*)config CustomView:(UIView*)customView
{
    MTAlertView* alertView = [self new];
    [alertView initWithConfig:config CustomView:customView];
    return alertView;
}

- (void)initWithConfig:(MTAlertViewConfig*)config CustomView:(UIView*)customView
{
    if(!customView)
        customView = self.detailTextView;
    self.customView = customView;
    
    if(![config isKindOfClass:self.classOfResponseObject])
        config = nil;
    if(!config)
        config = [MTAlertViewConfig new];
    
    self.model = config;
}

#pragma mark - 成员方法

-(void)setupDefault
{
    [super setupDefault];
    
    self.clipsToBounds = YES;
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;
    
    _buttonView = [UIView new];
    [self.buttonView setClipsToBounds:YES];
    [self addSubview:self.buttonView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.textLabel sizeToFit];
    
    self.width = self.alertConfig.width;
    
    self.imageView.x = (self.width - self.imageView.width - self.textLabel.width) * 0.5 ;
    if(self.imageView.x < self.alertConfig.innerMargin)
        self.imageView.x = self.alertConfig.innerMargin;
    
    
    self.textLabel.x = self.imageView.maxX + (self.imageView.width > 0 ? self.alertConfig.logoMargin.right : 0);
    if(self.textLabel.maxX > self.width - self.alertConfig.innerMargin)
        self.textLabel.width = self.width - self.alertConfig.innerMargin - self.textLabel.x;
    
    if(self.imageView.height > self.textLabel.height)
    {
        self.imageView.y = self.alertConfig.innerTopMargin;
        self.textLabel.y = self.imageView.y + self.imageView.halfHeight - self.textLabel.halfHeight;
    }
    else
    {
        self.textLabel.y = self.alertConfig.innerTopMargin;
        self.imageView.y = self.textLabel.y + self.textLabel.halfHeight - self.imageView.halfHeight;
    }
    
    
    CGFloat maxY = self.textLabel.maxY > self.imageView.maxY ? self.textLabel.maxY : self.imageView.maxY;
    
    CGFloat offset = self.imageView.maxY > self.textLabel.maxY ? self.alertConfig.logoMargin.bottom : self.alertConfig.innerTopMargin;
    if(self.alertConfig.title.text.length > 0)
        offset = self.alertConfig.detailInnerMargin;
    
    self.customView.x = self.alertConfig.innerMargin;
    self.customView.y = CGSizeEqualToSize(CGSizeZero, self.imageView.frame.size) && CGSizeEqualToSize(CGSizeZero, self.textLabel.frame.size)  ? offset: maxY + offset;
    self.customView.width = self.width - 2 * self.alertConfig.innerMargin;
    
    
    self.buttonView.y = self.customView.maxY + (self.alertConfig.content.text.length > 0  ? self.alertConfig.detailInnerMargin + 2 : self.alertConfig.innerMargin);
    self.buttonView.width = self.width;
    self.buttonView.height = (self.alertConfig.buttonHeight +  self.alertConfig.splitWidth) * (self.alertConfig.buttonModelList.count < 3 ? 1 : self.alertConfig.buttonModelList.count);
    
    
    self.bounds = CGRectMake(0, 0, self.alertConfig.width, self.buttonView.maxY);
    
    BOOL isSingleLine = self.alertConfig.buttonModelList.count < 3;
    NSInteger separatorLineCount = self.alertConfig.buttonModelList.count + (isSingleLine  ?  - 1 : 0);
    CGFloat w = (self.width - separatorLineCount * self.alertConfig.splitWidth) / self.alertConfig.buttonModelList.count;
    maxY = 0;
    
    for(NSInteger i = 0; i < self.buttonView.subviews.count; i++)
    {
        UIView* subView = self.buttonView.subviews[i];
        
        if(isSingleLine)
        {
            subView.frame = CGRectMake(w * i + (i == 0 ? 0 : self.alertConfig.splitWidth), self.alertConfig.splitWidth, w, self.alertConfig.buttonHeight);
        }
        else
        {
            subView.frame = CGRectMake(0, maxY + self.alertConfig.splitWidth, self.width, self.alertConfig.buttonHeight);
            maxY = subView.maxY;
        }
    }
}

- (void)actionButton:(UIButton*)btn
{
    MTBaseButtonContentModel *item = self.alertConfig.buttonModelList[btn.tag];
    [self hide];
    
    if (item.mt_click)
        item.mt_click(item.mt_order);
    else if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self.customView == self.detailTextView ? self.config : self.customView withOrder:item.mt_order];
}

#pragma mark - 懒加载

-(void)setModel:(MTAlertViewConfig *)model
{
    if(![model isKindOfClass:[MTAlertViewConfig class]])
        return;
    
    [super setModel:model];
    
    self.detailTextView.baseContentModel = model.content;
    self.buttonView.baseContentModel = model.content2;
    
    CGFloat width = model.width - 2 * model.innerMargin;
    CGSize size =  [self.detailTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.detailTextView.bounds = CGRectMake(0, 0, width, size.height < 125 ? size.height : 125) ;
    [self.detailTextView scrollRangeToVisible:NSMakeRange(0, 1)];
    self.detailTextView.scrollEnabled = size.height >= 125;
    
    self.buttonView = self.buttonView;
    
    [self setNeedsLayout];
}



-(void)setButtonView:(UIView *)buttonView
{
    if(_buttonView != buttonView)
        _buttonView = buttonView;
    else
    {
        for (UIView* subView in buttonView.subviews)
            [subView removeFromSuperview];
    }
    
    for (NSInteger i = 0 ; i < self.alertConfig.buttonModelList.count; ++i)
    {
        MTBaseButtonContentModel *baseContentModel = self.alertConfig.buttonModelList[i];
        
        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setExclusiveTouch:YES];
        btn.baseContentModel = baseContentModel;
        
        [self.buttonView addSubview:btn];
    }
    
    [self setNeedsLayout];
}

-(void)setCustomView:(UIView *)customView
{
    if(!customView)
        return;
    
    if(_customView != self.detailTextView)
        [_customView removeFromSuperview];
    else
        self.detailTextView.hidden = YES;
    
    _customView = customView;
    [_customView setClipsToBounds:YES];
    
    if(_customView != self.detailTextView)
        [self addSubview:customView];
    else
        self.detailTextView.hidden = false;
}

-(MTTextView *)detailTextView
{
    if(!_detailTextView)
    {
        _detailTextView = [MTTextView new];
        _detailTextView.shouldBeginEdit = false;
    }
    
    return _detailTextView;
}

-(MTViewContentModel *)model
{
    MTAlertViewConfig* model = (MTAlertViewConfig*)[super model];
    if(![model isKindOfClass:[MTAlertViewConfig class]])
    {
        NSString* reuseIdentifier = [MTCloud shareCloud].alertViewConfigName;
        if(![reuseIdentifier isExist])
            reuseIdentifier = @"MTAlertViewConfig";
        
        Class configClassName = NSClassFromString(reuseIdentifier);
        if(![configClassName isSubclassOfClass:[MTAlertViewConfig class]])
            configClassName = [MTAlertViewConfig class];
        
        model = configClassName.new;
        self.model = model;
    }
    
    return model;
}

-(MTPopViewConfig *)config
{
    return (MTPopViewConfig*)self.model;
}

-(MTAlertViewConfig *)alertConfig
{
    return (MTAlertViewConfig*)self.model;
}

-(Class)classOfResponseObject
{
    return [MTAlertViewConfig class];
}

@end

