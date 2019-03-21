//
//  MTDelegateHeaderFooterView.h
//  8kqw
//
//  Created by 王奕聪 on 2017/5/16.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"


@interface MTDelegateHeaderFooterView : UITableViewHeaderFooterView

@property(nonatomic,weak) id<MTDelegateProtocol> mt_delegate;

@property(nonatomic,assign) NSInteger section;

@property (nonatomic,assign) CGFloat marginBottom;
@property (nonatomic,assign) CGFloat marginTop;
@property (nonatomic,assign) CGFloat marginLeft;
@property (nonatomic,assign) CGFloat marginRight;

-(void)setupDefault;

/**当接收到数据*/
-(void)whenGetResponseObject:(NSObject*)object;

@end




