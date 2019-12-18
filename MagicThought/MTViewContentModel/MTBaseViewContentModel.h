//
//  MTBaseViewContentModel.h
//  QXProject
//
//  Created by monda on 2019/12/10.
//  Copyright © 2019 monda. All rights reserved.
//

#import "NSObject+CommonProtocol.h"
#import "NSObject+ReuseIdentifier.h"
#import "MTWordStyle.h"
#import "MTBorderStyle.h"
#import "MTConst.h"

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

/**view 的 文本颜色*/
@property (nonatomic,assign) UIColor* textColor;

/**图片名*/
@property (nonatomic,strong) UIImage* image;

/**背景图片名*/
@property (nonatomic,strong) UIImage* image_bg;

@end


@interface MTBaseViewContentStateModel : MTBaseViewContentModel

@property (nonatomic,strong) MTBaseViewContentModel* highlighted;
@property (nonatomic,strong) MTBaseViewContentModel* disabled;
@property (nonatomic,strong) MTBaseViewContentModel* selected;

@end

CG_EXTERN MTBaseViewContentModel* _Nonnull mt_highlighted(MTBaseViewContentModel* _Nullable model);
CG_EXTERN MTBaseViewContentModel* _Nonnull mt_disabled(MTBaseViewContentModel* _Nullable model);
CG_EXTERN MTBaseViewContentModel* _Nonnull mt_selected(MTBaseViewContentModel* _Nullable model);
CG_EXTERN NSString* _Nonnull mt_css(NSString* _Nullable str);
CG_EXTERN UIColor* _Nonnull mt_textColor(UIColor* _Nullable color);
CG_EXTERN NSObject* _Nonnull mt_image_bg(NSObject* _Nullable img_bg);



