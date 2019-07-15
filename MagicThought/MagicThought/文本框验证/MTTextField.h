//
//  MTTextField.h
//  DaYiProject
//
//  Created by monda on 2018/8/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MTTextFieldEventType)
{
    MTTextFieldEventTypeDefault = 0,
    MTTextFieldEventTypePositive = 1,
    MTTextFieldEventTypeNegative = -1
};

typedef NS_ENUM(NSInteger, MTTextFieldVerifyType)
{
    MTTextFieldVerifyTypeDefault,
    MTTextFieldVerifyTypeNone,    
    MTTextFieldVerifyTypePhone,
    MTTextFieldVerifyTypeVFCode,
    MTTextFieldVerifyTypePassword,
    MTTextFieldVerifyTypeNumberPassword,
    MTTextFieldVerifyTypeMoney,
    MTTextFieldVerifyTypeCustom,
};

@interface MTTextFieldVerifyModel : NSObject

#pragma mark - 被动调用

@property (nonatomic,strong) NSString* content;

@property (nonatomic,assign) MTTextFieldEventType event;

@property (nonatomic,assign, readonly) BOOL verifyResult;

#pragma mark - 主动调用

@property (nonatomic,strong) NSString* placeholder;

@property (nonatomic,strong) UIColor* placeholderColor;

@property (nonatomic,assign) MTTextFieldVerifyType verifyType;

#pragma mark - 自定义验证

/**至少需要的字符*/
@property (nonatomic,assign) NSInteger minChar;

/**至多需要的字符*/
@property (nonatomic,assign) NSInteger maxChar;

/**请输入想要检验的正则表达式*/
@property (nonatomic,strong) NSString* testFormat;

/**给外面用的标识*/
@property (nonatomic,strong) NSString* tag;

@end

@protocol MTDelegateProtocol;
@interface MTTextField : UITextField

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@property (nonatomic,weak) MTTextFieldVerifyModel* verifyModel;

-(BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)didBeginEditing;
- (void)didEndEditing;
-(void)didTextValueChange;

@end


