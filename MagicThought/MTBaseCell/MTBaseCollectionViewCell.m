//
//  MTBaseCollectionViewCell.m
//  SimpleProject
//
//  Created by monda on 2019/5/13.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTBaseCollectionViewCell.h"
#import "MTContentModelPropertyConst.h"

@interface MTBaseCollectionViewCell ()<UITextViewDelegate>
{
    UIButton* _button;
    UIButton* _button2;
    UIButton* _button3;
    UIButton* _button4;
}

@end


@implementation MTBaseCollectionViewCell

-(void)whenGetResponseObject:(MTViewContentModel *)contentModel
{
    self.contentModel = contentModel;
}

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    __weak __typeof(self) weakSelf = self;
    
    _contentModel = contentModel;
    
    self.baseContentModel = contentModel;
    
    [self setSubView:_textLabel Model:contentModel.mtTitle For:^UIView *{
        return weakSelf.textLabel;
    }];
    
    [self setSubView:_detailTextLabel Model:contentModel.mtContent For:^UIView *{
        return weakSelf.detailTextLabel;
    }];
    
    [self setSubView:_detailTextLabel2 Model:contentModel.mtContent2 For:^UIView *{
        return weakSelf.detailTextLabel2;
    }];
    
    [self setSubView:_detailTextLabel3 Model:contentModel.mtContent3 For:^UIView *{
        return weakSelf.detailTextLabel3;
    }];
    
    [self setSubView:_imageView Model:contentModel.mtImg For:^UIView *{
        return weakSelf.imageView;
    }];
    
    [self setSubView:_imageView2 Model:contentModel.mtImg2 For:^UIView *{
        return weakSelf.imageView2;
    }];
    
    [self setSubView:_imageView3 Model:contentModel.mtImg3 For:^UIView *{
        return weakSelf.imageView3;
    }];
    
    [self setSubView:_imageView4 Model:contentModel.mtImg4 For:^UIView *{
        return weakSelf.imageView4;
    }];
    
    [self setSubView:_button Model:contentModel.mtBtnTitle For:^UIView *{
        return weakSelf.button;
    }];
    
    [self setSubView:_button2 Model:contentModel.mtBtnTitle2 For:^UIView *{
        return weakSelf.button2;
    }];
    
    [self setSubView:_button3 Model:contentModel.mtBtnTitle3 For:^UIView *{
        return weakSelf.button3;
    }];
    
    [self setSubView:_button4 Model:contentModel.mtBtnTitle4 For:^UIView *{
        return weakSelf.button4;
    }];
    
    [self setSubView:_textField Model:contentModel.mtTextField For:^UIView *{
        return weakSelf.textField;
    }];
    
    [self setSubView:_textView Model:contentModel.mtTextView For:^UIView *{
        return weakSelf.textView;
    }];
    
    [self setSubView:_externView Model:(MTBaseViewContentModel*)contentModel.mtExternContent For:^UIView *{
        return weakSelf.externView;
                                 }];
}

-(void)setSubView:(UIView*)view Model:(MTBaseViewContentModel*)baseViewContentModel For:(UIView* (^)(void))getView
{
    MTBaseViewContentModel* contentModel;
    if(baseViewContentModel)
    {
        if(!view && !getView)
            return;
        if(!view)
            view = getView();
        if(!view)
            return;
        contentModel = baseViewContentModel;
    }
    else
    {
        if(!view)
            return;
        contentModel = view.defaultViewContent;
    }
    
    [self setSubView:view Model:contentModel];
}

