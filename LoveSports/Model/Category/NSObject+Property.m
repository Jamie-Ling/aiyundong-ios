//
//  NSObject+Property.m
//  MultiMedia
//
//  Created by zorro on 14-12-16.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

@dynamic attributeList;

- (NSArray *)attributeList
{
    NSUInteger propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], (unsigned int *)&propertyCount);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < propertyCount; i++)
    {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        // const char *attr = property_getAttributes(properties[i]);
        // NSLogD(@"%@, %s", propertyName, attr);
        [array addObject:propertyName];
    }
    
    free( properties );
    return array;
}

+ (NSString *)numberTransferWeek:(NSInteger)number
{
    NSDictionary *dict = @{@(2) : @"星期一",
                           @(3) : @"星期二",
                           @(4) : @"星期三",
                           @(5) : @"星期四",
                           @(6) : @"星期五",
                           @(7) : @"星期六",
                           @(1) : @"星期日"};
    
    return [dict objectForKey:@(number)];
}

- (CGFloat)stepsConvertCalories:(NSInteger)steps
                       withWeight:(CGFloat)weight
                        withModel:(BOOL)metric
{
    if (metric)
    {
        return steps * ((weight - 13.63636) * 0.000693 + 0.00495);
    }
    else
    {
        return steps / 100 * (0.0315 * weight - 0.45);
    }
}

- (NSInteger)caloriesConvertSteps:(NSInteger)Calories
                       withWeight:(CGFloat)weight
                        withModel:(BOOL)metric
{
    // 四舍五入...
    if (metric)
    {
        return Calories / ((weight - 13.63636) * 0.000693 + 0.00495) + 0.5;
    }
    else
    {
        return Calories * 100 / (0.0315 * weight - 0.45) + 0.5;
    }
}

- (CGFloat)StepsConvertDistance:(NSInteger)steps
                       withPace:(NSInteger)pace
{
    return steps * pace / 1000.0;
}

- (NSInteger)distanceConvertSteps:(CGFloat)distance
                       withPace:(NSInteger)pace
{
    return distance / pace * 1000.0 + 0.5;
}

- (NSInteger)caloriesConvertDistance:(NSInteger)calories
                       withWeight:(CGFloat)weight
                         withPace:(NSInteger)pace
                        withModel:(BOOL)metric
{
    NSInteger steps = [self caloriesConvertSteps:calories withWeight:weight withModel:metric];
    
    return [self StepsConvertDistance:steps withPace:pace];
}

- (NSInteger)distanceConvertCalories:(CGFloat)distance
                          withWeight:(CGFloat)weight
                            withPace:(NSInteger)pace
                           withModel:(BOOL)metric
{
    NSInteger steps = [self distanceConvertSteps:distance withPace:pace];
    
    return [self stepsConvertCalories:steps withWeight:weight withModel:metric];
}

@end
