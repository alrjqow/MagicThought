//
//  MTTextFieldCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTTextFieldCell.h"
#import "MTWordStyle.h"
#import "NSString+Exist.h"
#import "MTConst.h"

@implementation MTTextFieldCell

#pragma mark - 生命周期

-(void)setupDefault
{
    [super setupDefault];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    [self addSubview:self.textField];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    MTTextFieldCellModel* contentModel = (MTTextFieldCellModel*)self.contentModel;
    
    self.textField.frame = CGRectMake(contentModel.textFieldMargin, 0, self.contentView.width - 2 * contentModel.textFieldMargin, self.contentView.height);
}


#pragma mark - 重载方法

-(void)setContentModel:(MTTextFieldCellModel *)contentModel
{
    [super setContentModel:contentModel];
    
    MTTextFieldVerifyModel* verifyModel = contentModel.verifyModel;
    self.textField.verifyModel = verifyModel;
    
    if(![verifyModel.placeholder isExist])
        return;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:verifyModel.placeholder];
    if(verifyModel.placeholderColor)
        [str addAttribute:NSForegroundColorAttributeName value:verifyModel.placeholderColor range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:mt_font(contentModel.placeholderSize) range:NSMakeRange(0, verifyModel.placeholder.length)];
    self.textField.attributedPlaceholder = str;
}

#pragma mark - 成员方法

-(void)textValueChange:(UITextField*)textField
{
    [self.textField didTextValueChange];
}

#pragma mark - 代理与数据源

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self.textField shouldChangeCharactersInRange:range replacementString:string];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.textField didBeginEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.textField didEndEditing];
}

#pragma mark - 懒加载

-(void)setMt_delegate:(id<MTDelegateProtocol>)mt_delegate
{
    [super setMt_delegate:mt_delegate];
    
    self.textField.mt_delegate = mt_delegate;
}

-(MTTextField *)textField
{
    if(!_textField)
    {
        _textField = [MTTextField new];
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _textField;
}

-(Class)classOfResponseObject
{
    return [MTTextFieldCellModel class];
}

@end
