//
//  MTTextView.m
//  8kqw
//
//  Created by 王奕聪 on 2017/8/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTTextView.h"
#import "MTDelegateProtocol.h"
#import "UILabel+Word.h"
#import "UIColor+ColorfulColor.h"
#import "UIView+Frame.h"
#import "MTTextField.h"
#import "MTConst.h"

@interface MTTextView ()<UITextViewDelegate>

@property(nonatomic,weak) UILabel* placeholderLabel;

@property(nonatomic,strong) NSMutableParagraphStyle* paragraphStyle;

@property(nonatomic,strong) NSString* previousStr;

@property(nonatomic,assign) NSInteger previousStrLength;

@end

@implementation MTTextView

-(void)setText:(NSString *)text
{
    [super setText:text];
//    self.placeholderLabel.hidden = text.length;
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:self.paragraphStyle, NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.textColor ? self.textColor : [UIColor blackColor], NSKernAttributeName : @(self.fontSpacing)}];
}

-(NSMutableParagraphStyle *)paragraphStyle
{
    if(!_paragraphStyle)
    {
        _paragraphStyle = [NSMutableParagraphStyle new];
    }

    return _paragraphStyle;
}

-(void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;

    self.paragraphStyle.lineSpacing = lineSpacing;
}

-(void)setPlaceholderStyle:(MTWordStyle *)placeholderStyle
{
    _placeholderStyle = placeholderStyle;

    [self.placeholderLabel setWordWithStyle:placeholderStyle];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;

    self.placeholderLabel.text = placeholder;
}

-(instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if(self = [super initWithFrame:frame textContainer:textContainer])
    {
        self.delegate = self;
        [self setupSubView];
    }

    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.delegate = self;
    [self setupSubView];
}


-(void)setupSubView
{
    self.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    
    UILabel* label = [UILabel new];
    label.numberOfLines = 0;
    [self insertSubview:label atIndex:0];
    self.placeholderLabel = label;
    self.placeholderStyle = mt_WordStyleMake(14, @"", [UIColor colorWithHex:0xcccccc]);

    self.textContainerInset = UIEdgeInsetsMake(0, 0, 2, 0);

    self.shouldBeginEdit = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.placeholderLabel.width = self.width - 1;
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.x = 4;
    self.placeholderLabel.y = 0;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return self.shouldBeginEdit;
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length;
    self.verifyModel.content = textView.text;
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self.verifyModel withOrder:MTTextValueChangeOrder];
//    NSLog(@"上次的值：%@", self.previousStr);
//    NSLog(@"上次长度：%zd", previousStrLength);

//    UITextRange *selectedRange = [textView markedTextRange];
//    NSString * newText = [textView textInRange:selectedRange];
//
//
//    if(!(newText.length == 0 && self.previousStrLength == 1) && ![newText isExist])
//    {
//        NSLog(@" %@ ------ %@",textView.text, self.previousStr);
//        textView.attributedText = [[NSAttributedString alloc] initWithString:[textView.text stringByAppendingString:[self.previousStr isExist] ? self.previousStr : @""] attributes:@{NSParagraphStyleAttributeName:self.paragraphStyle, NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.textColor, NSKernAttributeName : @(self.fontSpacing)}];
//    }
//
//
//
//    self.previousStr = newText;
//    self.previousStrLength = newText.length;
}



@end
