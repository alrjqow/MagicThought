//
//  UIView+Image.m
//  8kqw
//
//  Created by 王奕聪 on 2017/3/17.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "UIView+Image.h"

@implementation UIView (Image)

- (UIImage *)createViewImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return [UIImage imageWithData:UIImagePNGRepresentation(image)];
}

@end
