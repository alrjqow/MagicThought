//
//  MTTimer.m
//  8kqw
//
//  Created by 王奕聪 on 2017/3/23.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTTimer.h"

@implementation MTTimer

+(NSDate*)getCurrentDate
{
    NSDate* date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
//    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
//    date = [date dateByAddingTimeInterval:time];
    
    return date;
}

+(NSString*)getTimeWithCurrentDateAndFormat:(NSString*)format
{
    return [self getTimeWithDate:[self getCurrentDate] Format:format];
}

+(NSString*)getTimeWithDate:(NSDate*)date Format:(NSString*)format
{
    NSDateFormatter* formater = [NSDateFormatter new];
    [formater setDateFormat:format ? format : @"YYYY-MM-dd HH:mm:ss"];
    return  [formater stringFromDate:date];
}

+(NSTimeInterval)getCurrentZoneTimeStamp
{
    return [[self getCurrentDate] timeIntervalSince1970];
}

+(NSTimeInterval)getCurrentTimeStamp
{
    return [[NSDate date] timeIntervalSince1970];
}

+(BOOL)dValueBetweenCurrentZoneTimeStampAndLastStamp:(NSInteger)lastStamp IsOver:(NSInteger)time
{
    return  ((NSInteger)[MTTimer getCurrentZoneTimeStamp]) - lastStamp > time;
}

+(NSString*)getStartTimeAccrodingToCurrentDateWithDays:(NSInteger)days
{
    NSTimeInterval stamp = (days - 1) * 24 * 60 * 60;
    
    NSTimeInterval startStamp = [self getCurrentTimeStamp] - stamp;
    
    return [self getTimeWithDate:[NSDate dateWithTimeIntervalSince1970:startStamp] Format:@"YYYY-MM-dd"];
}

@end
