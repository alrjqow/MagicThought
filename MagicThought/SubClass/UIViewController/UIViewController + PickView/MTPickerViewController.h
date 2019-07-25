//
//  MTPickerViewController.h
//  8kqw
//
//  Created by 王奕聪 on 16/10/12.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UiPickerViewDelegate <NSObject>

@optional
- (void)pickView:(UIPickerView*)pickView WithItem:(NSDictionary*)item;
- (void)datePickView:(UIDatePicker*)datePickView WithDate:(NSString*)date;

@end

@interface MTPickerViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, weak) id<UiPickerViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property(nonatomic,strong) NSString* pickerTitle;
@property(nonatomic,assign) CGFloat pickerHeight;
@property(nonatomic,strong) NSArray* pickerItems;


- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;

@end
