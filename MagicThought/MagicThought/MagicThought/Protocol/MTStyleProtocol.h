//
//  MTStyleProtocol.h
//  DaYiProject
//
//  Created by monda on 2018/11/23.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTDelegateProtocol.h"

@class MTStyle;
@protocol MTStyleProtocol <MTDelegateProtocol>

@property (nonatomic,strong, readonly) MTStyle* style;


-(void)didSetTableView:(UITableView*)tableView WithStyle:(NSDictionary*)style;

-(void)didSetController:(UIViewController*)controller WithStyle:(NSDictionary*)style;

-(void)didSetButton:(UIButton*)button WithStyle:(NSDictionary*)style;

-(void)didSetLabel:(UILabel*)label WithStyle:(NSDictionary*)style;

@end
