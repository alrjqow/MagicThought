//
//  MTConst.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTConst.h"
#import "UIDevice+DeviceInfo.h"

CGFloat kStatusBarHeight_mt()
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

CGFloat kNavigationBarHeight_mt()
{
    return [UIDevice isHairScreen] ? 88 : 64;
}

CGFloat kTabBarHeight_mt()
{
    return [UIDevice isHairScreen] ? 83 : 49;
}

CGFloat kScreenWidth_mt()
{
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat kScreenHeight_mt()
{
    return [UIScreen mainScreen].bounds.size.height;
}



NSString* mt_IphoneScreen()
{
    return [UIDevice iPhoneScreen];
}

BOOL mt_IPhoneSmallScreen()
{
    return mt_IPhoneScreen_3P5() || mt_IPhoneScreen_4P0();
}

BOOL mt_IPhoneScreen_3P5()
{
    return mt_IphoneScreen() == IPhoneScreen_3P5;
}

BOOL mt_IPhoneScreen_4P0()
{
    return mt_IphoneScreen() == IPhoneScreen_4P0;
}

BOOL mt_IPhoneScreen_4P7()
{
    return mt_IphoneScreen() == IPhoneScreen_4P7;
}

BOOL mt_IPhoneScreen_4P7_BigMode()
{
    return mt_IphoneScreen() == IPhoneScreen_4P7_BigMode;
}

BOOL mt_IPhoneScreen_5P5()
{
    return mt_IphoneScreen() == IPhoneScreen_5P5;
}

BOOL mt_IPhoneScreen_5P5_BigMode()
{
    return mt_IphoneScreen() == IPhoneScreen_5P5_BigMode;
}

BOOL mt_IPhoneScreen_5P8()
{
    return mt_IphoneScreen() == IPhoneScreen_5P8;
}

BOOL mt_IPhoneScreen_5P8_BigMode()
{
    return mt_IphoneScreen() == IPhoneScreen_5P8_BigMode;
}


UIColor* rgb(NSInteger r, NSInteger g, NSInteger b)
{
    return rgba(r, g, b, 1);
}

UIColor* rgba(NSInteger r, NSInteger g, NSInteger b, CGFloat alpha)
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha];
}

UIColor* hex(NSInteger colorValue)
{
    return hexa(colorValue, 1);
}
UIColor* hexa(NSInteger colorValue, CGFloat alpha)
{
    return [UIColor colorWithRed:(((colorValue) & 0xFF0000) >> 16) / 255.0 green:(((colorValue) & 0xFF00) >> 8) / 255.0 blue:((colorValue) & 0xFF) / 255.0 alpha:alpha];
}

UIFont* mt_font(NSInteger size)
{
    return [UIFont systemFontOfSize:size];
}

/**一周的时间*/
NSInteger MTWeekTime = 604800;
NSInteger MTDayTime = 86400;



BOOL MTDidReceiveMemoryWarning = false;

NSMutableString* mt_appleStoreID = @"";

NSString*  MTUpdateLocationFinishNotification = @"MTUpdateLocationFinishNotification";
NSString*  MTUpdatePositionFinishNotification = @"MTUpdatePositionFinishNotification";
NSString*  MTShadowHideNotification = @"MTShadowHideNotification";

CGFloat MTTopSearchBarMaxHeight = 108;

NSString*  MTLockViewAfterGetGestureResultOrder = @"MTLockViewAfterGetGestureResultOrder";

NSString*  MTGetPhotoFromAlbumOrder = @"MTGetPhotoFromAlbumOrder";
NSString*  MTGetPhotoFromCameraOrder = @"MTGetPhotoFromCameraOrder";

