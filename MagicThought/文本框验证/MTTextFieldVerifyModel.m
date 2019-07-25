//
//  MTTextFieldVerifyModel.m
//  MDKit
//
//  Created by monda on 2019/5/16.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTTextFieldVerifyModel.h"
#import "NSString+TestString.h"
#import "NSString+Exist.h"

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

-(NSInteger)minChar
{
    switch (self.verifyType) {
        case MTTextFieldVerifyTypePhone:
        {
            if(_minChar <= 0)
                return 11;
        }
        case MTTextFieldVerifyTypeNumberPassword:
        case MTTextFieldVerifyTypeVFCode:
        {
            if(_minChar <= 0)
                return 6;
        }
            
        default:
            return _minChar;
    }
}

-(NSInteger)maxChar
{
    switch (self.verifyType) {
        case MTTextFieldVerifyTypePhone:
        {
            if(_maxChar <= 0)
                return 11;
        }
        case MTTextFieldVerifyTypeNumberPassword:
        case MTTextFieldVerifyTypeVFCode:
        {
            if(_maxChar <= 0)
                return 6;
        }
            
        default:
            return _maxChar;
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
