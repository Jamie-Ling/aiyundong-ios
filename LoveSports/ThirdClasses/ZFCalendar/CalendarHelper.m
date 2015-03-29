//
//  CalendarHelper.m
//  LoveSports
//
//  Created by zorro on 15/3/3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "CalendarHelper.h"

@implementation CalendarHelper

DEF_SINGLETON(CalendarHelper)
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGRect rect = ([UIScreen mainScreen ].bounds);
        rect = CGRectMake(2, 480 * 0.20, 320 - 4.0, 320);
        _calenderView = [[CalendarHomeView alloc] initWithFrame:rect];
        
        [_calenderView setLoveSportsToDay:365 ToDateforString:nil];
    }
    
    return self;
}

- (void)setCalendarblock:(CalendarBlock)calendarblock
{
    _calenderView.calendarblock = calendarblock;
}

@end
