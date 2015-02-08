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

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PedometerModel *model;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, assign) id <DayDetailViewDelegate> delegate;

- (void)updateContentForView:(PedometerModel *)model;
- (void)updateContentForChartViewWithDirection:(NSInteger)direction;

@end

@protocol DayDetailViewDelegate <NSObject>

- (void)dayDetailViewSwipeUp;

@end