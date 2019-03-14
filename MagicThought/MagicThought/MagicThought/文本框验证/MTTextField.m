//
//  MTTextField.m
//  DaYiProject
//
//  Created by monda on 2018/8/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTTextField.h"
#import "NSString+TestString.h"
#import "NSString+Exist.h"
#import "NSString+Money.h"

@interface MTTextFieldVerifyModel ()
{
    NSString * _content;
    MTTextFieldEventType _event;
}

@property (nonatomic,assign) MTTextFieldEventType preEvent;

@property (nonatomic,assign) BOOL firstFill;

@end

@implementation MTTextFieldVerifyModel

-(void)setEvent:(MTTextFieldEventType)event
{
    _event = event == self.preEvent ? MTTextFieldEventTypeDefault : event;
    self.preEvent = event;
}

-(MTTextFieldEventType)event
{
    return self.verifyType == MTTextFieldVerifyTypeNone ? MTTextFieldEventTypeDefault : _event;
}

-(BOOL)verifyResult
{
    if(self.verifyType == MTTextFieldVerifyTypeNone)
        return YES;
    if(self.testFormat)
        return [self.content testWithFormat:self.testFormat];
    
    switch (self.verifyType) {
        case MTTextFieldVerifyTypePhone:
            return [self.content testPhoneNumber];
            
        case MTTextFieldVerifyTypeVFCode:
            return [self.content testVFCode];
        
        case MTTextFieldVerifyTypeMoney:
            return [self.content testMoney];
            
        case MTTextFieldVerifyTypeNumberPassword:
            return [self.content testPayPassword];
            
        case MTTextFieldVerifyTypePassword:
        case MTTextFieldVerifyTypeCustom:
            return [self.content testWithFormat:self.testFormat];
            
        default:
            return YES;
    }
}

-(void)setContent:(NSString *)content
{
    _content = content;

    switch (self.verifyType) {
        case MTTextFieldVerifyTypePhone:        
        case MTTextFieldVerifyTypeVFCode:
        case MTTextFieldVerifyTypePassword:
            case MTTextFieldVerifyTypeNumberPassword:
        case MTTextFieldVerifyTypeCustom:
        {
            if(self.content.length >= self.minChar)
            {
                self.event = MTTextFieldEventTypePositive;
                self.firstFill = YES;
            }
            else
                self.event = self.firstFill ? MTTextFieldEventTypeNegative : MTTextFieldEventTypeDefault;
            
            break;
        }
            
        default:
            self.event = [content isExist] ? MTTextFieldEventTypePositive : MTTextFieldEventTypeNegative;
            break;
    }
}

-(void)setVerifyType:(MTTextFieldVerifyType)verifyType
{
    _verifyType = verifyType;
    
    switch (verifyType) {
        case MTTextFieldVerifyTypePhone:
        {
            self.minChar = 11;
            self.maxChar = 11;
            break;
        }
        
        case MTTextFieldVerifyTypeNumberPassword:
        case MTTextFieldVerifyTypeVFCode:
        {
            self.minChar = 6;
            self.maxChar = 6;
            break;
        }
            
        default:
            break;
    }
}

-(NSString *)content
{
    NSString* content;
    switch (self.verifyType) {
        case MTTextFieldVerifyTypePhone:
        {
            content = [_content stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
        }
            
        
        case MTTextFieldVerifyTypeMoney:
        {
            content = [[_content stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            break;
        }
            
        default:
            content = _content;
    }
    
    return [content isExist] ? content : @"";
}

@end

@implementation MTTextField

-(BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (self.verifyModel.verifyType) {
        case MTTextFieldVerifyTypePhone:
        {
            if(self.text.length < 1 && ![string isEqualToString:@"1"])
                return false;
        }
        case MTTextFieldVerifyTypeVFCode:
        case MTTextFieldVerifyTypePassword:
        case MTTextFieldVerifyTypeNumberPassword:
        case MTTextFieldVerifyTypeCustom:
            return !(self.text.length > (self.verifyModel.maxChar - 1) && [string isExist]);
        
        case MTTextFieldVerifyTypeMoney:
        {
            //如果输入的是“.”  判断之前已经有"."或者字符串为空
            if ([string isEqualToString:@"."] && ([self.text rangeOfString:@"."].location != NSNotFound || [self.text isEqualToString:@""])) {
                return NO;
            }
            
            //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
            NSMutableString *str = [[NSMutableString alloc] initWithString:self.text];
            [str insertString:string atIndex:range.location];
            if (str.length > [str rangeOfString:@"."].location+3){
                return NO;
            }
            
            return YES;
        }
            
        default:
            return YES;
    }
}

-(void)didBeginEditing
{
    switch (self.verifyModel.verifyType) {
        
        case MTTextFieldVerifyTypePhone:
        {
            self.text = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
        }
            
        case MTTextFieldVerifyTypeMoney:
        {
            self.text = [[self.text stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            break;
        }
            
            
        default:
            break;
    }
}

- (void)didEndEditing
{
    switch (self.verifyModel.verifyType) {
        case MTTextFieldVerifyTypePhone:
        {
            if(![self.text isExist])
                return;
            
            if(self.text.length < 11)
                return;
            
            NSMutableString* text = [self.text mutableCopy];
            
            [text insertString:@" " atIndex:3];
            [text insertString:@" " atIndex:8];
            
            
            self.text = [text copy];
            break;
        }
            
        case MTTextFieldVerifyTypeMoney:
        {
            if([self.text isExist])
                self.text = [self.text money];
            break;
        }
            
        default:
            break;
    }
}

-(void)didTextValueChange
{
    self.verifyModel.content = self.text;
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self.verifyModel withOrder:MTTextFieldValueChangeOrder];
}


#pragma mark - 生命周期

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return self;
}


#pragma mark - 懒加载

-(void)setVerifyModel:(MTTextFieldVerifyModel *)verifyModel
{
    _verifyModel = verifyModel;
    
    switch (self.verifyModel.verifyType) {
        case MTTextFieldVerifyTypePhone:
        case MTTextFieldVerifyTypeVFCode:
        case MTTextFieldVerifyTypeNumberPassword:
        {
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
            
        case MTTextFieldVerifyTypeMoney:
        {
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        }
            
        default:
            self.keyboardType = UIKeyboardTypeDefault;
    }
    
    self.secureTextEntry = (self.verifyModel.verifyType == MTTextFieldVerifyTypePassword) || (self.verifyModel.verifyType == MTTextFieldVerifyTypeNumberPassword);
    self.text = verifyModel.content;
    
    [self didEndEditing];
}

@end
