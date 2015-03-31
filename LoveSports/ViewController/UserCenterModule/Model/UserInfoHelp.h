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

@interface UserInfoHelp : NSObject


// 把这2个更新。 我就可以直接发送鸟.
// 当前用户信息
@property (nonatomic, strong) UserInfoModel *userModel;
// 当前手环信息
@property (nonatomic, strong) BraceletInfoModel *braceModel;

// 哪个被修改了就设置为yes
// 手环设置
@property (nonatomic, assign) BOOL target;          // 目标
@property (nonatomic, assign) BOOL step;            // 步距
@property (nonatomic, assign) BOOL sedentariness;   // 久坐
@property (nonatomic, assign) BOOL adorn;           // 佩戴方式
@property (nonatomic, assign) BOOL alarm;           // 闹钟

// 用户信息
@property (nonatomic, assign) BOOL userInfo;

AS_SINGLETON(UserInfoHelp)

// 设置用户信息. backBlock 外部使用直接用nil。
- (void)sendSetUserInfo:(NSObjectSimpleBlock)backBlock;
- (void)sendSetAdornType:(NSObjectSimpleBlock)backBlock;
- (void)sendSetSedentariness:(NSObjectSimpleBlock)backBlock;

//  闹钟数组为实际闹钟个数。一次性的。
- (void)sendSetAlarmClock:(NSObjectSimpleBlock)backBlock;

@end
