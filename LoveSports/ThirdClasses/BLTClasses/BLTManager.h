//
//  BLTManager.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTPeripheral.h"
#import "BLTModel.h"
#import "BLTDFUHelper.h"

typedef enum {
    BLTManagerNoConnect = 0,
    BLTManagerConnecting = 1,
    BLTManagerConnected = 2,
    BLTManagerConnectFail
} BLTManagerConnectState;

@interface BLTManager : NSObject

typedef void(^BLTManagerUpdateModel)(BLTModel *model);
typedef void(^BLTManagerDisConnect)();
typedef void(^BLTManagerConnect)();
typedef void(^BLTManagerFail)();
typedef void(^BLTManagerElecQuantity)();

@property (nonatomic, strong) BLTModel *model;
@property (nonatomic, assign) BOOL isConnectNext;
@property (nonatomic, strong) NSMutableArray *allWareArray;
@property (nonatomic, strong) BLTManagerUpdateModel updateModelBlock;
@property (nonatomic, strong) BLTManagerDisConnect disConnectBlock;
@property (nonatomic, strong) BLTManagerConnect connectBlock;
@property (nonatomic, strong) BLTManagerFail failBlock;
@property (nonatomic, strong) BLTManagerElecQuantity elecQuantityBlock;

@property (nonatomic, strong) NSArray *containNames;

@property (nonatomic, assign) BLTManagerConnectState connectState;

@property (nonatomic, assign) BOOL isUpdateing;
@property (nonatomic, strong) BLTModel *updateModel;
@property (nonatomic, assign) NSInteger elecQuantity;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *productArray;

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

// 主动断开链接
- (void)dismissLink;

// 准备更新固件
- (void)prepareUpdateFirmWare;

// 解除绑定时触发的.
- (void)dismissLinkWithModel:(BLTModel *)model;

// 主动断开设备. 要连下一个设备触发
- (void)initiativeDismissCurrentModel:(BLTModel *)model;

@end
