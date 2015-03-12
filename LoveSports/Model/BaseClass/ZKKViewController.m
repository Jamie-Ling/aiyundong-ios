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
   // [self.view addGestureRecognizer:swipe];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
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

- (void)panView:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        _beginPoint = point;
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (fabs(point.y - _beginPoint.y) < 44)
        {
            if (point.x - _beginPoint.x > 32)
            {
                [self rightSwipe];
            }
            else if (point.x - _beginPoint.x < -32)
            {
                [self leftSwipe];
            }
        }
    }
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
