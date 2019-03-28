//
//  MTPhotoPreviewView.m
//  8kqw
//
//  Created by 王奕聪 on 2017/1/5.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTPhotoPreviewViewModel.h"
#import "MTPhotoPreviewViewCellModel.h"
#import "MTPhotoBrowserViewModel.h"
#import "MTPopButtonItem.h"

#import "MTPhotoPreviewView.h"
#import "MTPhotoPreviewViewCell.h"
#import "MTPhotoBrowserController.h"
#import "MTTakePhotoPreseter.h"
#import "MTPhotoBrowser.h"
#import "MTConst.h"
#import "MTView.h"
#import "NSString+Bundle.h"
#import "MTAlertView.h"

@interface MTPhotoPreviewView()

@property(nonatomic,strong) MTAlertController* alert;

@end

@implementation MTPhotoPreviewView


#pragma mark - 成员方法

-(void)loadData
{
    if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.mt_delegate doSomeThingForMe:self withOrder:MTPhotoPreviewViewReloadDataOrder];
    else
        [self reloadData];
}



#pragma mark - collectionView代理

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.model showBrowserAtIndex:indexPath.row];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([self.mt_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
       [((id<UIScrollViewDelegate>)self.mt_delegate) scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.mt_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
       [((id<UIScrollViewDelegate>)self.mt_delegate) scrollViewDidEndDecelerating:scrollView];
}







#pragma mark - 自定义代理

-(void)doSomeThingForMe:(id)obj withOrder:(NSString*)order
{
    static id object;
    if([order isEqualToString:@"MTPhotoPreviewViewCellDeleteImageOrder"])
    {
        object = ((MTPhotoPreviewViewCell*)obj).model;
        [self alertWithTitle:mt_AppName() Content:@"确定要删除？" Buttons:@[MTPopButtonItemMake(@"我按错了", false, @"MTAlertDeleteImageCancelOrder"), MTPopButtonItemMake(@"是的", YES, @"MTAlertDeleteImageOrder")]];
    }
    else if([order isEqualToString:MTPhotoPreviewViewReloadDataOrder])
    {
        [self loadData];
    }
    else if([order isEqualToString:@"MTAlertDeleteImageOrder"])
    {
        [self.model.cellModelArr removeObject:object];
        self.model.isDeleteReload = YES;
        
        if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
            [self.mt_delegate doSomeThingForMe:self withOrder:MTPhotoPreviewViewReloadDataOrder];
        else
            [self reloadData];
        
        object = nil;
    }
    else if([order isEqualToString:@"MTAlertDeleteImageCancelOrder"])
    {
        object = nil;
    }
    
}





#pragma mark - 懒加载


-(MTAlertController *)alert
{    //1.弹出提示，询问是否删除
    if(!_alert)
    {
        MTAlertController* alert = [[MTAlertController alloc]initWithAlertStyle:mt_AlertStyleMake(mt_AppName() , @"确定要删除？", @"我按错了", @"是的", 0)];
        alert.alertViewSize = CGSizeMake(alert.alertViewSize.width, alert.alertViewSize.height - 20);
        _alert = alert;
    }
    
    return _alert;
}


#pragma mark - 初始化

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if(self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addTarget:self EmptyData:nil DataList:nil SectionList:nil];
    }
    return self;
}

@end
