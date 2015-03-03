//
//  CalendarHelper.h
//  LoveSports
//
//  Created by zorro on 15/3/3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarHomeView.h"

@interface CalendarHelper : NSObject

@property (nonatomic) CalendarHomeView *calenderView;
@property (nonatomic, copy) CalendarBlock calendarblock;        //  回调

AS_SINGLETON(CalendarHelper)

@end
