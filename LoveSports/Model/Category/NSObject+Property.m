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

@end
