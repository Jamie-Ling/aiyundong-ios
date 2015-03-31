//
//  UserInfoModel.h
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BraceletInfoModel.h"

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSString *userName;   // 用户名
@property (nonatomic, strong) NSString *nickName;   // 昵称

@property (nonatomic, strong) NSString *password;   // 密码
@property (nonatomic, strong) NSString *birthDay;   // 生日   格式为1990-05-01
@property (nonatomic, strong) NSString *gender;     // 性别

@property (nonatomic, assign) NSInteger age;        // 年龄
@property (nonatomic, assign) CGFloat height;       // 身高
@property (nonatomic, assign) CGFloat weight;       // 体重
@property (nonatomic, assign) CGFloat step;         // 步距

@property (nonatomic, assign) NSInteger targetSteps;      // 目标步数
@property (nonatomic, assign) CGFloat targetCalories;     // 目标卡路里
@property (nonatomic, assign) CGFloat targetDistance;     // 目标距离
@property (nonatomic, assign) NSInteger targetSleep;      // 目标睡眠

@property (nonatomic, strong) BraceletInfoModel *braceletModel;

@end
