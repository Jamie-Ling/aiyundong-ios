//
//  StepDataRecord.h
//  LoveSports
//
//  Created by zorro on 15/5/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepDataRecord : NSObject

@property (nonatomic, strong) NSString *wareUUID;           // 设备uuid
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSArray *dateArray;

+ (StepDataRecord *)getStepDataRecordFromDB;
// 把有数据的日子保存到数据库。
+ (void)addDateToStepDataRecord:(NSString *)dateString;
// 检查这个日期是否有数据.
+ (BOOL)isHaveDate:(NSString *)dateString;

@end
