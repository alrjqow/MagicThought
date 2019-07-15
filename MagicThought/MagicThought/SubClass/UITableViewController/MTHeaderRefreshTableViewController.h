//
//  MTHeaderRefreshTableViewController.h
//  MDKit
//
//  Created by monda on 2019/5/17.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTTableViewController.h"
#import "MTRefreshGifHeader.h"



@interface MTHeaderRefreshTableViewController : MTTableViewController

@property (nonatomic,strong) MTRefreshGifHeader* mj_header;

@property (nonatomic,copy) MTHeaderRefreshBlock mj_Block;

@end



