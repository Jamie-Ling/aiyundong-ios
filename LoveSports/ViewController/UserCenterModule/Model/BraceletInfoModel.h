//
//  BraceletInfoModel.h
//  LoveSports
//
//  Created by jamie on 15/1/26.
//  Copyright (c) 2015年 zorro. All rights reserved.
//  智能手环 模型

#import <Foundation/Foundation.h>

@interface HandSetAlarmClock : NSObject

@property (nonatomic, strong) NSString *_setTime;
@property (nonatomic, assign) BOOL _isOpen;

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


/**
 *  还原所有设置
 */
- (void) initAllSet;

/**
 *  设置名字,id,以及遗传闹钟(手动和自动)---因为是通过计算数据库个数来设置，所以不能和Init放一起
 */
- (void) setDefaultNameAndOrderID;


@end
