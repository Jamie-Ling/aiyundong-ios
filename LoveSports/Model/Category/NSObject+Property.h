//
//  NSObject+Property.h
//  MultiMedia
//
//  Created by zorro on 14-12-16.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^NSObjectSimpleBlock)(id object);

@interface NSObject (Property)

@property (nonatomic, readonly) NSArray *attributeList;

+ (BOOL)queryCurrentTimeSystem;

+ (NSString *)numberTransferWeek:(NSInteger)number;

// 步数转卡路里， metric 为no时传入的(weight)重量为磅，长度(distance)英里和(pace)英尺
// 为yes的时候重量单位为公斤， 长度为公里和厘米。
// pace为
- (CGFloat)stepsConvertCalories:(NSInteger)steps
                       withWeight:(CGFloat)weight
                        withModel:(BOOL)metric;

// 卡路里转步数
- (NSInteger)caloriesConvertSteps:(NSInteger)Calories
                       withWeight:(CGFloat)weight
                        withModel:(BOOL)metric;

// 步数转距离
- (CGFloat)StepsConvertDistance:(NSInteger)steps
                       withPace:(NSInteger)pace;

// 距离转步数
- (NSInteger)distanceConvertSteps:(CGFloat)distance
                         withPace:(NSInteger)pace;

// 卡路里转距离
- (NSInteger)caloriesConvertDistance:(NSInteger)calories
                          withWeight:(CGFloat)weight
                            withPace:(NSInteger)pace
                           withModel:(BOOL)metric;

// 距离转卡路里
- (NSInteger)distanceConvertCalories:(CGFloat)distance
                          withWeight:(CGFloat)weight
                            withPace:(NSInteger)pace
                           withModel:(BOOL)metric;

@end

@interface NSMutableArray (Order)

@end
