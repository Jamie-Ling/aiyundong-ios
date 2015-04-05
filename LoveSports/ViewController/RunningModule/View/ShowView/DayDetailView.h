//
//  DayDetailView.h
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PedometerModel.h"
@protocol DayDetailViewDelegate;

@interface DayDetailView : UIView

@property (nonatomic, strong) PedometerModel *model;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) UIView *fsLineView;

@property (nonatomic, assign) BOOL allowAnimation;

@property (nonatomic, assign) id <DayDetailViewDelegate> delegate;
@property (nonatomic, strong) UIViewSimpleBlock backBlock;
@property (nonatomic, strong) UIViewSimpleBlock switchDateBlock;

- (void)updateContentForView:(PedometerModel *)model;
- (void)updateContentForChartViewWithDirection:(NSInteger)direction;

@end

@protocol DayDetailViewDelegate <NSObject>

- (void)dayDetailViewSwipeUp;

@end