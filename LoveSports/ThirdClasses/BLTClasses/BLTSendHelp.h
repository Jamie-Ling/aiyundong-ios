//
//  BLTSendHelp.h
//  LoveSports
//
//  Created by zorro on 15/3/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 设备分发中心，新老设备的不同。
#import <Foundation/Foundation.h>

@interface BLTSendHelp : NSObject
typedef void(^BLTSendHelpSimpleBlock)(BOOL success);

@property (nonatomic, strong) BLTSendHelpSimpleBlock userInfoBlock;
@property (nonatomic, strong) BLTSendHelpSimpleBlock PedInfoBlock;

@end
