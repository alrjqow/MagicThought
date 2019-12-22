//
//  MTBaseCollectionReusableView.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCollectionReusableView.h"

@implementation MTBaseCollectionReusableView

-(void)whenGetResponseObject:(MTViewContentModel *)object
{
    self.contentModel = object;
}

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    _contentModel = contentModel;
    
    self.baseContentModel = contentModel;
    
    if(contentModel.mtTitle)
        self.textLabel.baseContentModel = contentModel.mtTitle;
    if(contentModel.mtContent)
        self.detailTextLabel.baseContentModel = contentModel.mtContent;
    if(contentModel.mtContent2)
        self.detailTextLabel2.baseContentModel = contentModel.mtContent2;
    if(contentModel.mtContent3)
        self.detailTextLabel3.baseContentModel = contentModel.mtContent3;
    
    if(contentModel.mtImg)
        self.imageView.baseContentModel = contentModel.mtImg;
    if(contentModel.mtImg2)
        self.imageView2.baseContentModel = contentModel.mtImg2;
    if(contentModel.mtImg3)
        self.imageView3.baseContentModel = contentModel.mtImg3;
    if(contentModel.mtImg4)
        self.imageView4.baseContentModel = contentModel.mtImg4;
    
    if(contentModel.mtBtnTitle)
        self.button.baseContentModel = contentModel.mtBtnTitle;
    if(contentModel.mtBtnTitle2)
        self.button2.baseContentModel = contentModel.mtBtnTitle2;
    if(contentModel.mtBtnTitle3)
        self.button3.baseContentModel = contentModel.mtBtnTitle3;
    if(contentModel.mtBtnTitle4)
        self.button4.baseContentModel = contentModel.mtBtnTitle4;
}

#pragma mark - 懒加载

-(Class)classOfResponseObject
{
    return [MTViewContentModel class];
}

-(UILabel *)textLabel
{
    if(!_textLabel)
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
    }
    
    return _textLabel;
}

-(UILabel *)detailTextLabel
{
    if(!_detailTextLabel)
    {
        _detailTextLabel = [UILabel new];
        [self addSubview:_detailTextLabel];
    }
    
    return _detailTextLabel;
}

-(UILabel *)detailTextLabel2
{
    if(!_detailTextLabel2)
    {
        _detailTextLabel2 = [UILabel new];
        [self addSubview:_detailTextLabel2];
    }
    
    return _detailTextLabel2;
}

-(UILabel *)detailTextLabel3
{
    if(!_detailTextLabel3)
    {
        _detailTextLabel3 = [UILabel new];
        [self addSubview:_detailTextLabel3];
    }
    
    return _detailTextLabel3;
}

-(UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

-(UIImageView *)imageView2
{
    if(!_imageView2)
    {
        _imageView2 = [UIImageView new];
        [self addSubview:_imageView2];
    }
    
    return _imageView2;
}

-(UIImageView *)imageView3
{
    if(!_imageView3)
    {
        _imageView3 = [UIImageView new];
        [self addSubview:_imageView3];
    }
    
    return _imageView3;
}

-(UIImageView *)imageView4
{
    if(!_imageView4)
    {
        _imageView4 = [UIImageView new];
        [self addSubview:_imageView4];
    }
    
    return _imageView4;
}

-(UIButton *)button
{
    if(!_button)
    {
        _button = [UIButton new];
        [self addSubview:_button];
    }
    
    return _button;
}

-(UIButton *)button2
{
    if(!_button2)
    {
        _button2 = [UIButton new];
        [self addSubview:_button2];
    }
    
    return _button2;
}

-(UIButton *)button3
{
    if(!_button3)
    {
        _button3 = [UIButton new];
        [self addSubview:_button3];
    }
    
    return _button3;
}

-(UIButton *)button4
{
    if(!_button4)
    {
        _button4 = [UIButton new];
        [self addSubview:_button4];
    }
    
    return _button4;
}


@end



