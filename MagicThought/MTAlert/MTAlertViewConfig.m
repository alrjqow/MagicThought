//
//  MTAlertViewConfig.m
//  MTalertView
//
//  Created by 王奕聪 on 2018/3/25.
//  Copyr/Users/monda/Desktop/MTalertView/MTalertView/MTAlertView/MTPopView.might © 2018年 王奕聪. All rights reserved.
//

#import "MTAlertViewConfig.h"
#import "MTAlertView.h"

#import "MTConst.h"
#import "NSString+WordHeight.h"
#import "NSString+Exist.h"

#import <MJExtension.h>

@implementation MTAlertViewConfig

-(void)setupDefault
{
    [super setupDefault];
        
    self.backgroundColor = [UIColor whiteColor];
    self.borderStyle = mt_BorderStyleMake((1/[UIScreen mainScreen].scale), 4, hex(0xCCCCCC));
            
    self.content = MTBaseViewContentModel.new(mt_WordStyleMake(12, nil, hex(0x333333)).lineSpacing(1).horizontalAlignment(NSTextAlignmentCenter));
    self.content2 = MTBaseViewContentModel.new(self.borderStyle.borderColor);
    

    self.width = kScreenWidth_mt() - 4 * 25;
    self.splitWidth = 1;
    
    self.buttonHeight = 50;
    self.innerMargin = 20;
    self.detailInnerMargin = 15;
    self.innerTopMargin = self.innerMargin;
    self.logoMargin = UIEdgeInsetsMake(0, 0, 12, 6);
    
}

-(void)alert
{
    if(![self.title.wordStyle.wordName isExist])
        self.title.wordStyle = mt_WordStyleMake(18, mt_AppName(), hex(0x333333));
        
    [[MTAlertView alertWithConfig:self] show];
}


#pragma mark - 懒加载

-(CGFloat)alertViewHeight
{
    CGFloat alertViewHeight = 0;
    
    CGFloat titleHeight = self.innerTopMargin + self.title.wordStyle.wordSize;
    
    CGFloat detailHeight = (self.title.text.length > 0  ? self.detailInnerMargin : self.innerMargin) + self.detailHeight;
    
    CGFloat buttonHeight = self.buttonModelList.count < 3 ? self.buttonHeight : self.buttonHeight * self.buttonModelList.count;
    buttonHeight += self.content.text.length > 0  ? self.detailInnerMargin + 2 : self.innerMargin;
    
    alertViewHeight = titleHeight + detailHeight + buttonHeight;
    
    return alertViewHeight;
}

-(CGFloat)detailHeight
{
    CGFloat deatilHeight = 0;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = self.content.wordStyle.wordLineSpacing; //设置行间距
    
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:self.content.wordStyle.wordSize], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f};
     deatilHeight = [self.content.text calculateHeightWithWidth:(self.width - 2*self.innerMargin) andAttribute:dic];
    
    return deatilHeight > 120 ? 120 : deatilHeight;
}

-(NSArray<MTAlertViewButtonConfig *> *)buttonModelList
{
    if(_buttonModelList.count <= 0)
    {        
        _buttonModelList = @[MTAlertViewButtonConfig.new(mt_WordStyleMake(15, @"确定", hex(0xE76153)))];
    }
    
    return _buttonModelList;
}

-(MTBaseViewContentModel *)title
{
    MTBaseViewContentModel* title = [super title];
    if(!title)
    {
        title = MTBaseViewContentModel.new(mt_WordStyleMake(18, mt_AppName(), hex(0x333333)));
        self.title = title;
    }
    
    return title;
}

+ (NSDictionary *)mj_objectClassInArray
{    
    return @{
        @"buttonModelList" : [MTAlertViewButtonConfig class]
    };
}

@end


@implementation MTAlertViewButtonConfig @end
