//
//  MTAlertController.m
//  MyTool
//
//  Created by 王奕聪 on 2017/4/10.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTAlertController.h"
#import "Masonry.h"
#import "MTConst.h"

#import "UIView+Circle.h"
#import "UIColor+ColorfulColor.h"
#import "NSString+Exist.h"
#import "UILabel+Word.h"
#import "UIButton+Word.h"
#import "UILabel+LineSpacing.h"

@interface MTAlertController ()

@property(nonatomic,strong) UIView* alertView;
@property(nonatomic,strong) UIImageView* backgroundView;

@property(nonatomic,strong) UIButton* leftBtn;
@property(nonatomic,strong) UIButton* rightBtn;

@property(nonatomic,weak) UILabel* titleLabel;
@property(nonatomic,weak) UILabel* subTitleLabel;

@property(nonatomic,strong) MTAlertStyle* style;


@end

@implementation MTAlertController



-(void)setAlertBackgroundImage:(UIImage *)alertBackgroundImage
{
    if(!alertBackgroundImage) return;
    
    self.backgroundView.image = alertBackgroundImage;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        UIButton* btn = [UIButton new];
        btn.translatesAutoresizingMaskIntoConstraints = false;
//        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:[self.style.leftStatement isExist] ? self.style.leftStatement : @"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0xFF6B4F] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        
        _leftBtn = btn;
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        UIButton* btn = [UIButton new];
        btn.translatesAutoresizingMaskIntoConstraints = false;
//        btn.backgroundColor = [UIColor blueColor];
        BOOL isDouble = self.style.type == MTAlertTypeDoubleButton;
        NSString* title;
        if(isDouble)
            title = self.style.rightStatement;
        else
        {
            title = self.style.leftStatement;
            if(![title isExist])
                title = self.style.rightStatement;
        }
        [btn setTitle:[title isExist] ? title : @"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x1F7DFF] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        
        _rightBtn = btn;
    }
    return _rightBtn;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    UIButton *btn = (UIButton *)object;
    if ([keyPath isEqualToString:@"highlighted"]) {
            [btn setBackgroundColor:btn.highlighted ? [UIColor colorWithR:242 G:242 B:242] : [UIColor clearColor]];        
    }
}

-(UIImageView *)backgroundView
{
    if(!_backgroundView)
    {
        UIImageView* imgView = [UIImageView new];
        UIImage* image = self.style.type == MTAlertTypeDoubleButton ? [UIImage imageNamed:@"MTAlertController.bundle/bg2"] : [UIImage imageNamed:@"MTAlertController.bundle/bg1"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(71, 0, 60, 0) resizingMode:UIImageResizingModeStretch];
        imgView.image = image;
        
        _backgroundView = imgView;
    }
    return _backgroundView;
}

-(UIView *)alertView
{
    if(!_alertView)
    {
        UIView* alertView = [UIView new];
        alertView.backgroundColor = [UIColor colorWithR:249 G:249 B:249];
        alertView.clipsToBounds = YES;
        alertView.bounds = CGRectMake(0, 0, 280, 170);
        _alertViewSize = alertView.bounds.size;
        [alertView becomeCircleWithBorder:mt_BorderStyleMake(0, 13, nil)];
        
        [alertView addSubview:self.backgroundView];
        
        UILabel* label = [UILabel new];
        label.text = self.style.title;
        label.font = [UIFont systemFontOfSize:21 weight:0.3];
        label.textColor = [UIColor colorWithR:20 G:20 B:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [alertView addSubview:label];
        self.titleLabel = label;
        
        UILabel* subLabel = [UILabel new];
        subLabel.translatesAutoresizingMaskIntoConstraints = false;
        subLabel.text = self.style.subTitle;
        subLabel.font = [UIFont systemFontOfSize:16];
        subLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        subLabel.numberOfLines = 0;
        if(self.subTitleLineHeight)
            [subLabel setLineSpacing:self.subTitleLineHeight];
//        subLabel.backgroundColor = [UIColor redColor];
        subLabel.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:subLabel];
        self.subTitleLabel = subLabel;
        
        
        BOOL isDouble = self.style.type == MTAlertTypeDoubleButton;
        
        if(isDouble)
            [alertView addSubview:self.leftBtn];
        [alertView addSubview:self.rightBtn];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(alertView);
            make.height.equalTo(@40);
            make.top.equalTo(alertView).with.offset(12);
        }];
        
        [alertView addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:subLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6],
                               [NSLayoutConstraint constraintWithItem:subLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15],
                               [NSLayoutConstraint constraintWithItem:subLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:alertView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50],
                               [NSLayoutConstraint constraintWithItem:subLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15]
                               ]];
        
    
        
        [self.backgroundView  mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(alertView);
        }];

        if(isDouble)
            [alertView addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.leftBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50],
                                    [NSLayoutConstraint constraintWithItem:self.leftBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.leftBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.leftBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]
                                    ]];

        NSLayoutConstraint* constraint = isDouble ? [NSLayoutConstraint constraintWithItem:self.rightBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0] : [NSLayoutConstraint constraintWithItem:self.rightBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [alertView addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.rightBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50],
                                    constraint,
                                    [NSLayoutConstraint constraintWithItem:self.rightBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.rightBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
                                    ]];
     
        _alertView = alertView;
    }
    return _alertView;
}


