//
//  MTViewContentModel.h
//  QXProject
//
//  Created by monda on 2019/12/5.
//  Copyright © 2019 monda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTBaseViewContentModel.h"

@interface MTViewContentModel : MTBaseViewContentStateModel

/**textLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* mtTitle;

/**detailTextLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* mtContent;

/**第二个detailTextLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* mtContent2;

/**第三个detailTextLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* mtContent3;

/**第四个detailTextLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* mtContent4;

/**第五个detailTextLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* mtContent5;

/**imageView*/
@property (nonatomic,strong) MTBaseViewContentModel* mtImg;

/**imageView2*/
@property (nonatomic,strong) MTBaseViewContentModel* mtImg2;

/**imageView3*/
@property (nonatomic,strong) MTBaseViewContentModel* mtImg3;

/**imageView4*/
@property (nonatomic,strong) MTBaseViewContentModel* mtImg4;

/**imageView5*/
@property (nonatomic,strong) MTBaseViewContentModel* mtImg5;

/**imageView6*/
@property (nonatomic,strong) MTBaseViewContentModel* mtImg6;

/**btn*/
@property (nonatomic,strong) MTBaseViewContentModel* mtBtnTitle;

/**btn2 */
@property (nonatomic,strong) MTBaseViewContentModel* mtBtnTitle2;

/**btn3 */
@property (nonatomic,strong) MTBaseViewContentModel* mtBtnTitle3;

/**btn4*/
@property (nonatomic,strong) MTBaseViewContentModel* mtBtnTitle4;

/**btn5 */
@property (nonatomic,strong) MTBaseViewContentModel* mtBtnTitle5;

/**btn6 */
@property (nonatomic,strong) MTBaseViewContentModel* mtBtnTitle6;

/**textField */
@property (nonatomic,strong) MTBaseViewContentModel* mtTextField;

/**textView */
@property (nonatomic,strong) MTBaseViewContentModel* mtTextView;

/**扩展内容*/
@property (nonatomic,strong) NSObject* mtExternContent;

-(CGFloat)setUpEstimateHeight;

@end







