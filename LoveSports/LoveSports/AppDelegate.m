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

@interface AppDelegate ()<EAIntroDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSLog(@"..%d..%d..%d", (0x08 << 8) | 0x9f, 0xdc, 0x67);
    // 启动蓝牙并自动接受数据
    [BLTAcceptData sharedInstance];
    
    //添加测试数据
    [self addTestData];
    
    /*
     _vc = [HomeVC custom];
     self._mainNavigationController = [[UINavigationController alloc] initWithRootViewController: _vc];
     
     self.window.rootViewController = self._mainNavigationController;
     */
    [self pushToLoginVC];
    
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


#pragma mark ---------------- 测试数据构造  -----------------
- (void) addTestData
{
    if (![[ObjectCTools shared] objectForKey:@"addTestDataForTest"])
    {
        [MSIntroView initWithType: showIntroWithCrossDissolve rootView: self.window.rootViewController.view delegate: self];
        
        //测试--给一个本地现在登录的测试用户信息
        NSDictionary *testUserInfoNow = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"http://www.woyo.li/statics/users/avatar/59/thumbs/200_200_59.jpg?1419043871", kUserInfoOfHeadPhotoKey,
                                         @"1987-01-01", kUserInfoOfAgeKey,
                                         @"深圳 长沙", kUserInfoOfAreaKey,
                                         @"天将降大任于斯人也，必先苦其心志...", kUserInfoOfDeclarationKey,
                                         @"178", kUserInfoOfHeightKey,
                                         @"上网、爬山、蹦极", kUserInfoOfInterestingKey,
                                         @"一休哥", kUserInfoOfNickNameKey,
                                         @"男", kUserInfoOfSexKey,
                                         @"56", kUserInfoOfWeightKey, nil
                                         ];
        [[ObjectCTools shared] userAddUserInfo:testUserInfoNow];
        
        //测试--给另外2个曾经登录的测试用户信息
        NSDictionary *testUserInfo01 = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"http://www.woyo.li/statics/users/avatar/46/thumbs/200_200_46.jpg?1422252425", kUserInfoOfHeadPhotoKey,
                                        @"1989-06-06", kUserInfoOfAgeKey,
                                        @"广州 佛山", kUserInfoOfAreaKey,
                                        @"红雨漂泊泛起了回忆怎么浅...", kUserInfoOfDeclarationKey,
                                        @"168", kUserInfoOfHeightKey,
                                        @"KTV", kUserInfoOfInterestingKey,
                                        @"关淑南", kUserInfoOfNickNameKey,
                                        @"女", kUserInfoOfSexKey,
                                        @"47", kUserInfoOfWeightKey, nil
                                        ];
        
        
        NSDictionary *testUserInfo02 = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"http://www.woyo.li/statics/users/avatar/62/thumbs/200_200_62.jpg?1418642044", kUserInfoOfHeadPhotoKey,
                                        @"1977-01-01", kUserInfoOfAgeKey,
                                        @"少林寺", kUserInfoOfAreaKey,
                                        @"花开堪折直须折，莫待无花空折枝", kUserInfoOfDeclarationKey,
                                        @"172", kUserInfoOfHeightKey,
                                        @"男", kUserInfoOfInterestingKey,
                                        @"大叔", kUserInfoOfNickNameKey,
                                        @"男", kUserInfoOfSexKey,
                                        @"66", kUserInfoOfWeightKey, nil
                                        ];
        [[ObjectCTools shared] userAddUserInfo:testUserInfo02];
        [[ObjectCTools shared] userAddUserInfo:testUserInfo01];
        
//        //测试 添加 搜索到的设备 3 个
//        for (int i = 0; i < 3; i++)
//        {
//            BraceletInfoModel *oneBraceletInfoModel = [[BraceletInfoModel alloc] init];
//            //,版本号以及电量，设备id
//            oneBraceletInfoModel._deviceVersion = @"VB 1.01";
//            oneBraceletInfoModel._deviceElectricity = 0.85 / (i + 1.0);
//            oneBraceletInfoModel._deviceID = [NSString stringWithFormat:@"test000000000%d", i];
//            
//            //初始化后需要设置默认名等,并存入DB
//            [oneBraceletInfoModel setNameAndSaveToDB];
//        }
        
        //只设置一次测试数据
        [[ObjectCTools shared] setobject:[NSNumber numberWithInt:1] forKey:@"addTestDataForTest"];
        
    }
    
    BraceletInfoModel *oneBraceletInfoModel = [[BraceletInfoModel alloc] init];
    //,版本号以及电量，设备id
    oneBraceletInfoModel._deviceVersion = @"VB 1.01";
    oneBraceletInfoModel._deviceElectricity = 0.85 / (1 + 1.0);
    oneBraceletInfoModel._deviceID = @"test0000000001324";
    
    //初始化后需要设置默认名等,并存入DB
    [oneBraceletInfoModel setNameAndSaveToDB];
    
}

- (void)pushToContentVC
{
    _vc = [HomeVC custom];
    self._mainNavigationController = [[ZKKNavigationController alloc] initWithRootViewController: _vc];
    
    self.window.rootViewController = self._mainNavigationController;
}

- (void)pushToLoginVC
{
    LoginVC *login = [[LoginVC alloc] init];
    ZKKNavigationController *nav = [[ZKKNavigationController alloc] initWithRootViewController: login];
    
    self.window.rootViewController = nav;
}

@end
