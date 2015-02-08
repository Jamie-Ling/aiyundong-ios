//
//  BraceletInfoModel.h
//  LoveSports
//
//  Created by jamie on 15/1/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//  智能手环 模型

#import <Foundation/Foundation.h>
#import "BLTManager.h"

@interface HandSetAlarmClock : NSObject

@property (nonatomic, strong) NSString *_setTime;
@property (nonatomic, assign) BOOL _isOpen;
@property (nonatomic, strong) NSArray *_weekDayArray;  //重复星期数组，如【@“1“， @”2”】，代表每周一二重复

/**
 *  得到显示时间（根据是否是24小时制）
 *
 *  @param _is24HoursTime 是否是24小时置
 *
 *  @return 返回的显示时间
 */
- (NSString *) getShowTimeWithIs24HoursTime: (BOOL) _is24HoursTime;

@end

@interface BraceletInfoModel : NSObject

@property (nonatomic, strong) NSString *_name;
@property (nonatomic, strong) NSString *_target;    //1， 2， 3
@property (nonatomic, assign) BOOL _isLeftHand;     //是否带在左手
@property (nonatomic, assign) BOOL _showTime;
@property (nonatomic, assign) BOOL _showSteps;
@property (nonatomic, assign) BOOL _showKa;
@property (nonatomic, assign) BOOL _showDistance;
@property (nonatomic, assign) BOOL _isShowMetricSystem;  //是否是公制
@property (nonatomic, assign) BOOL _isAutomaticAlarmClock;    //是否自动闹钟
@property (nonatomic, assign) BOOL _isHandAlarmClock;    //是否自动闹钟
@property (nonatomic, strong) NSMutableArray *_allHandSetAlarmClock;  //手动设置的闹钟
@property (nonatomic, strong) NSMutableArray *_allAutomaticSetAlarmClock;  //自动设置的闹钟
@property (nonatomic, assign) BOOL _is24HoursTime;  //是否是24小时制

@property (nonatomic, assign) BOOL _longTimeSetRemind;  //久坐提醒
@property (nonatomic, assign) BOOL _PreventLossRemind;  //防止丢失的提醒

@property (nonatomic, assign) NSInteger _orderID;  //排列顺序ID
@property (nonatomic, strong) NSString *_deviceID;  //设备唯一ID

@property (nonatomic, strong) NSString *_deviceVersion;  //硬件版本
@property (nonatomic, assign) CGFloat _deviceElectricity;  //电量

@property (nonatomic, strong) NSString *_defaultName; //默认名字


//界面上没有的，测试使用
@property (nonatomic, assign) NSInteger _timeAbsoluteValue;  //时区绝对值
@property (nonatomic, assign) BOOL _timeZone;  //是否是正时区

@property (nonatomic, assign) NSInteger _stepNumber;  //目标步数


/**
 *  还原所有设置
 */
- (void) initAllSet;

/**
 *  初始化模型时---设置名字,id,以及遗传闹钟(手动和自动)等，同时存入DB---因为是通过计算数据库个数来设置，所以不能和Init放一起（初始化设置模型后用此方法）
 */
- (void) setNameAndSaveToDB;

/**
 *  选择某个智能手环模型为当前使用模型（初始化时不要用此方法，切换手环时用此方法）
 *
 *  @param showModel 选择的模型
 */
+ (void) choiceOneModelShow: (BraceletInfoModel *)showModel;

/**
 *  更新给另一个Model(蓝牙交互和图表显示model)
 *
 *  @param theModel 蓝牙交互和图表显示model,如果为空，就是全局的model:[BLTManager sharedInstance].model
 */
+ (void) updateToBLTModel: (BLTModel *) theModel;


#pragma mark ---------------- 蓝牙对接 多参数修改 集合-----------------
/**
 *  更新个人信息到蓝牙设备
 *
 *  @param userInfoDic 用户基本信息， 如果为nil ,自动获取最新的用户信息
 *  @param theModel    上次选中的手环模型信息，如果为nil ,自动获取最新的手环模型信息
 *  @param resultBack  返回的结果Block
 */
+ (void) updateUserInfoToBLTWithUserInfo: (NSDictionary *) userInfoDic
                         withnewestModel: (BraceletInfoModel *) theModel
                             WithSuccess: (void (^)(bool success))resultBack;

@end
