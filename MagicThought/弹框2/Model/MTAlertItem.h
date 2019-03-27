//
//  MTAlertItem.h
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MTAlertItem : NSObject

+(instancetype)itemWithOrder:(NSString*)order;

@property (nonatomic,strong, readonly) NSString* eventOrder;

@end

