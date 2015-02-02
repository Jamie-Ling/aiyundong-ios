//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarHomeView.h"
#import "Color.h"

@interface CalendarHomeView ()
{
    int daynumber;                      //  天数
    int optiondaynumber;                //  选择日期数量
    //  NSMutableArray *optiondayarray; //  存放选择好的日期对象数组
}

@end

@implementation CalendarHomeView


#pragma mark - 设置方法
- (void)setLoveSportsToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;    //  选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];  //  刷新
    
    NSInteger item = ((NSArray *)(super.calendarMonth[super.calendarMonth.count - 1])).count - 1;
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:item
                                                  inSection:super.calendarMonth.count - 1];
    
    [super.collectionView scrollToItemAtIndexPath:indexPath1
                                 atScrollPosition:UICollectionViewScrollPositionBottom
                                         animated:NO];
}

#pragma mark - 逻辑代码初始化
//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    NSDate *date = [NSDate date]; // dateWithTimeIntervalSinceNow:-(365 * 24 * 3600)];
    NSDate *selectdate  = [NSDate date];//dateWithTimeIntervalSinceNow:-(365 * 24 * 3600)];
    
    if (todate)
    {
        selectdate = [selectdate dateFromString:todate];
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}

#pragma mark - 设置标题
- (void)setCalendartitle:(NSString *)calendartitle
{
}

@end