NSString*  MTVideoControllerDidFinishPickingImagesOrder = @"MTVideoControllerDidFinishPickingImagesOrder";
NSString*  MTPhotoPreviewViewCellDownloadImageFinishOrder = @"MTPhotoPreviewViewCellDownloadImageFinishOrder";
NSString*  MTNothingViewOrder = @"MTNothingViewOrder";
NSString*  MTImagePlayViewOrder = @"MTImagePlayViewOrder";
NSString*  MTCountingViewOrder = @"MTCountingViewOrder";
NSString*  MTRoundViewFinishRunningOrder = @"MTRoundViewFinishRunningOrder";
NSString*  MTDragGestureOrder = @"MTDragGestureOrder";
NSString*  MTDragGestureBeganOrder = @"MTDragGestureBeganOrder";
NSString*  MTDragGestureEndOrder = @"MTDragGestureEndOrder";
NSString*  MTDragDeleteOrder = @"MTDragDeleteOrder";
NSString*  MTSpiltViewPanEndOrder = @"MTSpiltViewPanEndOrder";
NSString*  MTPhotoPreviewViewReloadDataOrder = @"MTPhotoPreviewViewReloadDataOrder";
NSString*  MTFormCellTypeClickOrder = @"MTFormCellTypeClickOrder";
NSString*  MTCountButtonDidFinishedCountDownOrder = @"MTCountButtonDidFinishedCountDownOrder";
NSString*  MTTopSearchBarMoveBottomOrder = @"MTTopSearchBarMoveBottomOrder";
NSString*  MTTopSearchBarEndEditingOrder = @"MTTopSearchBarEndEditingOrder";
NSString*  MTTopSearchBarMoveTopOrder = @"MTTopSearchBarMoveTopOrder";
NSString*  MTDelegateTableViewCellEmptyDataOrder = @"MTDelegateTableViewCellEmptyDataOrder";
NSString*  MTScrollViewDidScrollOrder = @"MTScrollViewDidScrollOrder";
NSString*  MTTextFieldValueChangeOrder = @"MTTextFieldValueChangeOrder";


NSString* MTStarViewScoreChangeOrder = @"MTStarViewScoreChangeOrder";

NSString*  MTNetWork_Cancel = @"MTNetWork_Cancel";
NSString*  MTCache_Directory = @"MTCache_Directory";

NSString*  MTExitTime = @"MTExitTime";
NSString*  MTReachability = @"MTReachability";

NSString*  mt_dataCachePath()
{
    return [NSString stringWithFormat:@"%@/dataCache",mt_cachePath()];
}

NSString*  mt_cachePath()
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

NSString*  mt_documentPath()
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
}

NSString*  mt_libraryPath()
{
    return  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                NSUserDomainMask, YES)[0];
}

NSString* mt_AppBulid()
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

NSString* mt_AppVersion()
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

NSString* mt_AppName()
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

NSString* mt_BundleID()
{
    return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleIdentifier"];
}

void mt_GoToAppStore()
{
    if(mt_appleStoreID.length <= 0)
        return;
    //    已经上架的APP的URL
    NSString *trackViewUrl = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", mt_appleStoreID];
    
    NSURL *url= [NSURL URLWithString:trackViewUrl];
    if([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];    
}

CGFloat mt_ScreenW()
{
    return [UIApplication sharedApplication].keyWindow.bounds.size.width;
}

CGFloat mt_ScreenH()
{
    return [UIApplication sharedApplication].keyWindow.bounds.size.height;
}

UIWindow* mt_Window()
{
    return [UIApplication sharedApplication].keyWindow;
}

UIViewController* mt_rootViewController()
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

CGFloat mt_iOSVersion()
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}




/**产品型号*/
NSString *const Device_Simulator = @"Simulator";

NSString *const Device_AirPods1 = @"AirPods (1st generation)";
NSString *const Device_AirPods2 = @"AirPods (2nd generation)";
NSString *const Device_AirPodsPro1 = @"AirPods Pro";

NSString *const Device_AppleTV2 = @"Apple TV (2nd generation)";
NSString *const Device_AppleTV3 = @"Apple TV (3rd generation)";
NSString *const Device_AppleTV4 = @"Apple TV (4th generation)";
NSString *const Device_AppleTV4K = @"Apple TV 4K";

NSString *const Device_AppleWatch1 = @"Apple Watch (1st generation)";
NSString *const Device_AppleWatchSeries1 = @"Apple Watch Series 1";
NSString *const Device_AppleWatchSeries2 = @"Apple Watch Series 2";
NSString *const Device_AppleWatchSeries3 = @"Apple Watch Series 3";
NSString *const Device_AppleWatchSeries4 = @"Apple Watch Series 4";

NSString *const Device_HomePod1 = @"HomePod";

NSString *const Device_iPodTouch1 = @"iPod touch";
NSString *const Device_iPodTouch2 = @"iPod touch (2nd generation)";
NSString *const Device_iPodTouch3 = @"iPod touch (3rd generation)";
NSString *const Device_iPodTouch4 = @"iPod touch (4th generation)";
NSString *const Device_iPodTouch5 = @"iPod touch (5th generation)";
NSString *const Device_iPodTouch6 = @"iPod touch (6th generation)";
NSString *const Device_iPodTouch7 = @"iPod touch (7th generation)";

