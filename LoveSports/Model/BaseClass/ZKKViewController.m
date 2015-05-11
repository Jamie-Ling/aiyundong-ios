//
//  ZKKViewController.m
//  VPhone
//
//  Created by zorro on 14-10-22.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "ZKKViewController.h"
#import "AppDelegate.h"

@interface ZKKViewController ()

@property (nonatomic, assign) CGPoint beginPoint;

@end

@implementation ZKKViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadTabBarItem];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        HIDDENMBProgressHUD;
    });
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)loadTabBarItem
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

// 下面的是6.0以后的
#pragma mark 旋屏
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
#pragma mark -todo

    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
