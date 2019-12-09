//
//  MTViewContentModel.h
//  QXProject
//
//  Created by monda on 2019/12/5.
//  Copyright © 2019 monda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTWordStyle.h"

//优先选择 cssClass
@interface MTViewContentModel : NSObject

@property (nonatomic,strong, readonly) NSDictionary* tagIdentifier;

/**textLabel 的内容*/
@property (nonatomic,strong) NSString* title;
/**textLabel 的word*/
@property (nonatomic,strong) MTWordStyle* titleWord;
/**textLabel 的cssClass*/
@property (nonatomic,strong) NSString* titleCssClass;

/**detailTextLabel 的内容*/
@property (nonatomic,strong) NSString* content;
/**detailTextLabel 的word*/
@property (nonatomic,strong) MTWordStyle* contentWord;
/**detailTextLabel 的cssClass*/
@property (nonatomic,strong) NSString* contentCssClass;


/**第二个detailTextLabel 的内容*/
@property (nonatomic,strong) NSString* content2;
/**第二个detailTextLabel 的word*/
@property (nonatomic,strong) MTWordStyle* content2Word;
/**第二个detailTextLabel 的cssClass*/
@property (nonatomic,strong) NSString* content2CssClass;

/**imageView 的图片名*/
@property (nonatomic,strong) NSString* img;
/**imageView 的cssClass*/
@property (nonatomic,strong) NSString* imageViewCssClass;
/**imageView2 的图片名*/
@property (nonatomic,strong) NSString* img2;
/**imageView2 的cssClass*/
@property (nonatomic,strong) NSString* imageView2CssClass;


/**btn 的状态*/
@property (nonatomic,assign, readonly) UIControlState btnState;
/**btn 的内容*/
@property (nonatomic,strong) NSString* btnTitle;
/**btn 的word*/
@property (nonatomic,strong) MTWordStyle* btnWord;
/**btn 的cssClass*/
@property (nonatomic,strong) NSString* btnCssClass;

/**btn2 的状态*/
@property (nonatomic,assign, readonly) UIControlState btn2State;
/**btn2 的内容*/
@property (nonatomic,strong) NSString* btnTitle2;
/**btn2 的word*/
@property (nonatomic,strong) MTWordStyle* btn2Word;
/**第二个btn 的cssClass*/
@property (nonatomic,strong) NSString* btn2CssClass;

@end



@interface UIView(MTViewContentModel)

@property (nonatomic,strong) MTViewContentModel* contentModel;

@end
