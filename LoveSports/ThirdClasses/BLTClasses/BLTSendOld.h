//
//  BLTSendOld.h
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTSendData.h"

@interface BLTSendOld : BLTSendData

+ (void)sendOld:(NSDate *)date withUpdateBlock:(BLTAcceptDataUpdateValue)block;

@end
