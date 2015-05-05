//
//  DataShare.h
//  LoveSports
//
//  Created by zorro on 15/3/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StepDataRecord.h"

#define DS_HeadImage @"headImage.jpg"

@interface DataShare : NSObject

@property (nonatomic, assign) NSInteger showCount;
@property (nonatomic, assign) BOOL isPad;
@property (nonatomic, assign) BOOL isIp4s;
@property (nonatomic, assign) BOOL isIp5;
@property (nonatomic, assign) BOOL isIp6;
@property (nonatomic, assign) BOOL isIp6P;

@property (nonatomic, strong) StepDataRecord *stepRecord;

// 可能需要统一整个界面的日期。后面需要再改。
@property (nonatomic, strong) NSDate *currentDate;

AS_SINGLETON(DataShare)

- (void)checkDeviceModel;

+ (BOOL)isPad;
+ (BOOL)isIpFour;
+ (BOOL)isIpFive;
+ (BOOL)isIpSix;
+ (BOOL)isIpSixP;

- (UIImage *)getHeadImage;

@end
