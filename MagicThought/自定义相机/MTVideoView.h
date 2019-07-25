//
//  MTVideoView.h
//  DaYiProject
//
//  Created by monda on 2019/2/18.
//  Copyright © 2019 monda. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MTVideoView : UIView

@property (nonatomic,strong) NSURL* videoUrl;

- (void)stopPlayer;

@end


