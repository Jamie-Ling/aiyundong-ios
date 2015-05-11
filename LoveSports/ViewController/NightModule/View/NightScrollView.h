//
//  NightScrollView.h
//  LoveSports
//
//  Created by zorro on 15/3/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnlimitScroll.h"
#import "NightDetailView.h"

@interface NightScrollView : UIView

@property (nonatomic, strong) UnlimitScroll *scrollView;
@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) UIViewSimpleBlock buttonRotationBlock;

- (void)updateContentForNightDetailViews;
- (void)startChartAnimation;
- (void)updateContentToToday;
- (void)updateContentWithDate:(NSDate *)date;

//
- (void)refreshSleepViewHiddenForScrollView;

@end
