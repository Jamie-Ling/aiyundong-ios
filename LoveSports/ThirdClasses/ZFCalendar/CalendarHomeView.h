//
//  CalendarHomeViewController.h
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "CalendarView.h"

@interface CalendarHomeView : CalendarView

@property (nonatomic, strong) NSString *calendartitle;                  //  设置导航栏标题

- (void)setLoveSportsToDay:(int)day ToDateforString:(NSString *)todate;   

@end
