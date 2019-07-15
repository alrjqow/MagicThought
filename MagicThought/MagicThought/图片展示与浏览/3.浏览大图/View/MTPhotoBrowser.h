//
//  MTPhotoBrowser.h
//  MTPhotoBrowser
//
//  Created by 王奕聪 on 2016/12/14.
//  Copyright © 2016年 com.king.app. All rights reserved.
//

#import "MTDelegateView.h"

@class MTPhotoBrowser;
@class MTPhotoPreviewViewCellModel;
@protocol MTDelegateProtocol;


@class MTPhotoBrowserViewModel;

@interface MTPhotoBrowser : MTDelegateView

@property (nonatomic,weak) MTPhotoBrowserViewModel* model;

+(instancetype)shareBrowser;

+(void)clearBrowser;

-(void)show;

@end

