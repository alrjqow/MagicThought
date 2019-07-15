//
//  MTFeedBackInfoController.m
//  SimpleProject
//
//  Created by monda on 2019/6/17.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTFeedBackInfoController.h"

#import "Masonry.h"

#import "UILabel+Word.h"
#import "UILabel+LineSpacing.h"
#import "UIButton+Word.h"
#import "UIView+Circle.h"
#import "UIDevice+DeviceInfo.h"
#import "UINavigationBar+Config.h"

@interface MTFeedBackInfoController ()

@end

@implementation MTFeedBackInfoController

#pragma mark - 生命周期

+(instancetype)ControllerWithInfo:(NSDictionary*)info ClickBlock:(void (^)(id))block
{
    MTFeedBackInfoController* vc = [self new];
    vc.enableSlideBack = [info[@"slideBack"] boolValue];
    vc.imgView.image = [UIImage imageNamed:info[@"img"] ? info[@"img"] : @"success_icon"];
    vc.titleLabel.text = info[@"title"];
    vc.subTitleLabel.text = info[@"content"];
    [vc.enterBtn setTitle:info[@"btnTitle"] forState:UIControlStateNormal];
    vc.enterBtn.hidden = [info[@"btnHidden"] boolValue];
    vc.order = info[@"order"];
    vc.popToController = info[@"popToController"];
    vc.block = block;
    
    return vc;
}


-(void)setupSubview
{
    [super setupSubview];
    
    [self.subTitleLabel setLineSpacing:6];
    
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subTitleLabel];
    [self.view addSubview:self.enterBtn];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@60);
        make.width.equalTo(@60);
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(57 + kNavigationBarHeight_mt());
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.imgView).with.offset(0);
        make.top.equalTo(self.imgView.mas_bottom).with.offset(13);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.imgView).with.offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(13);
    }];
    
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@44);
        make.top.equalTo(self.subTitleLabel.mas_bottom).with.offset(57);
        make.left.equalTo(self.view).with.offset(25);
        make.right.equalTo(self.view).with.offset(-25);
    }];
}

#pragma mark - 网络回调

#pragma mark - 网络请求


#pragma mark - 重载方法

#pragma mark - 点击事件

-(void)enterBtnClick
{
    if(self.block)
        self.block(self);
    else
        [self goBack];
}

#pragma mark - 成员方法


#pragma mark - 代理与数据源


#pragma mark - 懒加载

-(UIImageView *)imgView
{
    if(!_imgView)
    {
        _imgView = [UIImageView new];
    }
    
    return _imgView;
}


-(UILabel *)titleLabel
{
    
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setWordWithStyle:mt_WordStyleMake(17, @"", hex(0x222222))];
    }
    
    return _titleLabel;
}


-(UILabel *)subTitleLabel
{
    if(!_subTitleLabel)
    {
        _subTitleLabel = [UILabel new];
        [_subTitleLabel setWordWithStyle:mt_WordStyleMake(12, @"", hex(0x999999))];
        _subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _subTitleLabel;
}

-(UIButton *)enterBtn
{
    if(!_enterBtn)
    {
        _enterBtn = [UIButton new];
        
        [_enterBtn setWordWithStyle:mt_WordStyleMake(14, @"", hex(0xffffff)).thin(false)];
        [_enterBtn becomeCircleWithBorder:mt_BorderStyleMake(0, 4, nil)];
        _enterBtn.backgroundColor = hex(0x2976f4);
        [_enterBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _enterBtn;
}

@end
