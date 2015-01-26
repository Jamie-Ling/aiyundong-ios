//
//  BLTService.h
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTModel.h"

@interface BLTManager : NSObject

typedef void(^BLTManagerUpdateModel)(BLTModel *model);
typedef void(^BLTManagerUpdateValue)(NSData *data);
typedef void(^BLTManagerDisConnect)();

@property (nonatomic, strong) BLTModel *model;
@property (nonatomic, strong) NSMutableArray *allWareArray;
@property (nonatomic, strong) BLTManagerUpdateModel updateModelBlock;
@property (nonatomic, strong) BLTManagerUpdateValue updateValueBlock;
@property (nonatomic, strong) BLTManagerDisConnect disConnectBlock;

AS_SINGLETON(BLTManager)

// 开始扫描或者是重新扫描
- (void)startCan;
- (void)senderDataToPeripheral:(void *)charData withLength:(NSInteger)length;
// 主动断开链接
- (void)dismissLink;

@end
