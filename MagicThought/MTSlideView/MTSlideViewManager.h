//
//  MTSlideViewManager.h
//  MyTool
//
//  Created by 王奕聪 on 2017/4/6.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MTSlideView;
@class MTSlideHeader;
@interface MTSlideViewManager : NSObject

/**
 * 绑定两个view
 */
+ (void)associateHead:(MTSlideHeader *)head
           withScroll:(MTSlideView *)scroll
           completion:(void(^)())completion;

+ (void)associateHead:(MTSlideHeader *)head
           withScroll:(MTSlideView *)scroll
     contentChangeAni:(BOOL)ani
           completion:(void(^)())completion
            selectEnd:(void(^)(NSInteger index))selectEnd;

@end
