//
//  DayScrollView.h
//  LoveSports
//
//  Created by zorro on 15/3/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnlimitScroll.h"
#import "DayDetailView.h"

@interface DayScrollView : UIView

@property (nonatomic, strong) UnlimitScroll *scrollView;
@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) UIViewSimpleBlock buttonRotationBlock;

- (void)updateContentForDayDetailViews;
- (void)startChartAnimation;
- (void)updateContentToToday;
- (void)updateContentWithDate:(NSDate *)date;

@end
