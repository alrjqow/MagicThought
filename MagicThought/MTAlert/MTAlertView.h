//
//  MTAlertView.h
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "MTPopView.h"
#import "MTAlertViewConfig.h"

@class MTAlertViewConfig;
@class MTPopButtonItem;

@interface MTAlertView : MTPopView

- (instancetype) initWithConfig:(MTAlertViewConfig*)config;

- (instancetype) initWithConfig:(MTAlertViewConfig*)config CustomView:(UIView*)customView;

@end

@interface NSObject (AlertViewDelegate)<MTDelegateProtocol>

-(void)alertWithTitle:(NSString*)title Content:(NSString*)detail Buttons:(NSArray<MTPopButtonItem*>*)items;

-(void)alertWithLogo:(NSString*)logo Title:(NSString*)title Content:(NSString*)detail Buttons:(NSArray<MTPopButtonItem*>*)items;

-(void)alertWithConfig:(MTAlertViewConfig*)config;

-(void)alertWithConfig:(MTAlertViewConfig*)config CustomView:(UIView*)customView;

@end

/*-----------------------------------华丽分割线-----------------------------------*/

/**自定义小图标和标题*/
NS_INLINE void alerCustomWithLogoAndTitle(NSString* titleLogo, NSString* title, NSString* detail, NSString* buttonText)
{
    MTAlertViewConfig* config = [MTAlertViewConfig new];
    config.title = title;
    config.logoName = titleLogo;
    config.detail = detail;
    if(buttonText)
        config.defaultTextOK = buttonText;
    
    [[[MTAlertView alloc] initWithConfig:config] show];
}
/**自定义小图标和标题*/
NS_INLINE void alertWithLogoAndTitle(NSString* titleLogo, NSString* title, NSString* detail)
{
    alerCustomWithLogoAndTitle(titleLogo, title, detail, nil);
}

/*-----------------------------------华丽分割线-----------------------------------*/

/**自定义小图标*/
NS_INLINE void alertCustomWithLogo(NSString* titleLogo, NSString* detail, NSString* buttonText)
{
    alerCustomWithLogoAndTitle(titleLogo, nil, detail, buttonText);
}
/**自定义小图标*/
NS_INLINE void alertWithLogo(NSString* titleLogo, NSString* detail)
{
    alertCustomWithLogo(titleLogo, detail, nil);
}

/*-----------------------------------华丽分割线-----------------------------------*/

/**自定义标题*/
NS_INLINE void alertCustomWithTitle(NSString* title, NSString* detail, NSString* buttonText)
{
    alerCustomWithLogoAndTitle(nil, title, detail, buttonText);
}

/**自定义标题*/
NS_INLINE void alertWithTitle(NSString* title, NSString* detail)
{
    alertCustomWithTitle(title, detail, nil);
}

/*-----------------------------------华丽分割线-----------------------------------*/

NS_INLINE void alertCustomWithAppName(NSString* detail, NSString* buttonText)
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    
    alerCustomWithLogoAndTitle(nil, app_Name, detail, buttonText);
}

/**标题为应用名*/
NS_INLINE void alertWithAppName(NSString* detail)
{
    alertCustomWithAppName(detail, nil);
}

/*-----------------------------------华丽分割线-----------------------------------*/

NS_INLINE void alertCustom(NSString* detail, NSString* buttonText)
{
    alerCustomWithLogoAndTitle(nil, nil, detail, buttonText);
}

/**无标题*/
NS_INLINE void alert(NSString* detail)
{
    alertCustom(detail, nil);
}
