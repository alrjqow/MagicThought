//
//  MTCountButton.m
//  8kqw
//
//  Created by 八块钱网 on 2017/6/8.
//  Copyright © 2017年 com.bkqw.app. All rights reserved.
//

#import "MTCountButton.h"
#import "MTConst.h"
#import "NSString+Exist.h"

NSString*  MTCountButtonDidFinishedCountDownOrder = @"MTCountButtonDidFinishedCountDownOrder";
@interface MTCountButton ()

@property(nonatomic,strong) NSTimer* timer;

@property(nonatomic,strong) NSString* title;

@property(nonatomic,assign) NSInteger time;

@property (nonatomic,strong) NSString* countDownTitle;

@end

@implementation MTCountButton

-(void)startCountWithTitle:(NSString*)title Time:(NSInteger)time
{
    [self startCountWithTitle:title Time:time CountDownTitle:nil];
}

-(void)startCountWithTitle:(NSString*)title Time:(NSInteger)time CountDownTitle:(NSString*)countDownTitle
{
    self.enabled = false;
    
    self.countDownTitle = countDownTitle;
    
    //使用_mt_来替代秒数
    [self setTitle:[title stringByReplacingOccurrencesOfString:@"_mt_" withString:[NSString stringWithFormat:@"%zd",time]] forState:UIControlStateNormal];
    self.title = title;
    self.time = time;
    
    [self setupTimer];
}

-(void)countdown
{
    if(!self.time)
    {
        [self stopTimer];
        self.enabled = YES;
        
        if([self.countDownTitle isExist])
        {
           [self setTitle:self.countDownTitle forState:UIControlStateNormal];
            self.countDownTitle = nil;
        }
        
        
        if([self.mt_delegate respondsToSelector:@selector(doSomeThingForMe:withOrder:)])
           [self.mt_delegate doSomeThingForMe:self withOrder:MTCountButtonDidFinishedCountDownOrder];
        return;
    }
    
    self.time--;
    [self setTitle:[self.title stringByReplacingOccurrencesOfString:@"_mt_" withString:[NSString stringWithFormat:@"%zd",self.time]] forState:UIControlStateDisabled];
}


-(void)setupTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)dealloc
{
    [self stopTimer];
}


@end
