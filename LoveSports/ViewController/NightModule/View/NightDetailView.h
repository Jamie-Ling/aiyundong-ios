//
//  NightDetailView.h
//  LoveSports
//
//  Created by zorro on 15/3/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NightDetailView : UIView

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) BOOL allowAnimation;
@property (nonatomic, strong) PedometerModel *model;

@property (nonatomic, strong) UIViewSimpleBlock backBlock;
@property (nonatomic, strong) UIViewSimpleBlock switchDateBlock;

- (void)refreshSleepViewHidden;

@end
