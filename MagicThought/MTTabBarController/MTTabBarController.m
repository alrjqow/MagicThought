//
//  MTTabBarController.m
//  MagicThought
//
//  Created by monda on 2019/11/29.
//  Copyright © 2019 monda. All rights reserved.
//

#import "MTTabBarController.h"
#import "MTTabBarItem.h"
#import "MTDelegateProtocol.h"
#import "NSObject+ReuseIdentifier.h"
#import "NSString+Exist.h"
#import <MJExtension.h>

@interface MTTabBarController ()

@end

@implementation MTTabBarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDefault];
}

-(void)setupDefault
{
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    
    [self setupChildController];
}

-(void)setupChildController
{
    NSArray<MTTabBarItem*>* arr = [MTTabBarItem mj_objectArrayWithKeyValuesArray:self.tabBarItemArr];
    
    id obj;
    Class c, c1;
    NSString* preReuseIdentifier, *preRootController;    
    BOOL isReuseIdentifierEqual = false, isNotController = false;
    for (MTTabBarItem* item in arr) {
             
        if(![item.mt_reuseIdentifier isExist])
            continue;
        
        isReuseIdentifierEqual = [preReuseIdentifier isEqualToString:item.mt_reuseIdentifier];
        if(!isReuseIdentifierEqual)
            c = NSClassFromString(item.mt_reuseIdentifier);
        if(isReuseIdentifierEqual && isNotController);
        else
        {
            if(isReuseIdentifierEqual && [obj isKindOfClass:[UINavigationController class]]);
            else
                obj = c.new;
        }
            
        
        if(![obj isKindOfClass:[UIViewController class]])
        {
            isNotController = YES;
            continue;
        }
            
        isNotController = false;
        
                
        UIViewController* vc;
        if([obj isKindOfClass:[UINavigationController class]])
        {
            if([item.rootController isExist])
            {
                if(![preRootController isEqualToString:item.rootController])
                    c1 = NSClassFromString(item.rootController);
                id obj2 = c1.new;
                if([obj2 isKindOfClass:[UIViewController class]])
                {
                    UINavigationController* nvc = [[c alloc] initWithRootViewController:obj2];
                    nvc.tabBarItem = item;
                    obj = nvc;
                }
            }
            else
            {
                if(isReuseIdentifierEqual)
                    obj = c.new;
            }
        }
                    

        if([item.order isExist] && [obj respondsToSelector:@selector(getSomeThingForMe:withOrder:withItem:)])
        {
            [obj getSomeThingForMe:self withOrder:item.order withItem:item.data];
        }
        
        vc = obj;
        
        [self addChildViewController:vc];
        preReuseIdentifier = item.mt_reuseIdentifier;
        preRootController = item.rootController;
    }
}


#pragma mark - 懒加载

-(void)setTabBar_mt:(UITabBar *)tabBar_mt
{
    _tabBar_mt = tabBar_mt;
    [self setValue:tabBar_mt forKey:@"tabBar"];
    
    [self.view layoutIfNeeded];
}

@end
