//
//  UIDevice+DeviceInfo.m
//  8kqw
//
//  Created by 王奕聪 on 2017/9/9.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "UIDevice+DeviceInfo.h"
#import "NSString+Exist.h"
#import "MTConst.h"
#import "SAMKeychain/SAMKeychain.h"

#import <sys/utsname.h>

@implementation UIDevice (DeviceInfo)

+(NSString*)UUID
{
    
    NSString *UUID = [SAMKeychain passwordForService:mt_BundleID() account:@"uuid"];
    if(!UUID)
    {
        UUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [SAMKeychain setPassword: UUID forService:mt_BundleID() account:@"uuid"];
    }
    
    return UUID;
}

+(CGFloat)iosVersionNumber
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(NSString*)iosVersion;
{
    return [NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]];
}

+(NSString *) appleDevice
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    //    NSLog(@"%@",code);
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{
                              @"i386"      : Device_Simulator,
                              @"x86_64"    : Device_Simulator,
                              @"iPod1,1"   : Device_iPod1,
                              @"iPod2,1"   : Device_iPod2,
                              @"iPod3,1"   : Device_iPod3,
                              @"iPod4,1"   : Device_iPod4,
                              @"iPod5,1"   : Device_iPod5,
                              @"iPad2,1"   : Device_iPad2,
                              @"iPad2,2"   : Device_iPad2,
                              @"iPad2,3"   : Device_iPad2,
                              @"iPad2,4"   : Device_iPad2,
                              @"iPad2,5"   : Device_iPadMini1,
                              @"iPad2,6"   : Device_iPadMini1,
                              @"iPad2,7"   : Device_iPadMini1,
                              @"iPhone3,1" : Device_iPhone4,
                              @"iPhone3,2" : Device_iPhone4,
                              @"iPhone3,3" : Device_iPhone4,
                              @"iPhone4,1" : Device_iPhone4S,
                              @"iPhone5,1" : Device_iPhone5,
                              @"iPhone5,2" : Device_iPhone5,
                              @"iPhone5,3" : Device_iPhone5C,
                              @"iPhone5,4" : Device_iPhone5C,
                              @"iPad3,1"   : Device_iPad3,
                              @"iPad3,2"   : Device_iPad3,
                              @"iPad3,3"   : Device_iPad3,
                              @"iPad3,4"   : Device_iPad4,
                              @"iPad3,5"   : Device_iPad4,
                              @"iPad3,6"   : Device_iPad4,
                              @"iPhone6,1" : Device_iPhone5S,
                              @"iPhone6,2" : Device_iPhone5S,
                              @"iPad4,1"   : Device_iPadAir1,
                              @"iPad4,2"   : Device_iPadAir2,
                              @"iPad4,4"   : Device_iPadMini2,
                              @"iPad4,5"   : Device_iPadMini2,
                              @"iPad4,6"   : Device_iPadMini2,
                              @"iPad4,7"   : Device_iPadMini3,
                              @"iPad4,8"   : Device_iPadMini3,
                              @"iPad4,9"   : Device_iPadMini3,
                              @"iPhone7,1" : Device_iPhone6plus,
                              @"iPhone7,2" : Device_iPhone6,
                              @"iPhone8,1" : Device_iPhone6S,
                              @"iPhone8,2" : Device_iPhone6Splus,
                              @"iPhone8,4" : Device_iPhoneSE,
                              @"iPhone9,1" : Device_iPhone7,
                              @"iPhone9,2" : Device_iPhone7Plus,
                              @"iPhone9,3" : Device_iPhone7,
                              @"iPhone9,4" : Device_iPhone7Plus,
                              @"iPhone10,1" :Device_iPhone8,
                              @"iPhone10,4" :Device_iPhone8,
                              @"iPhone10,2" : Device_iPhone8Plus,
                              @"iPhone10,5" : Device_iPhone8Plus,
                              @"iPhone10,3" : Device_iPhoneX,
                              @"iPhone10,6" : Device_iPhoneX,
                              @"iPhone11,2" : Device_iPhoneXS,
                              @"iPhone11,4" : Device_iPhoneXSMax,
                              @"iPhone11,6" : Device_iPhoneXSMax,
                              @"iPhone11,8" : Device_iPhoneXR,
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    if(deviceName){
        return deviceName;
    }
    
    return Device_Unrecognized;
}

