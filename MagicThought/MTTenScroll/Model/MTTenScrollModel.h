//
//  MTTenScrollModel.h
//  DaYiProject
//
//  Created by monda on 2018/12/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTenScrollTitleViewModel.h"
#import "MTDelegateProtocol.h"


extern NSString* MTTenScrollIdentifier;


@interface MTTenScrollModel : NSObject

@property (nonatomic,weak) NSObject<MTDelegateViewDataProtocol>* delegate;

@property (nonatomic,strong) NSArray* dataList;

@property (nonatomic,strong) MTTenScrollTitleViewModel* titleViewModel;

@property (nonatomic,assign) CGFloat tenScrollHeight;

/**contentView固定的偏移值*/
@property (nonatomic,assign) CGFloat contentViewFixOffset;

@end


