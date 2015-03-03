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
        rect = CGRectMake(2, rect.size.height * 0.10, rect.size.width - 4.0, rect.size.height * 0.8);
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
