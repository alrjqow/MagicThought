//
//  MTTextView.h
//  8kqw
//
//  Created by 王奕聪 on 2017/8/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTDelegateProtocol;

@class MTWordStyle;
@class MTTextFieldVerifyModel;

@interface MTTextView : UITextView

@property (nonatomic,weak) MTTextFieldVerifyModel* verifyModel;

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@property(nonatomic,strong) IBOutlet NSString* placeholder;

@property(nonatomic,strong) MTWordStyle* placeholderStyle;

@property(nonatomic,assign) BOOL shouldBeginEdit;

@property(nonatomic,assign) CGFloat lineSpacing;

@property(nonatomic,assign) CGFloat fontSpacing;
 
@end
