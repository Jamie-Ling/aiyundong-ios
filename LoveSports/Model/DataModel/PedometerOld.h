//
//  PedometerOld.h
//  LoveSports
//
//  Created by zorro on 15/3/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define LS_PedometerOld_Date @"LS_PedometerOld_Date"
#define LS_PedometerOld_TimeIndex @"LS_PedometerOld_TimeIndex"

#import <Foundation/Foundation.h>
#import "PedometerModel.h"

@interface PedometerOld : NSObject

@property (nonatomic, strong) NSMutableArray *modelArray;

AS_SINGLETON(PedometerOld)

+ (void)saveDataToModelFromOld:(NSArray *)array withEnd:(PedometerModelSyncEnd)endBlock;

@end
