//
//  NSString+Extension.h
//  CBExtension
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (BOOL)addSkipBackupAttributeToItem;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/*** 返回符合 pattern 的所有 items */
- (NSMutableArray *)itemsForPattern:(NSString *)pattern;

/*** 返回符合 pattern 的 捕获分组为 index 的所有 items */
- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;

/*** 返回符合 pattern 的第一个 item */
- (NSString *)itemForPatter:(NSString *)pattern;

/*** 返回符合 pattern 的 捕获分组为 index 的第一个 item */
- (NSString *)itemForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;

/*** 按 format 格式化字符串生成 NSDate 类型的对象，返回 timeString HSL_时间与 1970年1月1日的HSL_时间间隔
 * @discussion 格式化后的 NSDate 类型对象为 +0000 时区HSL_时间
 */
- (NSTimeInterval)timeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format;

/*** 按 format 格式化字符串生成 NSDate 类型的对象，返回当前HSL_时间距给定 timeString 之间的HSL_时间间隔
 * @discussion 格式化后的 NSDate 类型对象为本地HSL_时间
 */
- (NSTimeInterval)localTimeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format;

- (BOOL)contains:(NSString *)piece;

// 删除字符串开头与结尾的空白符与换行
- (NSString *)trim;



/**
 *  判断字符串是否为Nil或者空
 *
 *  @param str 需要校验的字符串
 *
 *  @return  YES:为nil或者空，NO:有内容
 */
+ (BOOL )isNilOrEmpty: (NSString *) str;

/**
 *  轻量级的存储关系
 *
 *  @return
 */
- (id)getObjectValue;
- (NSInteger)getIntValue;
- (BOOL)getBOOLValue;
- (void)setObjectValue:(id)value;
- (void)setIntValue:(NSInteger)value;
- (void)setBOOLValue:(BOOL)value;


@end
