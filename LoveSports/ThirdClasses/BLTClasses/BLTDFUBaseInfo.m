//
//  BLTDFUBaseInfo.m
//  ZKKBLT_OTA
//
//  Created by zorro on 15/2/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTDFUBaseInfo.h"

@implementation BLTDFUBaseInfo

+ (NSData *)getUpdateFirmWareData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"W240N_Test_v0.10.bin" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    return data;
}

@end
