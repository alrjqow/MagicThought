//
//  MTConst.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//


#import <UIKit/UIKit.h>

#if !defined(MT_EXTERN)
#  if defined(__cplusplus)
#   define MT_EXTERN extern "C"
#  else
#   define MT_EXTERN extern
#  endif
#endif

#define MT_iPhone4s CGSizeMake(320, 480)
#define MT_iPhone5s CGSizeMake(320, 568)
#define MT_iPhone6s CGSizeMake(375,667)
#define MT_iPhone6sP CGSizeMake(414,736)

typedef BOOL (^MTBlock) (id);

typedef void (^MTHeaderRefreshBlock) (void);

typedef void (^MTFooterRefreshBlock) (void);



MT_EXTERN CGFloat kStatusBarHeight_mt(void);

MT_EXTERN CGFloat kNavigationBarHeight_mt(void);

MT_EXTERN CGFloat kTabBarHeight_mt(void);

MT_EXTERN CGFloat kScreenWidth_mt(void);

MT_EXTERN CGFloat kScreenHeight_mt(void);



MT_EXTERN NSString* mt_IphoneScreen(void);

MT_EXTERN BOOL mt_IPhoneSmallScreen(void);
MT_EXTERN BOOL mt_IPhoneScreen_3P5(void);
MT_EXTERN BOOL mt_IPhoneScreen_4P0(void);

MT_EXTERN BOOL mt_IPhoneScreen_4P7(void);
MT_EXTERN BOOL mt_IPhoneScreen_4P7_BigMode(void);

MT_EXTERN BOOL mt_IPhoneScreen_5P5(void);
MT_EXTERN BOOL mt_IPhoneScreen_5P5_BigMode(void);

MT_EXTERN BOOL mt_IPhoneScreen_5P8(void);
MT_EXTERN BOOL mt_IPhoneScreen_5P8_BigMode(void);

MT_EXTERN UIColor* rgb(NSInteger r, NSInteger g, NSInteger b);
MT_EXTERN UIColor* rgba(NSInteger r, NSInteger g, NSInteger b, CGFloat alpha);




MT_EXTERN UIColor* hex(NSInteger colorValue);
MT_EXTERN UIColor* hexa(NSInteger colorValue, CGFloat alpha);

MT_EXTERN UIFont* mt_font(NSInteger size);

/**一周的时间*/
MT_EXTERN NSInteger MTWeekTime;
/**一天的时间*/
MT_EXTERN NSInteger MTDayTime;

MT_EXTERN NSString*  mt_dataCachePath(void);
MT_EXTERN NSString*  mt_cachePath(void);
MT_EXTERN NSString*  mt_documentPath(void);
MT_EXTERN NSString*  mt_libraryPath(void);

MT_EXTERN NSString*  mt_AppVersion(void);
MT_EXTERN NSString*  mt_AppBulid(void);
MT_EXTERN NSString*  mt_AppName(void);
MT_EXTERN NSString* mt_BundleID(void);
MT_EXTERN void mt_GoToAppStore(void);

MT_EXTERN CGFloat mt_ScreenW(void);
MT_EXTERN CGFloat mt_ScreenH(void);
MT_EXTERN UIWindow* mt_Window(void);
MT_EXTERN UIViewController* mt_rootViewController(void);

MT_EXTERN CGFloat mt_iOSVersion(void);

MT_EXTERN BOOL MTDidReceiveMemoryWarning;

MT_EXTERN NSString*  MTUpdateLocationFinishNotification;
MT_EXTERN NSString*  MTUpdatePositionFinishNotification;
MT_EXTERN NSString*  MTShadowHideNotification;
MT_EXTERN NSString*  MTExitTime;
MT_EXTERN NSString*  MTReachability;


