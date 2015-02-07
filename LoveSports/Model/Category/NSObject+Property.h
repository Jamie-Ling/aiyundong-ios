//
//  NSObject+Property.h
//  MultiMedia
//
//  Created by zorro on 14-12-16.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

@property (nonatomic, readonly) NSArray *attributeList;

+ (NSString *)numberTransferWeek:(NSInteger)number;

@end
