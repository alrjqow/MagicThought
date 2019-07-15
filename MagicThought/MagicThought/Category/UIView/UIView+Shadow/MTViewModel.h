//
//  MTViewModel.h
//  MyTool
//
//  Created by 王奕聪 on 2017/3/2.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTViewModel : NSObject

@property(nonatomic,strong) UIView* view;

@property(nonatomic,strong) NSString* sel;

+(instancetype)modelWithView:(UIView*)view Sel:(NSString*)sel;

@end
