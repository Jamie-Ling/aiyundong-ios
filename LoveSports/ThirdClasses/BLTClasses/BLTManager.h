//
//  BLTService.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTPeripheral.h"
#import "BLTModel.h"

@interface BLTManager : NSObject

typedef void(^BLTManagerUpdateModel)(BLTModel *model);
typedef void(^BLTManagerDisConnect)();
typedef void(^BLTManagerConnect)();

@property (nonatomic, strong) BLTModel *model;
@property (nonatomic, strong) NSMutableArray *allWareArray;
@property (nonatomic, strong) BLTManagerUpdateModel updateModelBlock;
@property (nonatomic, strong) BLTManagerDisConnect disConnectBlock;
@property (nonatomic, strong) BLTManagerConnect connectBlock;

AS_SINGLETON(BLTManager)

// 开始扫描或者是重新扫描
- (void)startCan;

// 在不取消当前设备的情况下扫描其他的设备。
- (void)checkOtherDevices;

/**
 *  连接指定的设备
 *
 *  @param model 设备模型 BLTModel
 */
- (void)repareConnectedDevice:(BLTModel *)model;

/**
 *  发送数据给固件
 *
 *  @param data 二进制数据
 */
- (void)senderDataToPeripheral:(NSData *)data;

// 主动断开链接
- (void)dismissLink;

@end
