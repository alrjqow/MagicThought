//
//  MTConst.m
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import "MTConst.h"

/**一周的时间*/
NSInteger MTWeekTime = 604800;
NSInteger MTDayTime = 86400;



BOOL MTDidReceiveMemoryWarning = false;

NSString* mt_appleStoreID = @"";

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
NSString *const Device_iPod1 = @"iPod1";
NSString *const Device_iPod2 = @"iPod2";
NSString *const Device_iPod3 = @"iPod3";
NSString *const Device_iPod4 = @"iPod4";
NSString *const Device_iPod5 = @"iPod5";
NSString *const Device_iPad2 = @"iPad2";
NSString *const Device_iPad3 = @"iPad3";
NSString *const Device_iPad4 = @"iPad4";
NSString *const Device_iPhone4 = @"iPhone 4";
NSString *const Device_iPhone4S = @"iPhone 4S";
NSString *const Device_iPhone5 = @"iPhone 5";
NSString *const Device_iPhone5S = @"iPhone 5S";
NSString *const Device_iPhone5C = @"iPhone 5C";
NSString *const Device_iPadMini1 = @"iPad Mini 1";
NSString *const Device_iPadMini2 = @"iPad Mini 2";
NSString *const Device_iPadMini3 = @"iPad Mini 3";
NSString *const Device_iPadAir1 = @"iPad Air 1";
NSString *const Device_iPadAir2 = @"iPad Mini 3";
NSString *const Device_iPhone6 = @"iPhone 6";
NSString *const Device_iPhone6plus = @"iPhone 6 Plus";
NSString *const Device_iPhone6S = @"iPhone 6S";
NSString *const Device_iPhone6Splus = @"iPhone 6S Plus";
NSString *const Device_iPhoneSE = @"iPhone SE";
NSString *const Device_iPhone7 = @"iPhone 7";
NSString *const Device_iPhone7Plus = @"iPhone 7 Plus";
NSString *const Device_iPhone8 = @"Device_iPhone8";
NSString *const Device_iPhone8Plus = @"Device_iPhone8Plus";
NSString *const Device_iPhoneX = @"Device_iPhoneX";
NSString *const Device_iPhoneXS = @"Device_iPhoneXS";
NSString *const Device_iPhoneXR = @"Device_iPhoneXR";
NSString *const Device_iPhoneXSMax = @"Device_iPhoneXS Max";

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