NSString *const Device_iPad1 = @"iPad";
NSString *const Device_iPad2 = @"iPad 2";
NSString *const Device_iPad3 = @"iPad (3rd generation)";
NSString *const Device_iPad4 = @"iPad (4th generation)";
NSString *const Device_iPad5 = @"iPad (5th generation)";
NSString *const Device_iPad6 = @"iPad (6th generation)";
NSString *const Device_iPad7 = @"iPad (7th generation)";
NSString *const Device_iPadAir1 = @"iPad Air";
NSString *const Device_iPadAir2 = @"iPad Air 2";
NSString *const Device_iPadAir3 = @"iPad Air (3rd generation)";
NSString *const Device_iPadPro1 = @"iPad Pro (9.7-inch)";
NSString *const Device_iPadProMax1 = @"iPad Pro (12.9-inch)";
NSString *const Device_iPadPro2 = @"iPad Pro (10.5-inch)";;
NSString *const Device_iPadProMax2 = @"iPad Pro (12.9-inch) (2nd generation)";
NSString *const Device_iPadPro3 = @"iPad Pro (11-inch)";
NSString *const Device_iPadProMax3 = @"iPad Pro (12.9-inch) (3rd generation)";
NSString *const Device_iPadMini1 = @"iPad mini";
NSString *const Device_iPadMini2 = @"iPad mini 2";
NSString *const Device_iPadMini3 = @"iPad mini 3";
NSString *const Device_iPadMini4 = @"iPad mini 4";
NSString *const Device_iPadMini5 = @"iPad mini (5th generation)";

NSString *const Device_iPhone1 = @"iPhone";
NSString *const Device_iPhone3G = @"iPhone 3G";
NSString *const Device_iPhone3GS = @"iPhone 3GS";
NSString *const Device_iPhone4 = @"iPhone 4";
NSString *const Device_iPhone4S = @"iPhone 4S";
NSString *const Device_iPhone5 = @"iPhone 5";
NSString *const Device_iPhone5S = @"iPhone 5S";
NSString *const Device_iPhone5C = @"iPhone 5C";
NSString *const Device_iPhone6 = @"iPhone 6";
NSString *const Device_iPhone6Plus = @"iPhone 6 Plus";
NSString *const Device_iPhone6S = @"iPhone 6S";
NSString *const Device_iPhone6SPlus = @"iPhone 6S Plus";
NSString *const Device_iPhoneSE = @"iPhone SE";
NSString *const Device_iPhone7 = @"iPhone 7";
NSString *const Device_iPhone7Plus = @"iPhone 7 Plus";
NSString *const Device_iPhone8 = @"iPhone 8";
NSString *const Device_iPhone8Plus = @"iPhone 8 Plus";
NSString *const Device_iPhoneX = @"iPhone X";
NSString *const Device_iPhoneXS = @"iPhone XS";
NSString *const Device_iPhoneXR = @"iPhone XR";
NSString *const Device_iPhoneXSMax = @"iPhone XS Max";
NSString *const Device_iPhone11 = @"iPhone 11";
NSString *const Device_iPhone11Pro = @"iPhone 11 Pro";
NSString *const Device_iPhone11ProMax = @"iPhone 11 Pro Max";




NSString *const IPhoneScreen_3P5 = @"IPhoneScreen_3P5";
NSString *const IPhoneScreen_4P0 = @"IPhoneScreen_4P0";
NSString *const IPhoneScreen_4P7 = @"IPhoneScreen_4P7";
NSString *const IPhoneScreen_4P7_BigMode = @"IPhoneScreen_4P7_BigMode";
NSString *const IPhoneScreen_5P5 = @"IPhoneScreen_5P5";
NSString *const IPhoneScreen_5P5_BigMode = @"IPhoneScreen_5P5_BigMode";
NSString *const IPhoneScreen_5P8 = @"IPhoneScreen_5P8";
NSString *const IPhoneScreen_5P8_BigMode = @"IPhoneScreen_5P8_BigMode";
NSString *const IPhoneScreen_6P1 = @"IPhoneScreen_6P1";
NSString *const IPhoneScreen_6P5 = @"IPhoneScreen_6P5";

NSString *const Device_Unrecognized = @"?unrecognized?";

