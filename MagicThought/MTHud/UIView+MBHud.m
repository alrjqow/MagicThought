//
//  UIView+MBHud.m
//  ActivityIndicator
//
//  Created by 王奕聪 on 2018/2/11.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "UIView+MBHud.h"
#import "MTIndicatorView.h"

#import "MBProgressHUD.h"
#import "objc/runtime.h"

#import "UIColor+ColorfulColor.h"
#import "UIView+Frame.h"
#import "UIImage+Size.h"
#import "MTConst.h"


@implementation UIView (MBHud)


/**显示toast*/
-(void)showToast:(NSString*)msg
{
    MBProgressHUD* hud = [self createToastHudWithOffset:CGPointMake(0.f, (mt_Window().height / 2 -120))];
    hud.label.text = msg;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2.f];
}
-(void)showCenterToast:(NSString*)msg
{
    MBProgressHUD* hud = [self createToastHudWithOffset:CGPointZero];
    hud.label.text = msg;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2.f];
}


/**显示成功*/
-(void)showSuccess:(NSString*)msg
{
    UIImage* img = [UIImage imageNamed:@"mthud_success"];
    [self showCustomViewWithImageName: (img ? img : @"MTHUD.bundle/success") Msg:msg];
}

/**显示错误*/
-(void)showError:(NSString*)msg
{
    UIImage* img = [UIImage imageNamed:@"mthud_error"];
    [self showCustomViewWithImageName: (img ? img : @"MTHUD.bundle/error") Msg:msg];
}

/**显示提示*/
-(void)showTips:(NSString*)msg
{
    UIImage* img = [UIImage imageNamed:@"mthud_info"];
    [self showCustomViewWithImageName: (img ? img : @"MTHUD.bundle/info") Msg:msg];
}

/**显示圈圈*/
-(void)showMsg:(NSString*)msg
{
    MBProgressHUD* hud = [self createHud];
    
    if(self.mt_hudStyle == MBHudStyleDefault)
    {
        hud.customView = [self createTipsView];
        hud.mode = MBProgressHUDModeCustomView;
    }    
    else
        hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.label.text = msg;
    [hud showAnimated:YES];
}

/**隐藏提示*/
-(void)dismissIndicator
{
    MBProgressHUD* hud = [MBProgressHUD HUDForView:self];
    [hud hideAnimated:YES];
}


-(MBProgressHUD*)createHud
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if(!hud)
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.removeFromSuperViewOnHide = YES;
        hud.label.numberOfLines = 0;
        hud.label.font = [UIFont systemFontOfSize:15];
        hud.offset = CGPointMake(0, -50);
        hud.square = false; //设置宽高不相等
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.mode = MBProgressHUDModeCustomView;
        
        [self addSubview:hud];
    }
    
    switch (self.mt_hudStyle) {
        case MBHudStyleBlack:
        {
//            hud.margin = 15;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
            hud.bezelView.color = [UIColor blackColor];
            hud.contentColor = [UIColor whiteColor];
            break;
        }
            
        default:
        {
//            hud.margin = 12;
            hud.bezelView.color = [UIColor colorWithR:255 G:255 B:255 A:1];
            hud.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.3];
            hud.contentColor = [UIColor colorWithHex:0x333333];
            break;
        }
    }
    
  
    return hud;
}

-(MBProgressHUD*)createToastHudWithOffset:(CGPoint)offset
{
    [MBProgressHUD hideHUDForView:self animated:YES];
      
      MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self];
      hud.removeFromSuperViewOnHide = YES;
      [self addSubview:hud];
      hud.bezelView.color = [UIColor colorWithR:0 G:0 B:0 A:1];
      hud.contentColor = [UIColor whiteColor];
      hud.label.numberOfLines = 0;
      if (@available(iOS 8.2, *)) {
          hud.label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
      } else {
          hud.label.font = [UIFont systemFontOfSize:15];
      }
      hud.offset = offset;
      hud.mode = MBProgressHUDModeText;
      hud.animationType = MBProgressHUDAnimationZoom;
      hud.margin = 12;
      
      return hud;
}

-(UIImageView*)createTipsView
{
    CGFloat w = 50;
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[[UIImage new] changeToSize:CGSizeMake(w, w)]];
    
    MTIndicatorView* view = [MTIndicatorView new];
    view.strokeColor = [UIColor blackColor];
    view.strokeThickness = 2;
    view.radius = 20;
    view.bounds = CGRectMake(0, 0, w, w);
    view.center = imgView.center;
    [imgView addSubview:view];
    
    return imgView;
}

/**展示一张图片的自定义View*/
-(void)showCustomViewWithImageName:(NSObject*)imageName Msg:(NSString*)msg
{
//    MBHudStyle style =  self.mt_hudStyle;
//    self.mt_hudStyle = MBHudStyleDefault;
    MBProgressHUD* hud = [self createHud];
    
    UIImage *image;
    if([imageName isKindOfClass:[UIImage class]])
        image = (UIImage*)imageName;
    else if([imageName isKindOfClass:[NSString class]])
    {
        if(self.mt_hudStyle == MBHudStyleBlack)
            imageName = [(NSString*)imageName stringByAppendingString:@"_black"];
        image = [[UIImage imageNamed:(NSString*)imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = msg;
    hud.mode = MBProgressHUDModeCustomView;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2.f];
//    self.mt_hudStyle = style;
}



#pragma mark - 懒加载

static const void *mtHudStyleKey = @"mtHudStyleKey";

-(MBHudStyle)mt_hudStyle
{
    return ((NSNumber*)objc_getAssociatedObject(self, mtHudStyleKey)).integerValue;
}

-(void)setMt_hudStyle:(MBHudStyle)mt_hudStyle
{
    objc_setAssociatedObject(self, mtHudStyleKey, @(mt_hudStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



@implementation UIViewController (MBHud)

/**显示成功*/
-(instancetype)showSuccess:(NSString*)msg
{
    [self.view showSuccess:msg];
    return self;
}

/**显示错误*/
-(instancetype)showError:(NSString*)msg
{
    [self.view showError:msg];
    return self;
}

/**显示提示*/
-(instancetype)showTips:(NSString*)msg
{
    [self.view showTips:msg];
    return self;
}

/**显示toast*/
-(instancetype)showToast:(NSString*)msg
{
    [self.view showToast:msg];
    return self;
}
-(instancetype)showCenterToast:(NSString*)msg
{
    [self.view showCenterToast:msg];
    return self;
}

/**显示圈圈*/
-(instancetype)showMsg:(NSString*)msg
{
    [self.view showMsg:msg];
    return self;
}

/**隐藏提示*/
-(instancetype)dismissIndicator
{
    [self.view dismissIndicator];
    return self;
}

#pragma mark - 懒加载
-(void)setMt_hudStyle:(MBHudStyle)mt_hudStyle
{
    self.view.mt_hudStyle = mt_hudStyle;
}

-(MBHudStyle)mt_hudStyle
{
    return self.view.mt_hudStyle;
}

@end
