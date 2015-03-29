//
//  UserInfoHelp.h
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface UserInfoHelp : NSObject

@property (nonatomic, strong) UserInfoModel *userModel;

// 哪个被修改了久设置为yes， 退出当前vc的时候调我的方法.
// 参考文件BLTSendHelp.h
// 手环设置
@property (nonatomic, assign) BOOL target;          // 目标
@property (nonatomic, assign) BOOL step;            // 步距
@property (nonatomic, assign) BOOL sedentariness;   // 久坐
@property (nonatomic, assign) BOOL adorn;           // 佩戴方式
@property (nonatomic, assign) BOOL alarm;           // 闹钟

// 用户信息
@property (nonatomic, assign) BOOL userInfo;

AS_SINGLETON(UserInfoHelp)

@end
