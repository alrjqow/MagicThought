//
//  MTAlertController.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/10.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTStyle.h"

@interface MTAlertController : UIViewController

@property(nonatomic,assign) CGSize alertViewSize;

@property(nonatomic,copy) void (^doSomethingTapLeft) (void);

@property(nonatomic,copy) void (^doSomethingTapRight) (void);

@property(nonatomic,strong) UIImage* alertBackgroundImage;

@property (nonatomic,assign) BOOL dismissFirst;

/**设置描述文字行高*/
@property(nonatomic,assign) CGFloat subTitleLineHeight;

-(void)setLeftBtnWordStyle:(MTWordStyle*)style;
-(void)setRightBtnWordStyle:(MTWordStyle*)style;
-(void)setTitleWordStyle:(MTWordStyle*)style;
-(void)setSubTitleWordStyle:(MTWordStyle*)style;
-(void)setAlertViewStyle:(MTBorderStyle*)style backgroundColor:(UIColor*)color;

-(instancetype)initWithAlertStyle:(MTAlertStyle*)style;


/**使用指定Vc来Alert，默认为根控制器*/
-(void)alertUse:(UIViewController*)vc Completion:(void (^)(void))completion;
-(void)alertUse:(UIViewController*)vc;
-(void)alert;
-(void)alertCompletion:(void (^)(void))completion;

@end