MT_EXTERN NSString*  MTGetPhotoFromAlbumOrder;
MT_EXTERN NSString*  MTGetPhotoFromCameraOrder;
MT_EXTERN NSString*  MTPhotoPreviewViewCellDownloadImageFinishOrder;
MT_EXTERN NSString*  MTNothingViewOrder;
MT_EXTERN NSString*  MTImagePlayViewOrder;
MT_EXTERN NSString*  MTCountingViewOrder;
MT_EXTERN NSString*  MTRoundViewFinishRunningOrder;
MT_EXTERN NSString*  MTDragGestureOrder;
MT_EXTERN NSString*  MTDragGestureBeganOrder;
MT_EXTERN NSString*  MTDragGestureEndOrder;
MT_EXTERN NSString*  MTDragDeleteOrder;
MT_EXTERN NSString*  MTSpiltViewPanEndOrder;
MT_EXTERN NSString*  MTPhotoPreviewViewReloadDataOrder;
MT_EXTERN NSString*  MTFormCellTypeClickOrder;
MT_EXTERN NSString*  MTCountButtonDidFinishedCountDownOrder;
MT_EXTERN NSString*  MTTopSearchBarMoveBottomOrder;
MT_EXTERN NSString*  MTTopSearchBarEndEditingOrder;
MT_EXTERN NSString*  MTTopSearchBarMoveTopOrder;
MT_EXTERN NSString* MTStarViewScoreChangeOrder;
MT_EXTERN NSString*  MTVideoControllerDidFinishPickingImagesOrder;
MT_EXTERN NSString* MTLockViewAfterGetGestureResultOrder;
MT_EXTERN NSString* MTDelegateTableViewCellEmptyDataOrder;
MT_EXTERN NSString* MTScrollViewDidScrollOrder;
MT_EXTERN NSString* MTTextFieldValueChangeOrder;


MT_EXTERN NSString*  MTNetWork_Cancel;

MT_EXTERN NSString*  MTCache_Directory;

MT_EXTERN CGFloat MTTopSearchBarMaxHeight;

//app的数字ID
MT_EXTERN NSMutableString* mt_appleStoreID;

/**产品型号*/
MT_EXTERN NSString *const Device_Simulator;
MT_EXTERN NSString *const Device_iPod1;
MT_EXTERN NSString *const Device_iPod2;
MT_EXTERN NSString *const Device_iPod3;
MT_EXTERN NSString *const Device_iPod4;
MT_EXTERN NSString *const Device_iPod5;
MT_EXTERN NSString *const Device_iPad2;
MT_EXTERN NSString *const Device_iPad3;
MT_EXTERN NSString *const Device_iPad4;
MT_EXTERN NSString *const Device_iPhone4;
MT_EXTERN NSString *const Device_iPhone4S;
MT_EXTERN NSString *const Device_iPhone5;
MT_EXTERN NSString *const Device_iPhone5S;
MT_EXTERN NSString *const Device_iPhone5C;
MT_EXTERN NSString *const Device_iPadMini1;
MT_EXTERN NSString *const Device_iPadMini2;
MT_EXTERN NSString *const Device_iPadMini3;
MT_EXTERN NSString *const Device_iPadAir1;
MT_EXTERN NSString *const Device_iPadAir2;
MT_EXTERN NSString *const Device_iPhone6;
MT_EXTERN NSString *const Device_iPhone6plus;
MT_EXTERN NSString *const Device_iPhone6S;
MT_EXTERN NSString *const Device_iPhone6Splus;
MT_EXTERN NSString *const Device_iPhoneSE;
MT_EXTERN NSString *const Device_iPhone7;
MT_EXTERN NSString *const Device_iPhone7Plus;
MT_EXTERN NSString *const Device_iPhone8;
MT_EXTERN NSString *const Device_iPhone8Plus;
MT_EXTERN NSString *const Device_iPhoneX;
MT_EXTERN NSString *const Device_iPhoneXS;
MT_EXTERN NSString *const Device_iPhoneXR;
MT_EXTERN NSString *const Device_iPhoneXSMax;

MT_EXTERN NSString *const IPhoneScreen_3P5;
MT_EXTERN NSString *const IPhoneScreen_4P0;
MT_EXTERN NSString *const IPhoneScreen_4P7;
MT_EXTERN NSString *const IPhoneScreen_4P7_BigMode;
MT_EXTERN NSString *const IPhoneScreen_5P5;
MT_EXTERN NSString *const IPhoneScreen_5P5_BigMode;
MT_EXTERN NSString *const IPhoneScreen_5P8;
MT_EXTERN NSString *const IPhoneScreen_5P8_BigMode;
MT_EXTERN NSString *const IPhoneScreen_6P1;
MT_EXTERN NSString *const IPhoneScreen_6P5;



MT_EXTERN NSString *const Device_Unrecognized;
