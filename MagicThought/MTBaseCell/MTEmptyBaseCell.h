//
//  MTEmptyBaseCell.h
//  SimpleProject
//
//  Created by monda on 2019/5/14.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCell.h"



//无数据是空界面
@class MTLoadingView;
@interface MTEmptyBaseCell : MTNoSepLineBaseCell

@property (nonatomic,strong) MTLoadingView* loadingView;

/**是否点击加载，默认为Yes*/
@property (nonatomic,assign) BOOL isTouchLoad;

/**是否已加载*/
@property (nonatomic,assign) BOOL isAlreadyLoad;

/**加载成功做的事*/
-(void)isAlreadyLoadYes;

@end


