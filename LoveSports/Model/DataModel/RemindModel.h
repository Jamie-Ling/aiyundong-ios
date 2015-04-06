//
//  RemindModel.h
//  LoveSports
//
//  Created by zorro on 15/4/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *wareInfo;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSString *interval;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) NSInteger orderIndex;

+ (NSArray *)getRemindFromDB;

@end
