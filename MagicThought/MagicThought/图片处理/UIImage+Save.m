//
//  UIImage+Save.m
//  8kqw
//
//  Created by 王奕聪 on 2017/5/17.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "UIImage+Save.h"
#import "NSData+File.h"

@implementation UIImage (Save)

+(UIImage*)imageWithPath:(NSString*)directoryPath
{
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:directoryPath]];
}

-(BOOL)saveTo:(NSString*)directoryPath Name:(NSString*)name Zip:(CGFloat)zip
{
    return [UIImageJPEGRepresentation(self, zip) writeToDirectory:directoryPath File:name atomically:YES];
}

-(BOOL)saveTo:(NSString*)directoryPath Name:(NSString*)name
{
    return [self saveTo:directoryPath Name:name Zip:1];
}

/**
 *  压缩图片到指定文件大小
 *
 *
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressWithMaxDataSizeMBytes:(CGFloat)size{
    
    NSData* data;
    CGFloat dataKBytes = 0.0;
    CGFloat lastDataKBytes;
    CGFloat maxQuality = 0.9f;
    
    //转成KB
    size = size * 1000;
    do
    {
        lastDataKBytes = dataKBytes;
        data = UIImageJPEGRepresentation(self, maxQuality);
        dataKBytes = data.length / 1000.0;
        maxQuality -= 0.01f;
        
    }while (dataKBytes > size && maxQuality > 0.01f && lastDataKBytes != dataKBytes);
    
    return data;
}

@end
