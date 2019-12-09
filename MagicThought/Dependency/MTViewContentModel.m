//
//  MTViewContentModel.m
//  QXProject
//
//  Created by monda on 2019/12/5.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTViewContentModel.h"
#import "NSString+Exist.h"
#import "NSObject+ReuseIdentifier.h"
#import <MJExtension.h>
#import "VKCssProtocol.h"
#import "UILabel+Word.h"
#import "UIButton+Word.h"
#import "UITextField+Word.h"
#import "UITextView+Word.h"

@implementation MTViewContentModel

- (NSDictionary *)tagIdentifier
{
    return @{
            @"title" : @(0),
            @"content" : @(1),
            @"content2" : @(2),
            @"img" : @(3),
            @"img2" : @(4),
            @"btn" : @(5),
            @"btn2" : @(6),
    };
}

@end

@interface MTBaseViewContentModel : NSObject

/**view 的状态*/
@property (nonatomic,assign) NSUInteger viewState;

/**view 的内容*/
@property (nonatomic,assign) NSString* title;

/**view 的 wordstyle*/
@property (nonatomic,strong) MTWordStyle* wordStyle;

/**view 的 cssclass*/
@property (nonatomic,strong) NSString* cssClass;


@end

@implementation MTBaseViewContentModel


@end


@interface UIView(MTBaseViewContentModel)

@property (nonatomic,strong) MTBaseViewContentModel* baseContentModel;

@end

@implementation UIView (MTBaseViewContentModel)

-(void)setBaseContentModel:(MTBaseViewContentModel *)baseContentModel
{
    if([baseContentModel.cssClass isExist])
           self.CssClass(baseContentModel.cssClass);
    else if(baseContentModel.wordStyle)
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
           
    NSString* text;
    if([baseContentModel.title isExist])
        text = baseContentModel.title;
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

-(MTBaseViewContentModel*)baseContentModel
{
    return nil;
}

@end

@implementation UIView (MTViewContentModel)

-(void)setContentModel:(MTViewContentModel*)contentModel
{
    if(![self.mt_tagIdentifier isExist])
        return;
    
    NSMutableDictionary* keyValue = [NSMutableDictionary dictionary];
    NSNumber* tag = contentModel.tagIdentifier[self.mt_tagIdentifier];
    
    if(![tag isKindOfClass:[NSNumber class]])
        return;
    
    switch (tag.integerValue) {
        case 0:
        {
            if([contentModel.title isExist])
                keyValue[@"title"] = contentModel.title;
            if([contentModel.titleCssClass isExist])
                keyValue[@"cssClass"] = contentModel.titleCssClass;
            if(contentModel.titleWord)
                keyValue[@"wordStyle"] = contentModel.titleWord;
            break;
        }
        case 1:
        {
            if([contentModel.content isExist])
                keyValue[@"title"] = contentModel.content;
            if([contentModel.contentCssClass isExist])
                keyValue[@"cssClass"] = contentModel.contentCssClass;
            if(contentModel.contentWord)
                keyValue[@"wordStyle"] = contentModel.contentWord;
                        
            break;
        }
        case 2:
        {
            if([contentModel.content2 isExist])
                keyValue[@"title"] = contentModel.content2;
            if([contentModel.content2CssClass isExist])
                keyValue[@"cssClass"] = contentModel.content2CssClass;
            if(contentModel.content2Word)
                keyValue[@"wordStyle"] = contentModel.content2Word;
            
            break;
        }
        case 3:
        {
            if([contentModel.img isExist])
                keyValue[@"title"] = contentModel.img;
            if([contentModel.imageViewCssClass isExist])
                keyValue[@"cssClass"] = contentModel.imageViewCssClass;
            break;
        }
        case 4:
        {
            if([contentModel.img2 isExist])
                keyValue[@"title"] = contentModel.img2;
            if([contentModel.imageView2CssClass isExist])
                keyValue[@"cssClass"] = contentModel.imageView2CssClass;
            break;
        }
        case 5:
        {
            keyValue[@"viewState"] = @(contentModel.btnState);
            if([contentModel.btnTitle isExist])
                keyValue[@"title"] = contentModel.btnTitle;
            if([contentModel.btnCssClass isExist])
                keyValue[@"cssClass"] = contentModel.btnCssClass;
            if(contentModel.btnWord)
                keyValue[@"wordStyle"] = contentModel.btnWord;
            break;
        }
        case 6:
        {
            keyValue[@"viewState"] = @(contentModel.btn2State);
            if([contentModel.btnTitle2 isExist])
                keyValue[@"title"] = contentModel.btnTitle2;
            if([contentModel.btn2CssClass isExist])
                keyValue[@"cssClass"] = contentModel.btn2CssClass;
            if(contentModel.btn2Word)
                keyValue[@"wordStyle"] = contentModel.btn2Word;
            break;
        }
            
        default:
            break;
    }
    
    self.baseContentModel = [MTBaseViewContentModel mj_objectWithKeyValues:[keyValue copy]];
}

-(MTViewContentModel*)contentModel
{
    return nil;
}

@end

