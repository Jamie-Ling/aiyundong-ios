//
//  ObjectCTools.h
//  MissionSky-iOS
//
//  Created by jamie on 14-11-16.
//  Copyright (c) 2014年 Jamie.ling. All rights reserved.
//  工具集

#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface ObjectCTools : NSObject

/**
 @brief 获取工具集的单例
 */
+(ObjectCTools *)shared;

#pragma mark ---------------- 主代理获取 -----------------
/**
 @brief 获取主代理对象
 */
- (AppDelegate *)getAppDelegate;

#pragma mark ---------------- 控件封装  -----------------

/**
 *  创建导航条右按钮
 *
 *  @param title     按钮标题
 *  @param obj       按钮作用对象（响应方法的对象）
 *  @param selector  按钮响应的方法
 *  @param imageName 按钮图片名称
 *
 *  @return 右按钮对象
 */
- (UIBarButtonItem *)createRightBarButtonItem:(NSString *)title
                                       target:(id)obj
                                     selector:(SEL)selector
                                    ImageName:(NSString*)imageName;

/**
 *  创建导航条左按钮
 *
 *  @param title     按钮标题,当为@""空时，选择默认图片vBackBarButtonItemName
 *  @param obj       按钮作用对象（响应方法的对象）
 *  @param selector  按钮响应的方法
 *  @param imageName 按钮图片名称
 *
 *  @return 左按钮对象
 */
- (UIBarButtonItem *)createLeftBarButtonItem:(NSString *)title
                                      target:(id)obj
                                    selector:(SEL)selector
                                   ImageName:(NSString*)imageName;


#pragma mark ---------------- 数据持久化 ---缓存数据plist读、写、清除(个人信息数据)，文件存储等-----------------

/**
 *  写入一条数据到plist文件(个人信息数据)
 *
 *  @param object 写入的对象
 *  @param key    写入对象的key
 *
 *  @return YES:写入成功，NO:写入失败
 */
- (BOOL)setobject:(id )object forKey:(NSString *)key;

/**
 @brief   从plist文件读取某条个人信息数据
 @param     key     读取对象的key
 @result        读取得到的对象
 */
- (id)objectForKey:(NSString *)key;

/**
 @brief 从plist文件清除某条个人信息数据
 @param key 清除对象的key
 */
- (void)removeObjectForKey:(NSString *)key;

#pragma mark ---------------- URL提取-----------------



#pragma mark ---------------- 格式校验 -----------------
@end
