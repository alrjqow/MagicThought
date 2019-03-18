//
//  MTAlertStyle.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/11.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTAlertType) {
    
    MTAlertTypeDoubleButton,
    MTAlertTypeSingleButton
};

@interface MTAlertStyle : NSObject

@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* subTitle;

@property(nonatomic,strong) NSString* leftStatement;
@property(nonatomic,strong) NSString* rightStatement;

@property(nonatomic,assign) MTAlertType type;

CG_EXTERN MTAlertStyle* mt_AlertStyleMake(NSString* title, NSString* subTitle,NSString* leftStatement,NSString* rightStatement,MTAlertType type);

@end
