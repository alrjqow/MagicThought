//
//  MTPickerViewController.m
//  8kqw
//
//  Created by 王奕聪 on 16/10/12.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import "MTPickerViewController.h"
#import "NSString+Exist.h"

@interface MTPickerViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property(nonatomic,assign) BOOL isArrayItem;

@property (weak, nonatomic) IBOutlet UILabel *pickViewTheme;

@property(nonatomic,strong) NSMutableArray* itemArr;
@property(nonatomic,strong) NSMutableArray* valueArr;

@end

@implementation MTPickerViewController

-(NSMutableArray *)valueArr
{
    if(!_valueArr)
    {
        _valueArr = [NSMutableArray array];
    }
    
    return _valueArr;
}

-(NSMutableArray *)itemArr
{
    if(!_itemArr)
    {
        _itemArr = [NSMutableArray array];
    }
    
    return _itemArr;
}


-(void)setPickerItems:(NSArray *)pickerItems
{
    _pickerItems = pickerItems;
    
    self.isArrayItem = [pickerItems.firstObject isKindOfClass:[NSArray class]];
    
    if(self.isArrayItem) //如果是数组，先判断数组里的第一个元素是否为字典
    {
        if([((NSArray*)pickerItems.firstObject).firstObject isKindOfClass:[NSDictionary class]])
        {
            for(NSArray* arr in pickerItems)
            {
                NSMutableArray* itemArr = [NSMutableArray array];
                NSMutableArray* valueArr = [NSMutableArray array];
                
                for(NSDictionary* dict in arr)
                {
                    [itemArr addObject:dict[@"item"]];
                    [valueArr addObject:dict[@"value"]];
                }
                
                [self.itemArr addObject:[itemArr copy]];
                [self.valueArr addObject:[valueArr copy]];
            }
        }
        else //说明是单元素
        {
            for(NSArray* arr in pickerItems)
            {
                [self.itemArr addObject:arr];
            }
        }
    }
    else //若果不为数组，则说明是单元素，判断是否为字典
    {
        if([pickerItems.firstObject isKindOfClass:[NSDictionary class]])
        {
            for(NSDictionary* dict in pickerItems)
            {
                [self.itemArr addObject:dict[@"item"]];
                [self.valueArr addObject:dict[@"value"]];
            }
        }
        else//说明是单元素
        {
            [self.itemArr addObjectsFromArray:pickerItems];
        }
    }
    
    
    [self.pickView reloadAllComponents];
}

-(void)setPickerTitle:(NSString *)pickerTitle
{
    _pickerTitle = pickerTitle;
    self.pickViewTheme.text = pickerTitle;
}

-(instancetype)init
{
    if(self = [super init])
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

-(void)setPickerHeight:(CGFloat)pickerHeight
{
    if(!pickerHeight) return;
    
    _pickerHeight = pickerHeight;
    self.heightConstraint.constant = pickerHeight;
    [self.view layoutIfNeeded];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickViewTheme.text = self.pickerTitle;
    self.heightConstraint.constant = self.pickerHeight;
}

#pragma mark - pickView代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if(!self.itemArr.count) return 0;
    
    
    return self.isArrayItem ? self.itemArr.count : 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.isArrayItem ? ((NSArray*)self.itemArr[component]).count : self.itemArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.isArrayItem ? self.itemArr[component][row] : self.itemArr[row];
}


- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)submit:(id)sender
{
    NSString* item = @"";
    NSString* value = @"";
    if(self.isArrayItem)
    {
        NSInteger count = self.itemArr.count;
        
        for(int i = 0; i < count; i++)
        {
            NSInteger rowIndex = [self.pickView selectedRowInComponent:i];
            
            item = [item stringByAppendingString:self.itemArr[i][rowIndex]];
            if(i < self.valueArr.count && rowIndex < ((NSArray*)self.valueArr[i]).count)
                value = [value stringByAppendingString:self.valueArr[i][rowIndex]];
        }
    }
    else
    {
        if(!self.pickView.numberOfComponents)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        NSInteger rowIndex = [self.pickView selectedRowInComponent:0];
        item = self.itemArr[rowIndex];
        if(rowIndex < self.valueArr.count)
            value = self.valueArr[rowIndex];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickView:WithItem:)])
        [self.delegate pickView:self.pickView WithItem:@{@"item" : item,@"value" : [value isExist] ? value : item}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
