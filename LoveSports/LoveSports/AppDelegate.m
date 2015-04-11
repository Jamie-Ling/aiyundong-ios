//
//  AppDelegate.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AppDelegate.h"
#import "MSIntroView.h"
#import "BraceletInfoModel.h"
#import "BLTManager.h"
#import "BLTAcceptData.h"
#import "DownloadEntity.h"
#import "BLTDFUBaseInfo.h"
#import "ViewController.h"
#import "UserInfoHelp.h"

@interface AppDelegate ()<EAIntroDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   // 80770100 008d0200 00130000 009a0100 00000000

    [self createVideoFloders];

    [[DataShare sharedInstance] checkDeviceModel];

    // 启动蓝牙并自动接受数据
    [BLTAcceptData sharedInstance];
    [BLTRealTime sharedInstance];
    
    // 生成用户与最后使用过的手环
    [UserInfoHelp sharedInstance];
    
    [[DownloadEntity sharedInstance] downloadFileWithWebsite:DownLoadEntity_UpdateZip withRequestType:DownloadEntityRequestUpgradePatch];

    //添加默认数据
    [self addTestData];
    //添加信息完善页，如果已添加，直接进入主页
    if ((![[ObjectCTools shared] objectForKey:@"addVC"]))
    {
          [self addLoginView:YES];
       
    }
    else
    {
        [self pushToContentVC];
    }
    
    /*
     _vc = [HomeVC custom];
     self._mainNavigationController = [[UINavigationController alloc] initWithRootViewController: _vc];
     
     self.window.rootViewController = self._mainNavigationController;
     */
//    [self pushToContentVC];
    
    //导航条设置
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"1_01"] forBarMetrics:UIBarMetricsDefault];
    
    //修改导航条标题栏颜色
    [[UINavigationBar appearance] setBarTintColor: kNavigationBarColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    //按效果图的导航条只能设置成黑色，要么隐藏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //添加介绍页
    [self addIntroView];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)createVideoFloders
{
    NSLog(@"..%@", [XYSandbox libCachePath]);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_UpgradePatch] error:nil];
    
    [XYSandbox createDirectoryAtPath:[[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_Others]];
    [XYSandbox createDirectoryAtPath:[[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_UpgradePatch]];
    
    [XYSandbox createDirectoryAtPath:[[XYSandbox docPath] stringByAppendingPathComponent:@"/db/"]];
    [XYSandbox createDirectoryAtPath:[[XYSandbox docPath] stringByAppendingPathComponent:@"/dbimg/"]];
    
    // 通知不用上传备份
    [[[XYSandbox docPath] stringByAppendingPathComponent:@"/db/"] addSkipBackupAttributeToItem];
    [[[XYSandbox docPath] stringByAppendingPathComponent:@"/dbimg/"] addSkipBackupAttributeToItem];
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
    
    // 进入前台的时候蓝牙连接的话就同步.
    [[BLTSimpleSend sharedInstance] synHistoryDataEnterForeground];
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
    }
}

//介绍页完成回调
- (void) introDidFinish:(EAIntroView *)introView
{
    NSLog(@"介绍页加载完毕");
    [[ObjectCTools shared] setobject:[NSNumber numberWithInt:1] forKey:@"introViewShow"];
}


#pragma mark ---------------- 登录  &  退出-----------------
//准备去登录（包括持续登录校验）
- (void) readyToLogin: (BOOL) animated
{
    //token不显式保存
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];
    if (!userInfo)
    {
        [self addLoginView: animated];
    }
    else
    {
        NSLog(@"持续登录...");
        //持续登录
        //            println("持续登录token字典为== \(userToken)");
        //            println("将本地个人信息凭证发送服务器进行验证,通过后直接广播刷新所有用户相关信息，进入主页")
    }
}

/**
 @brief 添加登录页（用于非持续登录或退出当前用户后跳转回登录页）
 @param animated  BOOL: YES表示动画的形式添加，NO表示非动画形式添加
 */
- (void) addLoginView: (BOOL) animated
{
    NSLog(@"添加登录页面");
    [self pushToLoginVC];
}

/**
 @brief 注销登录
 */
- (void) signOut
{
    //先确保服务器退出，再本地退出
    [self localSignOut];
    
}


//本地退出
- (void) localSignOut
{
    [self addLoginView:YES];
}


#pragma mark ---------------- 测试数据构造---也作为默认本地用户数据构造  -----------------
- (void) addTestData
{
}

- (void)pushToContentVC
{
    _vc = [HomeVC custom];
    self._mainNavigationController = [[ZKKNavigationController alloc] initWithRootViewController: _vc];
    
    self.window.rootViewController = self._mainNavigationController;
}

- (void)pushToLoginVC
{
//    LoginVC *login = [[LoginVC alloc] init];
//    ZKKNavigationController *nav = [[ZKKNavigationController alloc] initWithRootViewController: login];
//    
//    self.window.rootViewController = nav;
    
    
    ViewController *VC = [[ViewController alloc] init];
        ZKKNavigationController *nav = [[ZKKNavigationController alloc] initWithRootViewController: VC];
    //
        self.window.rootViewController = nav;
    
}

@end