-(void)setSubView:(UIView*)view Model:(MTBaseViewContentModel*)baseViewContentModel
{
    NSInteger startViewState = kDefault;
    MTBaseViewContentModel* dataModel;
    MTBaseViewContentModel* reSetModel;
     if([baseViewContentModel isKindOfClass:[NSDictionary class]])
     {
         NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)baseViewContentModel];
         NSNumber* viewState = dict[kViewState];
         if([viewState isKindOfClass:[NSNumber class]])
             startViewState = viewState.integerValue;
         
         dict[kViewState] = @(self.contentModel.viewState);
         dataModel = (MTBaseViewContentModel*)dict;
         
         if(dict[@"beDefault"])
             reSetModel = view.defaultViewContent;
         else
             reSetModel = view.baseContentModel;
     }
    else if([baseViewContentModel isKindOfClass:[MTBaseViewContentModel class]])
    {
        startViewState = baseViewContentModel.viewState;
        
        if(baseViewContentModel.viewState == kDefault)
            baseViewContentModel.viewState = self.contentModel.viewState;
        dataModel = baseViewContentModel;
        
        reSetModel = baseViewContentModel;
    }
    else
    {
        if(baseViewContentModel)
            view.objects(baseViewContentModel);
        return;
    }
    
    if(view == _externView)
        view.objects(dataModel);
    else
        view.baseContentModel = dataModel;
    
    reSetModel.viewState = startViewState;
}

-(void)setupDefault
{
    [super setupDefault];
    
    self.isDragEnable = false;
}

-(CGSize)layoutSubviewsForWidth:(CGFloat)contentWidth Height:(CGFloat)contentHeight
{
    [_externView sizeToFit];
    [_textLabel sizeToFit];
    [_detailTextLabel sizeToFit];
    [_detailTextLabel2 sizeToFit];
    [_detailTextLabel3 sizeToFit];
    
    [_imageView sizeToFit];
    [_imageView2 sizeToFit];
    [_imageView3 sizeToFit];
    [_imageView4 sizeToFit];
    
    [_button sizeToFit];
    [_button2 sizeToFit];
    [_button3 sizeToFit];
    [_button4 sizeToFit];
    
    [_textField sizeToFit];
    [_textView sizeToFit];
    
    return CGSizeZero;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    if(self.mt_automaticDimension)
        return;    
                            
    [self layoutSubviewsForWidth:self.width Height:self.height];
}

-(void)configButton:(UIButton*)button WithOrder:(NSString*)order
{
    button.bindOrder(order);
    [button setValue:@(YES) forKey:@"autoClick"];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)buttonClick:(UIButton*)btn
{
    if(btn.mt_tag != kSelectedForever && btn.mt_tag != kDefaultForever)
        btn.bindEnum(btn.mt_tag == kSelected ? kDeselected : kSelected);
    [self viewEventWithView:btn Data:self.indexPath ? self.indexPath : mt_empty()];
}

#pragma mark - 代理

-(void)didTextValueChange:(UITextField *)textField
{
    textField.bindEnum(kTextValueChange);
    textField.bindTagText(textField.text);
    [self viewEventWithView:_textField Data:self.indexPath];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.bindEnum(kBeginEditing);
    textField.bindTagText(textField.text);
    [self viewEventWithView:_textField Data:self.indexPath];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.bindEnum(kEndEditing);
    textField.bindTagText(textField.text);
    [self viewEventWithView:_textField Data:self.indexPath];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    textField.bindEnum(kEndEditingReturn);
    textField.bindTagText(textField.text);
    [self viewEventWithView:_textField Data:self.indexPath];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.baseContentModel.wordStyle.isAttributedWord)
        textView.attributedText = [textView.baseContentModel.wordStyle createAttributedWordName:textView.text];
    
    textView.bindEnum(kTextValueChange);
    textView.bindTagText(textView.text);
    [self viewEventWithView:textView Data:self.indexPath];
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

-(void)setButton:(UIButton *)button
{
    _button = button;
    [self configButton:button WithOrder:kBtnTitle];
}

-(void)setButton2:(UIButton *)button2
{
    _button2 = button2;
    [self configButton:button2 WithOrder:kBtnTitle2];
}

-(void)setButton3:(UIButton *)button3
{
    _button3 = button3;
    [self configButton:button3 WithOrder:kBtnTitle3];
}

-(void)setButton4:(UIButton *)button4
{
    _button4 = button4;
    [self configButton:button4 WithOrder:kBtnTitle4];
}

-(UIButton *)button
{
    if(!_button)
    {
        self.button = [UIButton new];
    }
    
    return _button;
}

