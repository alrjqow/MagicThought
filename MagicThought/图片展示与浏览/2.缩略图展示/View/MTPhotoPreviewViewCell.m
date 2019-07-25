//
//  MTPhotoPreviewViewCell.m
//  8kqw
//
//  Created by 王奕聪 on 2017/1/5.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTPhotoPreviewViewCell.h"
#import "NSString+Bundle.h"
#import "UIView+Frame.h"
#import "NSString+Exist.h"
#import "UIImage+Size.h"
#import "MTConst.h"

/*此处有依赖*/
#import "UIImageView+WebCache.h"

@interface MTPhotoPreviewViewCell ()

@end


@implementation MTPhotoPreviewViewCell

-(void)whenGetResponseObject:(NSObject *)object
{
    if(![object isKindOfClass:[MTPhotoPreviewViewCellModel class]])
        return;
    
    self.model = (MTPhotoPreviewViewCellModel*)object;
}

-(void)setModel:(MTPhotoPreviewViewCellModel *)model
{
    _model = model;
    
    self.deleteBtn.hidden = model.isHideDeleteBtn;
    [self.deleteBtn setImage:[model.deleteBtnImageName isExist] ? [UIImage imageNamed: model.deleteBtnImageName] : [[UIImage imageNamed: @"MTPhotoBrowser.bundle/delete"] changeToSize:CGSizeMake(23, 23)] forState:UIControlStateNormal];
    
    __weak typeof (self) weakSelf = self;
    [model getImage:^(UIImage * image) {
        
        weakSelf.imgView.image = image ? image : [UIImage imageNamed: @"MTPhotoBrowser.bundle/no_image"];
        
        if([weakSelf.delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:withItem:)])
            [weakSelf.delegate doSomeThingForMe:weakSelf withOrder:MTPhotoPreviewViewCellDownloadImageFinishOrder withItem:weakSelf.indexPath];
    }];
}


-(void)setupDefault
{
    [super setupDefault];
    
    _imgView = [UIImageView new];
    _deleteBtn = [UIButton new];
    
    self.deleteBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.imgView];
    [self addSubview:self.deleteBtn];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.frame = self.contentView.bounds;
    
    self.deleteBtn.bounds = CGRectMake(0, 0, 50, 50);
    self.deleteBtn.center = CGPointMake(self.contentView.width + 8 - self.deleteBtn.halfWidth, self.deleteBtn.halfHeight -10);
}


- (IBAction)delete:(UIButton*)sender
{    
    if([self.delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
        [self.delegate doSomeThingForMe:self withOrder:@"MTPhotoPreviewViewCellDeleteImageOrder"];
}







@end
