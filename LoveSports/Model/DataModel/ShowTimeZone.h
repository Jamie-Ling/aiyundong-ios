//
//  ShowTimeZone.h
//  LoveSports
//
//  Created by zorro on 15/4/11.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowTimeZone : NSObject

@property (nonatomic, strong) NSString *place;  // 地方
@property (nonatomic, strong) NSString *showPlace; //显示
@property (nonatomic, assign) NSInteger timeZone; // 时差
@property (nonatomic, strong) NSString *showString;

+ (ShowTimeZone *)simpleWithString:(NSString *)string;

@end