-(UIButton *)button2
{
    if(!_button2)
    {
        self.button2 = [UIButton new];
    }
    
    return _button2;
}

-(UIButton *)button3
{
    if(!_button3)
    {
        self.button3 = [UIButton new];
    }
    
    return _button3;
}

-(UIButton *)button4
{
    if(!_button4)
    {
        self.button4 = [UIButton new];
    }
    
    return _button4;
}

-(UIView *)externView
{
    if(!_externView)
    {
        _externView = [UIView new];
        [self addSubview:_externView];
    }
    
    return _externView;
}

-(MTTextField *)textField
{
    if(!_textField)
    {
        _textField = [MTTextField new];
        _textField.mt_delegate = self;
        _textField.bindOrder([NSString stringWithFormat:@"%@",kTextField]);
        [self addSubview:_textField];
    }
    
    return _textField;
}

-(MTTextView *)textView
{
    if(!_textView)
    {
        _textView = [MTTextView new];
        _textView.mt_delegate = self;
        _textView.bindOrder([NSString stringWithFormat:@"%@",kTextView]);
        [self addSubview:_textView];
    }
    
    return _textView;
}

@end

@interface MTBaseSubCollectionViewCell ()
{
    UIButton* _button5;
}
@end

@implementation MTBaseSubCollectionViewCell

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    [super setContentModel:contentModel];
    
    __weak __typeof(self) weakSelf = self;
    
    [self setSubView:_detailTextLabel4 Model:contentModel.mtContent4 For:^UIView *{
        return weakSelf.detailTextLabel4;
    }];
    
    [self setSubView:_imageView5 Model:contentModel.mtImg5 For:^UIView *{
        return weakSelf.imageView5;
    }];
    
    [self setSubView:_button5 Model:contentModel.mtBtnTitle5 For:^UIView *{
        return weakSelf.button5;
    }];
}


#pragma mark - 懒加载

-(UILabel *)detailTextLabel4
{
    if(!_detailTextLabel4)
    {
        _detailTextLabel4 = [UILabel new];
        [self addSubview:_detailTextLabel4];
    }
    
    return _detailTextLabel4;
}

- (UIImageView *)imageView5
{
    if(!_imageView5)
    {
        _imageView5 = [UIImageView new];
        [self addSubview:_imageView5];
    }
    
    return _imageView5;
}

-(void)setButton5:(UIButton *)button5
{
    _button5 = button5;
    [self configButton:button5 WithOrder:kBtnTitle5];
}

-(UIButton *)button5
{
    if(!_button5)
    {
        self.button5 = [UIButton new];
    }
    
    return _button5;
}

@end

@interface MTBaseSubCollectionViewCell2 ()
{
    UIButton* _button6;
}
@end

@implementation MTBaseSubCollectionViewCell2

-(void)setContentModel:(MTViewContentModel *)contentModel
{
    [super setContentModel:contentModel];
    
    __weak __typeof(self) weakSelf = self;
    
    [self setSubView:_detailTextLabel5 Model:contentModel.mtContent5 For:^UIView *{
        return weakSelf.detailTextLabel5;
    }];
    
    [self setSubView:_imageView6 Model:contentModel.mtImg6 For:^UIView *{
        return weakSelf.imageView6;
    }];
    
    [self setSubView:_button6 Model:contentModel.mtBtnTitle6 For:^UIView *{
        return weakSelf.button6;
    }];
}

#pragma mark - 懒加载

-(UILabel *)detailTextLabel5
{
    if(!_detailTextLabel5)
    {
        _detailTextLabel5 = [UILabel new];
        [self addSubview:_detailTextLabel5];
    }
    
    return _detailTextLabel5;
}

-(UIImageView *)imageView6
{
    if(!_imageView6)
    {
        _imageView6 = [UIImageView new];
        [self addSubview:_imageView6];
    }
    
    return _imageView6;
}

-(void)setButton6:(UIButton *)button6
{
    _button6 = button6;
    [self configButton:button6 WithOrder:kBtnTitle6];
}

-(UIButton *)button6
{
    if(!_button6)
    {
        self.button6 = [UIButton new];
    }
    
    return _button6;
}


@end