+ (BOOL)isIphoneX {
    static NSInteger isFinish = -1;
    
    if(isFinish > -1)
        return isFinish == 1;
    
    NSString* device = [self appleDevice];
    
    if(device != Device_iPhoneX && device != Device_Simulator)
        isFinish = 0;
    
    if(device == Device_iPhoneX)
        isFinish = 1;
    
    isFinish = (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    
    return isFinish == 1;
}

+ (BOOL)isHairScreen {
    static NSInteger isFinish = -1;

    if(isFinish > -1)
        return isFinish == 1;
    
    NSString* device = [self appleDevice];
    
    if(device != Device_iPhoneX && device != Device_Simulator)
        isFinish = 0;
    
    if(device == Device_iPhoneX || device == Device_iPhoneXS || device == Device_iPhoneXSMax || device == Device_iPhoneXR)
        isFinish = 1;
    
    if(device == Device_Simulator)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        isFinish = CGSizeEqualToSize(size, CGSizeMake(375, 812)) ||
                    CGSizeEqualToSize(size, CGSizeMake(812, 375)) || CGSizeEqualToSize(CGSizeMake(414, 896), size) || CGSizeEqualToSize(CGSizeMake(896, 414), size);
    }
    
    return isFinish == 1;
}

+(NSString*)iPhoneScreen
{
    static NSString* screen = @"";
    if([screen isExist])
        return screen;
    

    CGSize size = [UIScreen mainScreen].bounds.size;
    screen = IPhoneScreen_4P7;
    
    if(CGSizeEqualToSize(CGSizeMake(320, 480), size) || CGSizeEqualToSize(CGSizeMake(480, 320), size))
        screen = IPhoneScreen_3P5;
    
    if(CGSizeEqualToSize(CGSizeMake(320, 568), size) || CGSizeEqualToSize(CGSizeMake(568, 320), size))
        screen = [[UIScreen mainScreen] scale] == [[UIScreen mainScreen] nativeScale] ? IPhoneScreen_4P0 : IPhoneScreen_4P7_BigMode;
            
    if(CGSizeEqualToSize(CGSizeMake(375, 667), size) || CGSizeEqualToSize(CGSizeMake(667, 375), size))
        screen =  [UIScreen mainScreen].scale > 2 ? IPhoneScreen_5P5_BigMode : IPhoneScreen_4P7;
    
    if(CGSizeEqualToSize(CGSizeMake(414, 736), size) || CGSizeEqualToSize(CGSizeMake(736, 414), size))
        screen = IPhoneScreen_5P5;

    if(CGSizeEqualToSize(CGSizeMake(375, 812), size) || CGSizeEqualToSize(CGSizeMake(812, 375), size))
        screen = IPhoneScreen_5P8;
    
    if(CGSizeEqualToSize(CGSizeMake(414, 896), size) || CGSizeEqualToSize(CGSizeMake(896, 414), size))
        screen = [UIScreen mainScreen].scale > 2 ? IPhoneScreen_6P5 : IPhoneScreen_6P1;
    
    return screen;
}

+(CGFloat)adjustFloatAccordingToScreen:(NSArray<NSNumber*>*)arr
{
    if(!arr.count)
        return 0;
 
    NSArray* screenArr = @[IPhoneScreen_4P7, IPhoneScreen_4P0, IPhoneScreen_5P5, IPhoneScreen_5P8, IPhoneScreen_3P5, IPhoneScreen_4P7_BigMode, IPhoneScreen_5P5_BigMode, IPhoneScreen_5P8_BigMode];
    
    NSString* screen = [self iPhoneScreen];
    NSInteger index = 0;
    
    for(NSInteger i = 0; i < screenArr.count; i++)
    {
        if(screen != screenArr[i]) continue;
        
        index = i;
        if(index == 5)
            index = index < arr.count ? index : 1;
        
        return index < arr.count ? arr[index].floatValue : arr[0].floatValue;
    }
    
    return arr[0].floatValue;
}

@end

