//
//  ZKKViewController.m
//  VPhone
//
//  Created by zorro on 14-10-22.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "ZKKViewController.h"
#import "AppDelegate.h"

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
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)loadTabBarItem
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadGestureRecognizer];
}

- (void)loadGestureRecognizer
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}

- (void)leftSwipe
{
    NSLog(@"..左扫..");
}

- (void)rightSwipe
{
    NSLog(@"..右扫..");
}

- (void)upSwipe
{
    NSLog(@"..上扫..");
    /*
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (app.window.rootViewController == app._mainNavigationController)
    {
        app.vc.selectedIndex = (app.vc.selectedIndex + 1) % app.vc.tabBar.itemsArray.count;
        
        if (app.vc.selectedIndex == 0)
        {
            app.vc.selectedIndex = 1;
        }
    }
     */
}

- (void)downSwipe
{
    NSLog(@"..下扫..");
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
