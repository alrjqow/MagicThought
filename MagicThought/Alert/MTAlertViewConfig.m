//
//  MTAlertViewConfig.m
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyr/Users/monda/Desktop/MTalertView/MTalertView/MTAlertView/MTPopView.might © 2018年 王奕聪. All rights reserved.
//

#import "MTAlertViewConfig.h"
#import "MTPopButtonItem.h"
#import "MTConst.h"
#import "NSString+WordHeight.h"

@implementation MTAlertViewConfig

-(CGFloat)alertViewHeight
{
    CGFloat alertViewHeight = 0;
    
    CGFloat titleHeight = self.innerTopMargin + self.titleFont.pointSize;
    
    CGFloat detailHeight = (self.title.length > 0  ? self.detailInnerMargin : self.innerMargin) + self.detailHeight;
    
    CGFloat buttonHeight = self.items.count < 3 ? self.buttonHeight : self.buttonHeight * self.items.count;
    buttonHeight += self.detail.length > 0  ? self.detailInnerMargin + 2 : self.innerMargin;
    
    alertViewHeight = titleHeight + detailHeight + buttonHeight;
    
    return alertViewHeight;
}

-(CGFloat)detailHeight
{
    CGFloat deatilHeight = 0;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = self.detailLineSpacing; //设置行间距
    
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:self.detailFont.pointSize], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f};
     deatilHeight = [self.detail calculateHeightWithWidth:(self.width - 2*self.innerMargin) andAttribute:dic];
    
    return deatilHeight > 120 ? 120 : deatilHeight;
}

-(instancetype)init
{
    if(self = [super init])
    {
        [self setupDefault];
        
//        self.width = kScreenWidth_mt() - 4 * outterMargin25;
//        self.buttonHeight = 50;
//        self.cornerRadius = 4;
//
//        self.logoMargin = UIEdgeInsetsMake(0, 0, 12, 6);
//        self.splitWidth = 1;
//
//        self.innerMargin = 20;
//        self.innerTopMargin = self.innerMargin;
//
//        self.detailInnerMargin = 15;
//        self.detailLineSpacing = 1;
//
//        self.detailAlignment = NSTextAlignmentCenter;
//
//        self.titleFont  = [UIFont boldSystemFontOfSize:18];
//        self.detailFont = [UIFont systemFontOfSize:12];
//        self.buttonFont = [UIFont systemFontOfSize:15];
//
//        self.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
//        self.titleColor = kColor_Text_Title;
//        self.detailColor = kColor_Text_Normal;
//        self.splitColor = kColor_D0D0D0;
//
//        self.itemNormalColor = kColor_Text_Tips;
//        self.itemHighlightColor = kColor_Blue;
//        self.itemPressedColor = [UIColor colorWithHex:0xEFEDE7];
//
//        self.defaultTextOK = @"好";
//        self.defaultTextCancel = @"取消";
//        self.defaultTextConfirm = @"确定";
//
//
//        self.items =@[
//                      MTPopButtonItemMake(self.defaultTextOK,  MTPopButtonItemTypeHighlight, nil)
//                      ];
    }
    
    return self;
}


-(void)setupDefault
{
    self.width = 275.0f;
    self.buttonHeight = 44.0f;//50.0f;
    self.cornerRadius = 5.0f;
    
    self.logoMargin = UIEdgeInsetsMake(0, 0, 12, 6);
    self.splitWidth = 2;
    
    self.innerMargin = 25.0f;
    self.innerTopMargin = self.innerMargin;
    
    self.detailInnerMargin = 5.0f;
    self.detailLineSpacing = 1;
    
    self.detailAlignment = NSTextAlignmentCenter;
    
    self.titleFont  = [UIFont boldSystemFontOfSize:18.0f];
    self.detailFont = [UIFont systemFontOfSize:14.0f];
    self.buttonFont = [UIFont systemFontOfSize:17.0f];
    
    
    self.backgroundColor = hex(0xffffff);
    self.titleColor = hex(0x333333);
    self.detailColor = hex(0x333333);
    self.splitColor = hex(0xCCCCCC);
    
    self.itemNormalColor = hex(0x333333);
    self.itemHighlightColor = hex(0xE76153);
    self.itemPressedColor = hex(0xEFEDE7);
    
    self.defaultTextOK = @"好";
    self.defaultTextCancel = @"取消";
    self.defaultTextConfirm = @"确定";
    
    
    self.items =@[
                      MTPopButtonItemMake(self.defaultTextOK,  MTPopButtonItemTypeHighlight, nil)
                      ];
}

@end
