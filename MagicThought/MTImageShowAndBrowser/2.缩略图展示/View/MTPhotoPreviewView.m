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

#import "MTPhotoPreviewView.h"
#import "MTPhotoPreviewViewCell.h"
#import "MTPhotoBrowserController.h"
#import "MTTakePhotoPreseter.h"
#import "MTPhotoBrowser.h"
#import "MTConst.h"
#import "NSString+Bundle.h"
#import "MTAlertView.h"
#import "NSArray+Alert.h"

NSString*  MTPhotoPreviewViewReloadDataOrder = @"MTPhotoPreviewViewReloadDataOrder";
NSString*  MTPhotoPreviewViewCellDownloadImageFinishOrder = @"MTPhotoPreviewViewCellDownloadImageFinishOrder";

@interface MTPhotoPreviewView()

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
        @[
            appTitle_mtAlert(),
            content_mtAlert(@"确定要删除？"),
            buttons_mtAlert(@[
                @"我按错了".bindOrder(@"MTAlertDeleteImageCancelOrder"),
                @"是的".bindOrder(@"MTAlertDeleteImageOrder"),
            ])
        ].alert_mt();
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
