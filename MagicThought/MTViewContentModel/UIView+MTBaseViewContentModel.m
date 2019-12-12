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
    if(![baseContentModel isKindOfClass:[MTBaseViewContentModel class]])
        return;
    
    objc_setAssociatedObject(self, @selector(baseContentModel), baseContentModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if([self isKindOfClass:[UIButton class]])
        baseContentModel.viewState = ((UIButton*)self).state;
    
    if(baseContentModel.backgroundColor)
        self.backgroundColor = baseContentModel.backgroundColor;
    
    if([baseContentModel.cssClass isExist])
        self.CssClass(baseContentModel.cssClass);
    else
    {
        if(baseContentModel.borderStyle)
            [self becomeCircleWithBorder:baseContentModel.borderStyle];
        
        if(baseContentModel.wordStyle)
        {
            if([self isKindOfClass:[UILabel class]])
                [(UILabel*)self setWordWithStyle:baseContentModel.wordStyle];
            else if([self isKindOfClass:[UIButton class]])
                [(UIButton*)self setWordWithStyle:baseContentModel.wordStyle];
            if([self isKindOfClass:[UITextField class]])
                [(UITextField*)self setWordWithStyle:baseContentModel.wordStyle];
            if([self isKindOfClass:[UITextView class]])
                [(UITextView*)self setWordWithStyle:baseContentModel.wordStyle];
        }
    }
    
    NSString* text;
    if([baseContentModel.text isExist])
        text = baseContentModel.text;
    else if(baseContentModel.wordStyle.wordName)
        text = baseContentModel.wordStyle.wordName;
    if([text isExist])
    {
        if([self isKindOfClass:[UILabel class]])
            ((UILabel*)self).text = text;
        else if([self isKindOfClass:[UIButton class]])
            [(UIButton*)self setTitle:text forState:UIControlStateNormal];
        else if([self isKindOfClass:[UIImageView class]])
            ((UIImageView*)self).image = [UIImage imageNamed:text];
    }
}

-(MTBaseViewContentModel *)baseContentModel{return objc_getAssociatedObject(self, _cmd);}

@end





@implementation UIButton(MTBaseViewContentModel)

-(void)setBaseContentModel:(MTBaseViewContentModel *)baseContentModel
{
    [super setBaseContentModel:baseContentModel];
    
    if(![baseContentModel isKindOfClass:[MTBaseButtonContentModel class]])
        return;
    
    MTBaseButtonContentModel* model = (MTBaseButtonContentModel*)baseContentModel;
    NSInteger viewState = model.viewState;
    
    model.viewState = UIControlStateNormal;
    if(model.image)
        [self  setImage:model.image forState:UIControlStateNormal];
    if(model.image_bg)
        [self  setBackgroundImage:model.image_bg  forState:UIControlStateNormal];
    if(model.textColor)
        [self setTitleColor:model.textColor forState:UIControlStateNormal];
    [self setTitle:model.text forState:UIControlStateNormal];
    
    model.viewState = UIControlStateHighlighted;
    if(model.image)
        [self  setImage:model.image forState:UIControlStateHighlighted];
    if(model.image_bg)
        [self  setBackgroundImage:model.image_bg  forState:UIControlStateHighlighted];
    if(model.textColor)
        [self setTitleColor:model.textColor forState:UIControlStateHighlighted];
    [self setTitle:model.text forState:UIControlStateHighlighted];
    
    model.viewState = UIControlStateDisabled;
    if(model.image)
        [self  setImage:model.image forState:UIControlStateDisabled];
    if(model.image_bg)
        [self  setBackgroundImage:model.image_bg  forState:UIControlStateDisabled];
    if(model.textColor)
        [self setTitleColor:model.textColor forState:UIControlStateDisabled];
    [self setTitle:model.text forState:UIControlStateDisabled];
    
    model.viewState = UIControlStateSelected;
    if(model.image)
        [self  setImage:model.image forState:UIControlStateSelected];
    if(model.image_bg)
        [self  setBackgroundImage:model.image_bg  forState:UIControlStateSelected];
    if(model.textColor)
        [self setTitleColor:model.textColor forState:UIControlStateSelected];
    [self setTitle:model.text forState:UIControlStateSelected];
    
    model.viewState = viewState;
}





@end
