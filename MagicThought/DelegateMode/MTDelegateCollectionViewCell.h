//
//  MTDelegateCollectionViewCell.h
//  MyTool
//
//  Created by 王奕聪 on 2017/2/8.
//  Copyright © 2017年 com.king.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDelegateProtocol.h"

@interface MTDelegateCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak) id<MTDelegateProtocol> delegate;

@property(nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,assign) CGFloat marginBottom;
@property (nonatomic,assign) CGFloat marginTop;
@property (nonatomic,assign) CGFloat marginLeft;
@property (nonatomic,assign) CGFloat marginRight;

//用于判断是否所有cell都已完成任务
@property(nonatomic,assign) NSInteger  isCellOk;//当前cell进度

-(void)setupDefault;

/**当接收到数据*/
-(void)whenGetResponseObject:(NSObject*)object;

/**拿一些东西*/
-(NSDictionary*)giveSomeThingToYou;

/**拿一些东西给我做什么*/
-(void)giveSomeThingToMe:(id)obj WithOrder:(NSString*)order;


@end
