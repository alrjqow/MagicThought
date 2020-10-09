//
//  MTLayout.h
//  QXProject
//
//  Created by monda on 2020/9/9.
//  Copyright © 2020 monda. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MTLayoutFrame : NSObject

@property (nonatomic,strong,readonly) MTLayoutFrame* x;

@property (nonatomic,strong,readonly) MTLayoutFrame* y;

@property (nonatomic,strong,readonly) MTLayoutFrame* top;

@property (nonatomic,strong,readonly) MTLayoutFrame* left;

@property (nonatomic,strong,readonly) MTLayoutFrame* bottom;

@property (nonatomic,strong,readonly) MTLayoutFrame* right;

@property (nonatomic,strong,readonly) MTLayoutFrame* width;

@property (nonatomic,strong,readonly) MTLayoutFrame* height;

@property (nonatomic,strong,readonly) MTLayoutFrame* centerX;

@property (nonatomic,strong,readonly) MTLayoutFrame* centerY;

@property (nonatomic,strong,readonly) MTLayoutFrame* maxX;

@property (nonatomic,strong,readonly) MTLayoutFrame* maxY;

@property (nonatomic,strong,readonly) MTLayoutFrame* edge;

@property (nonatomic,copy, readonly) MTLayoutFrame* (^equalTo)(NSObject* obj);
@property (nonatomic,copy, readonly) MTLayoutFrame* (^equalToValue)(CGFloat value);

@property (nonatomic,copy, readonly) void (^offset)(CGFloat offset);

@end

@interface UIView (MTLayoutFrame)

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_x;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_y;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_top;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_left;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_bottom;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_right;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_width;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_height;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_centerX;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_centerY;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_maxX;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_maxY;

@property (nonatomic,strong,readonly) MTLayoutFrame* mt_edge;

@end
