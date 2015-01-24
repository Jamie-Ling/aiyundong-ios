//
//  AppDelegate.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKKNavigationController.h"
#import "MSIntroView.h"

@interface AppDelegate ()<EAIntroDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    _vc = [HomeVC custom];
    self._mainNavigationController = [[UINavigationController alloc] initWithRootViewController: _vc];
    
    self.window.rootViewController = self._mainNavigationController;
    
    //导航条设置
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"1_01"] forBarMetrics:UIBarMetricsDefault];
    
    //添加介绍页
    [self addIntroView];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ---------------- 介绍页 & 介绍页回调-----------------
//添加介绍页
- (void) addIntroView
{
    if (![[ObjectCTools shared] objectForKey:@"introViewShow"])
    {
        [MSIntroView initWithType: showIntroWithCrossDissolve rootView: self.window.rootViewController.view delegate: self];
        
        //测试--给一个本地的测试用户信息
        NSDictionary *testUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"", kUserInfoOfHeadPhotoKey,
                                      @"1987-01-01", kUserInfoOfAgeKey,
                                      @"深圳长沙", kUserInfoOfAreaKey,
                                      @"天将降大任于斯人也，必先苦其心志...", kUserInfoOfDeclarationKey,
                                      @"172", kUserInfoOfHeightKey,
                                      @"上网、爬山、蹦极", kUserInfoOfInterestingKey,
                                      @"一休哥", kUserInfoOfNickNameKey,
                                      @"男", kUserInfoOfSexKey,
                                      @"56", kUserInfoOfWeightKey, nil
                                      ];
        [[NSUserDefaults standardUserDefaults] setObject:testUserInfo forKey:kLastLoginUserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//介绍页完成回调
- (void) introDidFinish:(EAIntroView *)introView
{
    NSLog(@"介绍页加载完毕");
    [[ObjectCTools shared] setobject:[NSNumber numberWithInt:1] forKey:@"introViewShow"];
}


@end
