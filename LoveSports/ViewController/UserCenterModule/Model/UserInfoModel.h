//
//  UserInfoModel.h
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BraceletInfoModel.h"
#import "ShowTimeZone.h"

@interface UserInfoModel : NSObject

// 所有的东西在set前都必须转成公制.

//添加了2个，其它有些就暂未存储,如地区，签名等

@property (nonatomic, assign) BOOL isMetricSystem;  //是否是公制
@property (nonatomic, strong) NSString *activePlace; // 活动地方
@property (nonatomic, assign) NSInteger activeTimeZone; //活动时区 //时区小时＊2 与蓝牙保持一致.

@property (nonatomic, strong) NSString *avatar;  //头像

@property (nonatomic, strong) NSString *userName;   // 用户名
@property (nonatomic, strong) NSString *nickName;   // 昵称

@property (nonatomic, strong) NSString *password;   // 密码
@property (nonatomic, strong) NSString *birthDay;   // 生日   格式为1990-05-01
@property (nonatomic, strong) NSString *gender;     // 性别

@property (nonatomic, assign) NSInteger age;        // 年龄
@property (nonatomic, assign) CGFloat height;       // 身高
@property (nonatomic, assign) CGFloat weight;       // 体重
@property (nonatomic, assign) CGFloat step;         // 步距

@property (nonatomic, strong) NSString *interest; //兴趣
@property (nonatomic, strong) NSString *manifesto; //宣言

@property (nonatomic, assign) NSInteger targetSteps;      // 目标步数
@property (nonatomic, assign) CGFloat targetCalories;     // 目标卡路里
@property (nonatomic, assign) CGFloat targetDistance;     // 目标距离
@property (nonatomic, assign) NSInteger targetSleep;      // 目标睡眠

@property (nonatomic, strong) NSString *showTimeZone;
@property (nonatomic, strong) NSString *showHeight;
@property (nonatomic, strong) NSString *showWeight;
@property (nonatomic, strong) NSString *showStep;

@property (nonatomic, strong) BraceletInfoModel *braceletModel;

// showTimeZone 替代.
- (NSString *)activeConvertToString;
// 传入时区地更新时区
- (void)updateTimeZone:(ShowTimeZone *)timeZone;

// 从数据库获取用户信息
+ (UserInfoModel *)getUserInfoFromDB;

@end
