//
//  AppDelegate.h
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"
#import "LoginVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) HomeVC *vc;

@property (strong, nonatomic) UINavigationController *_mainNavigationController;        //主页面主流程控制器
@property (strong, nonatomic) UINavigationController *_loginNavigationController;          //登录、注册流程控制器


/**
 @brief 添加登录页（用于非持续登录或退出当前用户后跳转回登录页）
 @param animated  BOOL: YES表示动画的形式添加，NO表示非动画形式添加
 */
- (void)addLoginView: (BOOL)animated;

/**
 *  退出登录
 */
- (void) signOut;

- (void)pushToContentVC;
- (void)pushToLoginVC;

@end

