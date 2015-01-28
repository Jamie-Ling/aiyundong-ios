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
@property (nonatomic, strong) NSMutableArray *_allHandSetAlarmClock;  //手动设置的闹钟
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
 *  //取仓库已有的智能手环，计算个数,设置名字及id
 */
- (void) setDefaultNameAndOrderID;


@end
