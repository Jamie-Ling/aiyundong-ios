//
//  UserInfoHelp.h
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "BraceletInfoModel.h"
#import "BLTModel.h"

@interface UserInfoHelp : NSObject


// 把这2个更新。 我就可以直接发送鸟.

// 当前用户信息
@property (nonatomic, strong) UserInfoModel *userModel;

// 当前手环信息
@property (nonatomic, strong) BLTModel *braceModel;

/**
 *  更新用户信息（实时获取最新的用户信息给到--》这个类的userModel）
 *
 *  @param userIngModel 正在用的Model(因为不会实时存到数据库），如果没有，可以传入nil
 *
 *  @return 最新的用户信息
 */
- (UserInfoModel *) updateUserInfo: (BraceletInfoModel *) userIngModel;

AS_SINGLETON(UserInfoHelp)

// 设置用户信息. backBlock 外部使用直接用nil。
- (void)sendSetUserInfo:(NSObjectSimpleBlock)backBlock;
- (void)sendSetAdornType:(NSObjectSimpleBlock)backBlock;
- (void)sendSetSedentariness:(NSObjectSimpleBlock)backBlock;

//  闹钟数组为实际闹钟个数。一次性的。
- (void)sendSetAlarmClock:(NSObjectSimpleBlock)backBlock;

@end
