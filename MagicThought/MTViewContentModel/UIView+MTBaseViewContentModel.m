//
//  UIView+MTBaseViewContentModel.m
//  QXProject
//
//  Created by monda on 2019/12/12.
//  Copyright © 2019 monda. All rights reserved.
//

#import "UIView+MTBaseViewContentModel.h"
#import "MTBaseViewContentModel.h"
#import "objc/runtime.h"

#import "NSString+Exist.h"
#import "UIView+Circle.h"
#import "UILabel+Word.h"
#import "UIButton+Word.h"
#import "UITextField+Word.h"
#import "UITextView+Word.h"


#import "VKCssProtocol.h"


@implementation UIView (MTBaseViewContentModel)

-(void)setViewState:(NSUInteger)viewState
{
    self.baseContentModel.viewState = viewState;
    self.baseContentModel = self.baseContentModel;
}

-(NSUInteger)viewState
{
    return self.baseContentModel.viewState;
}

-(void)setBaseContentModel:(MTBaseViewContentModel *)baseContentModel
{
    if(!baseContentModel) return;
    
    [self copyBindWithObject:baseContentModel];
    if(![baseContentModel isKindOfClass:[MTBaseViewContentModel class]])
        return;
 
    UIView* currentView = [baseContentModel valueForKey:@"currentView"];
    if(self.superview == currentView.superview)    
        currentView.hidden = YES;
    
    self.hidden = false;
    [baseContentModel setValue:self forKey:@"currentView"];
    objc_setAssociatedObject(self, @selector(baseContentModel), baseContentModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if([self isKindOfClass:[UIButton class]])
        baseContentModel.viewState = ((UIButton*)self).state;
    
    if(baseContentModel.backgroundColor)
        self.backgroundColor = baseContentModel.backgroundColor;
    
    if([baseContentModel.cssClass isExist])
        self.CssClass(baseContentModel.cssClass);
    
    if(baseContentModel.borderStyle)
        [self becomeCircleWithBorder:baseContentModel.borderStyle];
    
    if(baseContentModel.wordStyle)
    {
        MTWordStyle* wordStyle = [baseContentModel.wordStyle copyObject];
        if([baseContentModel.text isExist])
            wordStyle.wordName = baseContentModel.text;
        if(baseContentModel.textColor)
            wordStyle.wordColor = baseContentModel.textColor;
        
        if([self isKindOfClass:[UILabel class]])
            [(UILabel*)self setWordWithStyle:wordStyle];
        else if([self isKindOfClass:[UIButton class]])
            [(UIButton*)self setWordWithStyle:wordStyle];
        if([self isKindOfClass:[UITextField class]])
            [(UITextField*)self setWordWithStyle:wordStyle];
        if([self isKindOfClass:[UITextView class]])
            [(UITextView*)self setWordWithStyle:wordStyle];
        else if([self isKindOfClass:[UIImageView class]])
        {
            if([wordStyle.wordName isExist])
                ((UIImageView*)self).image = [UIImage imageNamed:wordStyle.wordName];
        }
    }
    else
    {
        if([self isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)self;
            if([baseContentModel.text isExist])
                label.text = baseContentModel.text;
            if(baseContentModel.textColor)
                label.textColor = baseContentModel.textColor;
        }
        else if([self isKindOfClass:[UIButton class]])
        {
            UIButton* btn = (UIButton*)self;
            if([baseContentModel.text isExist])
                [btn setTitle:baseContentModel.text forState:UIControlStateNormal];
            if(baseContentModel.textColor)
                [btn setTitleColor:baseContentModel.textColor forState:UIControlStateNormal];
        }
        else if([self isKindOfClass:[UITextField class]])
        {
            UITextField* textField = (UITextField*)self;
            if([baseContentModel.text isExist])
                textField.text = baseContentModel.text;
            if(baseContentModel.textColor)
                textField.textColor = baseContentModel.textColor;
        }
        else if([self isKindOfClass:[UITextView class]])
        {
            UITextView* textView = (UITextView*)self;
            if([baseContentModel.text isExist])
                textView.text = baseContentModel.text;
            if(baseContentModel.textColor)
                textView.textColor = baseContentModel.textColor;
        }
        else if([self isKindOfClass:[UIImageView class]])
        {
            if([baseContentModel.text isExist])
                ((UIImageView*)self).image = [UIImage imageNamed:baseContentModel.text];
        }
    }
    

    if(baseContentModel.image)
    {
        if([self isKindOfClass:[UIImageView class]])
            ((UIImageView*)self).image = baseContentModel.image;
        else if([self isKindOfClass:[UIButton class]])
            [(UIButton*)self  setImage:baseContentModel.image forState:UIControlStateNormal];
    }
    
    if(baseContentModel.image_bg)
    {
        if([self isKindOfClass:[UIButton class]])
            [(UIButton*)self  setBackgroundImage:baseContentModel.image_bg forState:UIControlStateNormal];
    }
}

-(MTBaseViewContentModel *)baseContentModel{return objc_getAssociatedObject(self, _cmd);}

@end





@implementation UIButton(MTBaseViewContentModel)

-(void)setBaseContentModel:(MTBaseViewContentModel *)baseContentModel
{
    if(!baseContentModel) return;
    
    [super setBaseContentModel:baseContentModel];
    
    if(![baseContentModel isKindOfClass:[MTBaseViewContentStateModel class]])
        return;
    
    MTBaseViewContentStateModel* model = (MTBaseViewContentStateModel*)baseContentModel;
    
    if(model.highlighted)
        [self setModel:model.highlighted forState:UIControlStateHighlighted];
    if(model.disabled)
        [self setModel:model.disabled forState:UIControlStateDisabled];
    if(model.selected)
        [self setModel:model.selected forState:UIControlStateSelected];
}


-(void)setModel:(MTBaseViewContentModel*)model forState:(UIControlState)state
{
    if(state == UIControlStateNormal)
        return;
    
    if(model.image)
        [self  setImage:model.image forState:state];
    if(model.image_bg)
        [self  setBackgroundImage:model.image_bg  forState:state];
    
    if(model.textColor)
        [self setTitleColor:model.textColor forState:state];
    else if(model.wordStyle.wordColor)
        [self setTitleColor:model.wordStyle.wordColor forState:state];
    
    NSString* text;
    if([model.text isExist])
        text = model.text;
    else
        text = model.wordStyle.wordName;
    [self setTitle:text forState:state];
}


@end


@implementation UITextField(MTBaseViewContentModel)

-(void)setBaseContentModel:(MTBaseViewContentModel *)baseContentModel
{
    if(!baseContentModel) return;    
    
    [super setBaseContentModel:baseContentModel];
    
    if(![baseContentModel isKindOfClass:[MTBaseViewContentStateModel class]])
        return;
    
    MTBaseViewContentStateModel* model = (MTBaseViewContentStateModel*)baseContentModel;
    
    if(!model.placeholder)
        return;
    
    MTBaseViewContentModel* placeholder = model.placeholder;
    NSString* text;
    if([placeholder.text isExist])
        text = placeholder.text;
    else if([placeholder.wordStyle.wordName isExist])
        text = placeholder.wordStyle.wordName;
        
    if(![text isExist])
        return;
        
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    if(placeholder.wordStyle)
    {
        [str addAttribute:NSForegroundColorAttributeName value:placeholder.wordStyle.wordColor range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:mt_font(placeholder.wordStyle.wordSize) range:NSMakeRange(0, text.length)];
    }
    
    self.attributedPlaceholder = str;
}

@end
