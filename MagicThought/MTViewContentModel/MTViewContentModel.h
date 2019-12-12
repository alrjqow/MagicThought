//
//  MTViewContentModel.h
//  QXProject
//
//  Created by monda on 2019/12/5.
//  Copyright © 2019 monda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTBaseViewContentModel.h"

@interface MTViewContentModel : MTBaseViewContentModel

/**textLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* title;

/**detailTextLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* content;

/**第二个detailTextLabel*/
@property (nonatomic,strong) MTBaseViewContentModel* content2;

/**imageView*/
@property (nonatomic,strong) MTBaseViewContentModel* img;

/**imageView2*/
@property (nonatomic,strong) MTBaseViewContentModel* img2;

/**btn*/
@property (nonatomic,strong) MTBaseViewContentModel* btnTitle;

/**btn2 */
@property (nonatomic,strong) MTBaseViewContentModel* btnTitle2;

@end









