//
//  MTBaseCellModel.h
//  QXProject
//
//  Created by monda on 2019/12/6.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseViewContentModel.h"


//扩展时，先以此类为父类扩展网络数据属性，优先使用 getter 方法 设置 cell 样式
@interface MTBaseCellModel : MTBaseViewContentModel

/**分割线长度*/
@property (nonatomic,assign) CGFloat sepLineWidth;
/**是否消除分割线，默认不消除*/
@property (nonatomic,assign) BOOL isCloseSepLine;

/**是否显示箭头*/
@property (nonatomic,assign) CGFloat isArrow;
/**右箭头的右边距*/
@property (nonatomic,assign) CGFloat accessoryMarginRight;
/**右箭头的尺寸*/
@property (nonatomic,assign) CGRect accessoryBounds;


@end



extern NSString* MTEmptyBaseCellRefreshOrder;
@interface MTEmptyBaseCellModel : MTBaseCellModel

@property (nonatomic,strong) NSString* refreshOrder;

/**是否已加载，设为 Yes 隐藏加载框*/
@property (nonatomic,assign) BOOL isAlreadyLoad;

@end



