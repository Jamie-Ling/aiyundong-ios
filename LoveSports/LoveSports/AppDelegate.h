//
//  AppDelegate.h
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) HomeVC *vc;

@property (strong, nonatomic) UINavigationController *_mainNavigationController;        //主页面主流程控制器
@property (strong, nonatomic) UINavigationController *_loginNavigationController;          //登录、注册流程控制器


/**
 *  退出登录
 */
- (void) signOut;

@end

