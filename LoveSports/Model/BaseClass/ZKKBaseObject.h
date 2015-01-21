//
//  ZKKBaseObject.h
//  VPhone
//
//  Created by zorro on 14-10-24.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ZKKBaseObject : NSObject

+ (UIViewController *) topMostController;

/**
 * 显示MBProgressHUD指示器
 * api parameters 说明
 * aTitle 标题
 * aMsg 信息
 * aImg 图片, 为nil时,只显示标题
 * d 延时消失时间, 为0时需要主动隐藏
 * blockE 执行的代码快
 * blockF 结束时的代码块
 * 执行时改变hub需要调用Common_MainFun(aFun)
 */
#define HIDDENMBProgressHUD [ZKKBaseObject hiddenMBProgressHUD];
+(void) hiddenMBProgressHUD;

+(MBProgressHUD *) MBProgressHUD;

#define SHOWMBProgressHUD(aTitle, aMsg, aImg, aDimBG, aDelay) [ZKKBaseObject showMBProgressHUDTitle:aTitle msg:aMsg image:aImg dimBG:aDimBG delay:aDelay];
+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg image:(UIImage *)aImg dimBG:(BOOL)dimBG delay:(float)d;

#define SHOWMBProgressHUDIndeterminate(aTitle, aMsg, aDimBG) [ZKKBaseObject showMBProgressHUDModeIndeterminateTitle:aTitle msg:aMsg dimBG:aDimBG];
+(MBProgressHUD *) showMBProgressHUDModeIndeterminateTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG;

+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG executeBlock:(void(^)(MBProgressHUD *hud))blockE finishBlock:(void(^)(void))blockF;

@end
