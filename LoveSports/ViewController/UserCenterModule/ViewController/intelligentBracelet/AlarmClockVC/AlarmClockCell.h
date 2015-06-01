//
//  AlarmClockCell.h
//  LoveSports
//
//  Created by zorro on 15/4/4.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmClockModel.h"

@interface AlarmClockCell : UITableViewCell

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UISwitch *cellSwitch;

@property (nonatomic, strong) AlarmClockModel *model;

- (void)updateContentForCellFromAlarmModel:(AlarmClockModel *)model WithHeight:(CGFloat)height withIndex:(NSInteger)index;

@end
