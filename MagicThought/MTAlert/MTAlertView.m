//
//  MTAlertView.m
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTAlertView.h"
#import "MTAlertViewConfig.h"
#import "MTPopButtonItem.h"
#import "MTTextView.h"
#import "MTWordStyle.h"

#import "UIColor+Image.h"
#import "NSString+WordHeight.h"
#import "UIView+Frame.h"

#define MT_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)

@interface MTAlertView()
{
    MTAlertViewConfig* _alertConfig;
}


@property (nonatomic, strong) NSArray<MTPopButtonItem*>* actionItems;

@property (nonatomic, strong) MTTextView *detailTextView;

@property (nonatomic, strong) UIImageView* titleLogo;

@property (nonatomic, strong) UILabel* titleLabel;

@property (nonatomic, strong) UILabel* detailLabel;

@property (nonatomic, strong) UIView* buttonView;

@property (nonatomic,strong) UIView* customView;


@end

@implementation MTAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupSubviews];
    }
    
    return self;
}

- (instancetype) initWithConfig:(MTAlertViewConfig*)config;
{
    return  [self initWithConfig:config CustomView:nil];
}

- (instancetype) initWithConfig:(MTAlertViewConfig*)config CustomView:(UIView*)customView
{
    if(self = [super initWithFrame:CGRectZero])
    {
        self.alertConfig = config;
        if(customView)
            self.customView = customView;
        [self.customView setClipsToBounds:YES];
        [self setupSubviews];
    }
    
    return self;
}


-(void)setupSubviews
{
    self.actionItems = self.alertConfig.items;
    
    self.layer.cornerRadius = self.alertConfig.cornerRadius;
    self.clipsToBounds = YES;
    self.backgroundColor = self.alertConfig.backgroundColor;
    self.layer.borderWidth = MT_SPLIT_WIDTH;
    self.layer.borderColor = self.alertConfig.splitColor.CGColor;
    
    [self addSubview:self.titleLogo];
    [self addSubview:self.titleLabel];
    [self addSubview:self.customView];
    [self addSubview:self.buttonView];
    
    self.actionItems = self.alertConfig.items;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLogo sizeToFit];
    [self.titleLabel sizeToFit];
    
    self.width = self.alertConfig.width;
    
    self.titleLogo.x = (self.width - self.titleLogo.width - self.titleLabel.width) * 0.5 ;
    if(self.titleLogo.x < self.alertConfig.innerMargin)
        self.titleLogo.x = self.alertConfig.innerMargin;
    
        
    self.titleLabel.x = self.titleLogo.maxX + (self.titleLogo.width > 0 ? self.alertConfig.logoMargin.right : 0);
    if(self.titleLabel.maxX > self.width - self.alertConfig.innerMargin)
        self.titleLabel.width = self.width - self.alertConfig.innerMargin - self.titleLabel.x;
    
    if(self.titleLogo.height > self.titleLabel.height)
    {
            self.titleLogo.y = self.alertConfig.innerTopMargin;
            self.titleLabel.y = self.titleLogo.y + self.titleLogo.halfHeight - self.titleLabel.halfHeight;
    }
    else
    {
        self.titleLabel.y = self.alertConfig.innerTopMargin;
        self.titleLogo.y = self.titleLabel.y + self.titleLabel.halfHeight - self.titleLogo.halfHeight;
    }
    
    
    CGFloat maxY = self.titleLabel.maxY > self.titleLogo.maxY ? self.titleLabel.maxY : self.titleLogo.maxY;
    
    CGFloat offset = self.titleLogo.maxY > self.titleLabel.maxY ? self.alertConfig.logoMargin.bottom : self.alertConfig.innerTopMargin;
    if(self.alertConfig.title.length > 0)
        offset = self.alertConfig.detailInnerMargin;
    
    self.customView.x = self.alertConfig.innerMargin;
    self.customView.y = CGSizeEqualToSize(CGSizeZero, self.titleLogo.frame.size) && CGSizeEqualToSize(CGSizeZero, self.titleLabel.frame.size)  ? offset: maxY + offset;
    self.customView.width = self.width - 2 * self.alertConfig.innerMargin;

    
    self.buttonView.y = self.customView.maxY + (self.alertConfig.detail.length > 0  ? self.alertConfig.detailInnerMargin + 2 : self.alertConfig.innerMargin);
    self.buttonView.width = self.width;
    self.buttonView.height = (self.alertConfig.buttonHeight +  self.alertConfig.splitWidth) * (self.alertConfig.items.count < 3 ? 1 : self.alertConfig.items.count);
   
    
    self.bounds = CGRectMake(0, 0, self.alertConfig.width, self.buttonView.maxY);
    
    BOOL isSingleLine = self.alertConfig.items.count < 3;
    NSInteger separatorLineCount = self.alertConfig.items.count + (isSingleLine  ?  - 1 : 0);
    CGFloat w = (self.width - separatorLineCount * self.alertConfig.splitWidth) / self.alertConfig.items.count;
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
    MTPopButtonItem *item = self.actionItems[btn.tag];
    [self hide];

    if (item.handler)
        item.handler(btn.tag);
    else if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self.customView == self.detailTextView ? self.config : self.customView withOrder:item.order];    
}

