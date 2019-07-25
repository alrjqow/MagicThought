//
//  MTDatePickerViewController.m
//  8kqw
//
//  Created by 王奕聪 on 16/10/12.
//  Copyright © 2016年 com.bkqw.app. All rights reserved.
//

#import "MTDatePickerViewController.h"

@interface MTDatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickView;

@end

@implementation MTDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}




- (IBAction)submit:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* date = [formatter stringFromDate:self.datePickView.date];
    
    if ([self.delegate respondsToSelector:@selector(datePickView:WithDate:)])
        [self.delegate datePickView:self.datePickView WithDate:date];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
