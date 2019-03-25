//
//  MTProgressController.h
//  MyTool
//
//  Created by 王奕聪 on 2017/5/22.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDProgressView;
@class MTWordStyle;
@interface MTProgressController : UIViewController

@property(nonatomic,strong) MTWordStyle* titleStyle;

@property(nonatomic,strong) LDProgressView* progressView;

-(void)showAutoDismissProgress:(CGFloat)progress;

-(void)showProgress:(CGFloat)progress;
-(void)dismiss;

@end
