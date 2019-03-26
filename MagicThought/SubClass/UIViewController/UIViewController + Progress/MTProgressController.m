//
//  MTProgressController.m
//  MyTool
//
//  Created by 王奕聪 on 2017/5/22.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTProgressController.h"
#import "LDProgressView.h"
#import "MTConst.h"
#import "Masonry.h"
#import "MTBorderStyle.h"
#import "UILabel+Word.h"
#import "UIColor+ColorfulColor.h"
#import "UIView+Circle.h"

@interface MTProgressController ()

@property(nonatomic,strong) UILabel* progressTitle;

@end

@implementation MTProgressController

-(void)setTitleStyle:(MTWordStyle *)titleStyle
{
    _titleStyle = titleStyle;
    
    [self.progressTitle setWordWithStyle:titleStyle];
}

-(UILabel *)progressTitle
{
    if(!_progressTitle)
    {
        _progressTitle = [UILabel new];
        _progressTitle.textAlignment = NSTextAlignmentCenter;
        _progressTitle.numberOfLines = 0;
    }
    
    return _progressTitle;
}

-(LDProgressView *)progressView
{
    if(!_progressView)
    {
        LDProgressView * progressView = [LDProgressView new];
        
        _progressView = progressView;
    }
    
    return _progressView;
}

-(instancetype)init
{
    if(self = [super init])
    {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

-(void)setupProgressView
{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor colorWithR:240 G:240 B:240 A:0.7];
    [view becomeCircleWithBorder:mt_BorderStyleMake(0, 10, nil)];
    
    [view addSubview:self.progressTitle];
    [view addSubview:self.progressView];
    
    [self.view addSubview:view];
    
    __weak typeof (self) weakSelf = self;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view).with.offset(50);
        make.right.equalTo(weakSelf.view).with.offset(-50);
        make.height.equalTo(@85);
    }];

    [self.progressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view).with.offset(0);
        make.left.equalTo(view).with.offset(15);
        make.right.equalTo(view).with.offset(-15);
        make.height.equalTo(@50);
    }];

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.progressTitle.mas_bottom);
        make.left.equalTo(view).with.offset(15);
        make.right.equalTo(view).with.offset(-15);
        make.bottom.equalTo(view).with.offset(-15);
    }];
}

-(void)alert
{
    [self setupProgressView];
    
    [mt_rootViewController() presentViewController:self animated:YES completion:^{
        
        
    }];
}

-(void)showAutoDismissProgress:(CGFloat)progress
{
    if(progress == 0)
    {
        [self alert];
        return;
    }
    
    if(progress > 1) progress = 1;
    self.progressView.progress = progress;

    
    if(progress >= 1)
        [self dismiss];
}

-(void)showProgress:(CGFloat)progress
{
   if(progress == 0)
   {
       [self alert];
       return;
   }
    
    if(progress > 0.99) progress = 0.99;
    self.progressView.progress = progress;
}

-(void)dismiss
{
    self.progressView.progress = 1;
    __weak typeof (self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        
            weakSelf.progressView.progress = 0;
    }];
}



@end
