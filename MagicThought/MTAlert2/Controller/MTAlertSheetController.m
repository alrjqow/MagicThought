//
//  MTAlertSheetController.m
//  DaYiProject
//
//  Created by monda on 2018/9/10.
//  Copyright © 2018 monda. All rights reserved.
//

#import "MTAlertSheetController.h"
#import "MTAlertSheetItem.h"

#import "NSString+Exist.h"
#import "UILabel+Word.h"
#import "UIDevice+DeviceInfo.h"
#import "UIView+Frame.h"
#import "UIView+Circle.h"
#import "UIView+MTBaseViewContentModel.h"
#import "NSObject+ReuseIdentifier.h"


#import "MTDelegateTableViewCell.h"



@interface MTAlertSheetController ()

//暂时忽略
@property (nonatomic,strong) NSDictionary* dismissBlackList;

@property (nonatomic,assign) CGFloat tableViewHeight;


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
    
    self.mtBase_tableView.bounces = false;
    self.mtBase_tableView.backgroundColor = rgb(245, 245, 245);
    [self.mtBase_tableView becomeCircleWithBorder:mt_BorderStyleMake(0, 12, nil) AndRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.frame = CGRectMake(0, 0, kScreenWidth_mt(), [UIDevice isHairScreen] ?  kStatusBarHeight_mt() : 0);
    self.mtBase_tableView.tableFooterView = footerView;
    
    [self.mtBase_tableView addTarget:self];
    [self loadData];
}


-(void)loadData
{
    self.mtBase_tableView.height = self.tableViewHeight;
    [self.view setNeedsLayout];
    [self.mtBase_tableView reloadDataWithDataList:self.alertItemArr];
}

#pragma mark - 代理

-(void)doSomeThingForMe:(id)obj withOrder:(NSString *)order withItem:(id)item
{
    if([order isEqualToString:@"MTAlertSheetCellClickOrder"])
    {
        NSString* eventOrder = item;
        BOOL isDismiss = [self.dismissBlackList objectForKey:eventOrder] == nil;
        isDismiss = [eventOrder isEqualToString:MTGetPhotoFromCameraOrder] || [eventOrder isEqualToString:MTGetPhotoFromAlbumOrder];
        [self setValue:@(isDismiss) forKey:@"isDismiss"];
        
        [self dismiss];
        if([eventOrder isExist] && [self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
            [self.mt_delegate doSomeThingForMe:self withOrder:eventOrder];
    }
}

#pragma mark - 懒加载

-(void)setAlertItemArr:(NSArray<MTAlertSheetItem*> *)alertItemArr
{
    _alertItemArr = alertItemArr;
    
    alertItemArr.bind(@"MTAlertSheetCell");

    if((NSInteger)(alertItemArr.count - 2) >= 0)
        alertItemArr[alertItemArr.count - 2].marginBottom *= 4;
    
    CGFloat itemHeight = 0;
    for (MTAlertSheetItem* item in alertItemArr)
        itemHeight += (item.itemHeight + item.marginBottom);
    self.tableViewHeight = itemHeight + ([UIDevice isHairScreen] ?  kStatusBarHeight_mt() : 0);
            
    if(self.isViewDidLoad)
       [self loadData];
}

-(UIView *)alertView
{
    return self.mtBase_tableView;
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
    
    self.textLabel.baseContentModel = item;
    self.margin = UIEdgeInsetsMake(0, 0, item.marginBottom, 0);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.selected = false;
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
        [self.mt_delegate doSomeThingForMe:self withOrder:@"MTAlertSheetCellClickOrder" withItem:self.item.mt_order];
    [super touchesBegan:touches withEvent:event];
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.backgroundColor = [UIColor whiteColor];
}

@end
