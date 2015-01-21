//
//  ObjectCTools.m
//  MissionSky-iOS
//
//  Created by jamie on 14-11-16.
//  Copyright (c) 2014年 Jamie.ling. All rights reserved.
//


#import "ObjectCTools.h"
#import "AppDelegate.h"



static ObjectCTools *_tools = nil;

@implementation ObjectCTools


/**
 @brief 获取工具集的单例
 */
+(ObjectCTools *)shared
{
    @synchronized(self)
    {
        if (_tools == nil) {
            _tools = [[ObjectCTools alloc] init];
            
        }
        return _tools;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark ---------------- 主代理获取 -----------------
/**
 @brief 获取主代理对象
 */
- (AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

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
- (UIBarButtonItem *)createRightBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector ImageName:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setTitle:title forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    //iOS7之前的版本需要手动设置和屏幕边缘的间距
    if (kIOSVersions < 7.0) {
        leftButton.frame = CGRectInset(leftButton.frame, -10, 0);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return item;
}

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
- (UIBarButtonItem *)createLeftBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector ImageName:(NSString*)imageName
{
    UIImage *image;
    if ([imageName isEqualToString:@""])
    {
        image = [UIImage imageScaleNamed:vBackBarButtonItemName];
    }
    else
    {
        image = [UIImage imageScaleNamed:imageName];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    
    if ([title isEqualToString:@"返回"]) {
        title = @"    ";
    }
    if ([title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
    }else{
        
    }
    //ios8.0 此方法过时，用下面的方法替代---
    //    CGSize titleSize = [title sizeWithAttributes:[UIFont systemFontOfSize:18]];
    
    UIFont *fnt = [UIFont systemFontOfSize:18];
    // 根据字体得到NSString的尺寸
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    //----------
    
    if (titleSize.width < 44) {
        titleSize.width = 44;
    }
    button.frame = CGRectMake(0, 0, titleSize.width, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:130.0/255 green:56.0/255 blue:23.0/255 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    //    CGPoint tempCenter = button.center;
    //    //图片尺寸不对时，用默认参数进行缩放
    //    [button setFrame:CGRectMake(0, 0, image.size.width / kAllImageZoomSize, image.size.height / kAllImageZoomSize)];
    //    [button setCenter:tempCenter];
    
    //iOS7之前的版本需要手动设置和屏幕边缘的间距
    if (kIOSVersions < 7.0) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

#pragma mark ---------------- 缓存数据plist读、写、清除(个人信息数据)-----------------
/**
 *  写入一条数据到plist文件(个人信息数据)
 *
 *  @param object 写入的对象
 *  @param key    写入对象的key
 *
 *  @return YES:写入成功，NO:写入失败
 */
- (BOOL)setobject:(id )object forKey:(NSString *)key
{
    BOOL success = NO;
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSLog(@"****path = %@", pPath);
    NSMutableDictionary *plistDictionary = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithContentsOfFile:pPath];
    if (!plistDictionary)
    {
        plistDictionary = [NSMutableDictionary dictionary];
    }
    [plistDictionary setValue:object forKey:key];
    if (key && object)
    {
        if ([plistDictionary writeToFile:pPath atomically:YES])
        {
            success = YES;
        }
    }
    return success;
}

/**
 @brief 从plist文件读取某条个人信息数据
 @param key 读取对象的key
 @result id 读取得到的对象
 */
- (id)objectForKey:(NSString *)key
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSLog(@"****path = %@", pPath);
    NSDictionary *arrayData = [NSDictionary dictionaryWithContentsOfFile:pPath];
    NSArray *keys = [arrayData allKeys];
    for (NSString *tempKey in keys)
    {
        if ([tempKey isEqualToString:key])
        {
            return [arrayData objectForKey:key];
        }
    }
    return nil;
}

/**
 @brief 从plist文件清除某条个人信息数据
 @param key 清除对象的key
 */
- (void)removeObjectForKey:(NSString *)key
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSMutableDictionary *arrayData = [NSMutableDictionary dictionaryWithContentsOfFile:pPath];
    NSArray *keys = [arrayData allKeys];
    for (NSString *tempKey in keys)
    {
        if ([tempKey isEqualToString:key])
        {
            [arrayData removeObjectForKey:key];
        }
    }
    [arrayData writeToFile:pPath atomically:YES];
}

#pragma mark ---------------- URL提取-----------------

#pragma mark ---------------- 格式校验 -----------------

@end