#pragma mark - 懒加载

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        
        _titleLabel.textColor = self.alertConfig.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = self.alertConfig.titleFont;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = self.backgroundColor;
        _titleLabel.text = self.alertConfig.title;
    }
    
    return _titleLabel;
}

-(MTTextView *)detailTextView
{
    if(!_detailTextView)
    {
        _detailTextView = [MTTextView new];

        _detailTextView.shouldBeginEdit = false;        
        _detailTextView.textColor = self.alertConfig.detailColor;
        _detailTextView.backgroundColor = self.backgroundColor;
        _detailTextView.lineSpacing = self.alertConfig.detailLineSpacing;

        if(self.alertConfig.attributedDetail)
            _detailTextView.attributedText = self.alertConfig.attributedDetail;
        else
        {
            _detailTextView.text = self.alertConfig.detail;
            _detailTextView.textAlignment = self.alertConfig.detailAlignment;
        }
        
        _detailTextView.font = self.alertConfig.detailFont;
        
        CGFloat width = self.alertConfig.width - 2 * self.alertConfig.innerMargin;
        CGSize size =  [_detailTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        _detailTextView.bounds = CGRectMake(0, 0, width, size.height < 125 ? size.height : 125) ;
        [_detailTextView scrollRangeToVisible:NSMakeRange(0, 1)];
        _detailTextView.scrollEnabled = size.height >= 125;
    }
    
    return _detailTextView;
}

-(UIView *)buttonView
{
    if(!_buttonView)
    {
        _buttonView = [UIView new];
        [_buttonView setClipsToBounds:YES];
        _buttonView.backgroundColor = self.alertConfig.splitColor;
    }
    
    return _buttonView;
}

-(void)setActionItems:(NSArray<MTPopButtonItem *> *)actionItems
{
    _actionItems = actionItems;
    for (UIView* subView in self.buttonView.subviews)
        [subView removeFromSuperview];
    
    for ( NSInteger i = 0 ; i < actionItems.count; ++i )
    {
        MTPopButtonItem *item = actionItems[i];
        
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setExclusiveTouch:YES];
        [btn setBackgroundImage:item.backgroundColor ? [item.backgroundColor changeToImage] : [self.backgroundColor changeToImage]  forState:UIControlStateNormal];
        [btn setBackgroundImage:[self.alertConfig.itemPressedColor changeToImage] forState:UIControlStateHighlighted];
        [btn setTitle:item.word.wordName forState:UIControlStateNormal];
        [btn setTitleColor:item.word.wordColor ? item.word.wordColor : (item.highlight?self.alertConfig.itemHighlightColor : self.alertConfig.itemNormalColor) forState:UIControlStateNormal];
        btn.titleLabel.font = item.word.wordSize == 0 ? self.alertConfig.buttonFont : [self.alertConfig.buttonFont fontWithSize:item.word.wordSize];
        [self.buttonView addSubview:btn];
        btn.tag = i;
    }
    
    [self layoutIfNeeded];
}

-(UIImageView *)titleLogo
{
    if(!_titleLogo)
    {
        _titleLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.alertConfig.logoName]];
    }
    
    return _titleLogo;
}

-(void)setAlertConfig:(MTAlertViewConfig *)alertConfig
{
    _alertConfig = alertConfig;
    self.config = alertConfig;
}

-(MTAlertViewConfig *)alertConfig
{
    if(!_alertConfig)
    {
        _alertConfig = [MTAlertViewConfig new];
    }
    
    return _alertConfig;
}

-(UIView *)customView
{
    if(!_customView)
    {
        _customView = self.detailTextView;
    }
    
    return _customView;
}

@end




@implementation NSObject (AlertViewDelegate)

-(void)alertWithTitle:(NSString*)title Content:(NSString*)detail Buttons:(NSArray<MTPopButtonItem*>*)items
{
    [self alertWithLogo:nil Title:title Content:detail Buttons:items];
}

-(void)alertWithLogo:(NSString*)logo Title:(NSString*)title Content:(NSString*)detail Buttons:(NSArray<MTPopButtonItem*>*)items
{
    MTAlertViewConfig* config = [MTAlertViewConfig new];
    config.title = title;
    config.logoName = logo;
    config.detail = detail;
    config.items = items;
    
    [self alertWithConfig:config];
}

-(void)alertWithConfig:(MTAlertViewConfig*)config
{
    MTAlertView* view = [[MTAlertView alloc] initWithConfig:config];
    view.mt_delegate = self;
    [view show];
}

-(void)alertWithConfig:(MTAlertViewConfig*)config CustomView:(UIView*)customView
{
    MTAlertView* view = [[MTAlertView alloc] initWithConfig:config CustomView:customView];
    view.mt_delegate = self;
    [view show];
}


@end
