//
//  MTDefine.h
//  手势解锁
//
//  Created by monda on 2018/3/21.
//  Copyright © 2018年 王奕聪. All rights reserved.
//

#import "UIDevice+DeviceInfo.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define rgb(r,g,b) rgba(r,g,b,1)

#define hexa(r,a) [UIColor colorWithRed:(((r) & 0xFF0000) >> 16) / 255.0 green:(((r) & 0xFF00) >> 8) / 255.0 blue:((r) & 0xFF) / 255.0 alpha:(a)]
#define hex(r) hexa(r,1)

#define mt_font(f) [UIFont systemFontOfSize:f]

#define mt_IphoneScreen [UIDevice iPhoneScreen]
#define mt_IPhoneSmallScreen (mt_IPhoneScreen_3P5 || mt_IPhoneScreen_4P0)
#define mt_IPhoneScreen_3P5 (mt_IphoneScreen == IPhoneScreen_3P5)
#define mt_IPhoneScreen_4P0 (mt_IphoneScreen == IPhoneScreen_4P0)
#define mt_IPhoneScreen_4P7 (mt_IphoneScreen == IPhoneScreen_4P7)
#define mt_IPhoneScreen_4P7_BigMode (mt_IphoneScreen == IPhoneScreen_4P7_BigMode)
#define mt_IPhoneScreen_5P5 (mt_IphoneScreen == IPhoneScreen_5P5)
#define mt_IPhoneScreen_5P5_BigMode (mt_IphoneScreen == IPhoneScreen_5P5_BigMode)
#define mt_IPhoneScreen_5P8 (mt_IphoneScreen == IPhoneScreen_5P8)
#define mt_IPhoneScreen_5P8_BigMode (mt_IphoneScreen == IPhoneScreen_5P8_BigMode)


#define kStatusBarHeight_mt [[UIApplication sharedApplication] statusBarFrame].size.height

#define kNavigationBarHeight_mt ([UIDevice isHairScreen] ? 88 : 64)

#define kTabBarHeight_mt ([UIDevice isHairScreen] ? 83 : 49)

#define kScreenWidth_mt [UIScreen mainScreen].bounds.size.width

#define kScreenHeight_mt [UIScreen mainScreen].bounds.size.height


