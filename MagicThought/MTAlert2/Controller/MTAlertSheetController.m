//
//  MTAlertSheetController.m
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTAlertSheetController.h"
#import "MTAlertSheetItem.h"

#import "MTBorderStyle.h"
#import "MTWordStyle.h"

#import "UILabel+Word.h"
#import "UIDevice+DeviceInfo.h"
#import "UIView+Frame.h"
#import "UIView+Circle.h"
#import "NSObject+ReuseIdentifier.h"

#import "MTDelegateTableViewCell.h"



@interface MTAlertSheetController ()




@end

@implementation MTAlertSheetController

-(void)initProperty
{
    [super initProperty];
    
    self.type = MTBaseAlertTypeUp;
}

-(void)setupDefault
{
    [super setupDefault];
    
    
    self.alertView = self.mtBase_tableView;
    self.mtBase_tableView.bounces = false;
    if (@available(iOS 11.0, *)) {
        self.mtBase_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
    self.mtBase_tableView.backgroundColor = rgb(245, 245, 245);
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.frame = CGRectMake(0, 0, kScreenWidth_mt(), [UIDevice isHairScreen] ?  kStatusBarHeight_mt() : 0);
    self.mtBase_tableView.tableFooterView = footerView;
    
    [self.mtBase_tableView addTarget:self];    
    [self setupTableView];
}


-(void)setupTableView
{
    CGFloat itemHeight = 0;
    for (MTAlertSheetItem* item in self.alertItemArr)
        itemHeight += (item.itemHeight + item.marginBottom);
    
    self.mtBase_tableView.height = itemHeight + ([UIDevice isHairScreen] ?  kStatusBarHeight_mt() : 0);
            
    [self.mtBase_tableView becomeCircleWithBorder:mt_BorderStyleMake(0, 12, nil) AndRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    [self.mtBase_tableView reloadDataWithDataList:self.alertItemArr];
}

#pragma mark - 懒加载

-(void)setAlertItemArr:(NSArray<MTAlertSheetItem*> *)alertItemArr
{
    _alertItemArr = alertItemArr;    
    
    alertItemArr.bind(@"MTAlertSheetCell");

    if((NSInteger)(alertItemArr.count - 2) >= 0)
        alertItemArr[alertItemArr.count - 2].marginBottom *= 4;
    
    if(self.isViewDidLoad)
        [self setupTableView];
}

@end



@interface MTAlertSheetCell : MTDelegateTableViewCell

@property (nonatomic,weak) MTAlertSheetItem* item;

@end



@implementation MTAlertSheetCell


-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:[MTAlertSheetItem class]])
        return;
    
    self.item = (MTAlertSheetItem*)object;
}

-(void)setItem:(MTAlertSheetItem *)item
{
    _item = item;
    
    [self.textLabel setWordWithStyle:item.word];
    self.margin = UIEdgeInsetsMake(0, 0, item.marginBottom, 0);    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.selected = false;
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
        [self.mt_delegate doSomeThingForMe:self withOrder:@"MTAlertSheetCellClickOrder" withItem:self.item.eventOrder];
    [super touchesBegan:touches withEvent:event];
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.backgroundColor = [UIColor whiteColor];
}

@end