-(void)setAlertViewSize:(CGSize)alertViewSize
{
    if(!alertViewSize.width || !alertViewSize.height)
        return;
    
    _alertViewSize = alertViewSize;
    self.alertView.bounds = CGRectMake(0, 0, alertViewSize.width, alertViewSize.height);
}

-(instancetype)init
{
    if(self = [super init])
    {
        _alertViewSize = CGSizeMake(280, 170);
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

-(instancetype)initWithAlertStyle:(MTAlertStyle*)style
{
    if(self = [super init])
    {
        _alertViewSize = CGSizeMake(280, 170);
        self.style = style;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

#pragma mark - 生命周期

-(void)dealloc
{    
        [_leftBtn removeObserver:self forKeyPath:@"highlighted"];
        [_rightBtn removeObserver:self forKeyPath:@"highlighted"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupProperty];
}

#pragma mark - 初始化

-(void)setupProperty
{
    self.view.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.2];
    
    [self setupNavigationItem];
    [self setupSubView];
}

-(void)setupNavigationItem
{
    
}

-(void)setupSubView
{
    [self.view addSubview:self.alertView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.alertView.center = self.view.center;
}

#pragma mark - 点击

#pragma mark - 布局子控件

#pragma mark - 成员方法

-(void)alertUse:(UIViewController*)vc Completion:(void (^)())completion
{
    [vc presentViewController:self animated:YES completion:completion];
}

-(void)alertUse:(UIViewController*)vc
{
    [self alertUse:vc Completion:nil];
}

-(void)alert
{
    [self alertUse:mt_rootViewController()];
}

-(void)alertCompletion:(void (^)())completion
{
    [self alertUse:mt_rootViewController() Completion:completion];    
}

-(void)setAlertViewStyle:(MTBorderStyle*)style backgroundColor:(UIColor*)color
{
    [self.alertView becomeCircleWithBorder:style];
    if(color)
        self.alertView.backgroundColor = color;
}

-(void)setTitleWordStyle:(MTWordStyle*)style
{
    if(![style.wordName isExist]) style.wordName = self.titleLabel.text;
    [self.titleLabel setWordWithStyle:style];
}
-(void)setSubTitleWordStyle:(MTWordStyle*)style
{
    if(![style.wordName isExist]) style.wordName = self.subTitleLabel.text;
    
    style.horizontalAlignment = NSTextAlignmentCenter;
    [self.subTitleLabel setWordWithStyle:style];
}

-(void)setLeftBtnWordStyle:(MTWordStyle*)style
{
    if(![style.wordName isExist]) style.wordName = self.leftBtn.titleLabel.text;
    [self.leftBtn setWordWithStyle:style];
}

-(void)setRightBtnWordStyle:(MTWordStyle*)style
{
    if(![style.wordName isExist]) style.wordName = self.rightBtn.titleLabel.text;
    [self.rightBtn setWordWithStyle:style];
}

-(void)leftBtnClick:(UIButton*)btn
{
    if(self.dismissFirst)
    {
            __weak __typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:false completion:^{
            if(weakSelf.doSomethingTapLeft)
                weakSelf.doSomethingTapLeft();
        }];
        return;
    }
    
    if(self.doSomethingTapLeft)
        self.doSomethingTapLeft();
    
    [self dismissViewControllerAnimated:false completion:nil];
}

-(void)rightBtnClick:(UIButton*)btn
{
    if(self.dismissFirst)
    {
        __weak __typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:false completion:^{
            if(weakSelf.doSomethingTapRight)
                weakSelf.doSomethingTapRight();
        }];
        return;
    }
    
    if(self.doSomethingTapRight)
        self.doSomethingTapRight();
    
      [self dismissViewControllerAnimated:false completion:nil];
}


#pragma mark - 数据源



#pragma mark - 代理



@end
