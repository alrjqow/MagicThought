//
//  MTBaseViewContentModel.h
//  QXProject
//
//  Created by monda on 2019/12/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "NSObject+CommonProtocol.h"
#import "MTWordStyle.h"
#import "MTBorderStyle.h"

//优先选择 cssClass
@interface MTBaseViewContentModel : NSObject

/**view 的背景色*/
@property (nonatomic,strong) UIColor* backgroundColor;

/**view 的状态*/
@property (nonatomic,assign) NSUInteger viewState;

/**view 的内容*/
@property (nonatomic,assign) NSString* text;

/**view 的 wordstyle*/
@property (nonatomic,strong) MTWordStyle* wordStyle;

/**view 的 borderstyle*/
@property (nonatomic,strong) MTBorderStyle* borderStyle;

/**view 的 cssclass*/
@property (nonatomic,strong) NSString* cssClass;


@end



@interface MTBaseButtonContentModel : MTBaseViewContentModel

/**button 的文字颜色*/
@property (nonatomic,strong) UIColor* textColor;

/**button 的图片名*/
@property (nonatomic,strong) UIImage* image;

/**button 的背景图片名*/
@property (nonatomic,strong) UIImage* image_bg;


@end




@interface CSSString : NSString @end
CG_EXTERN CSSString* _Nonnull mt_css(NSString* _Nullable str);

