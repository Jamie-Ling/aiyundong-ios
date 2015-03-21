//
//  YearModel.m
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "YearModel.h"


@implementation YearModel
@synthesize _thisYearAllWeeks, _yearID, _thisYearAllMonths;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _thisYearAllWeeks = [[NSMutableDictionary alloc] initWithCapacity:32];
        _thisYearAllMonths = [[NSMutableDictionary alloc] initWithCapacity:32];
    }
    return self;
}

#pragma mark ---------------- 周 - 月  相关 -----------------
/**
 *  初始化或更新 周&月模型 通过传入PedModel
 *
 *  @param onePedoMeterModel 传入的PedMode
 *
 */
+ (void) initOrUpdateTheWeekAndMonthModelFromAPedometerModel: (PedometerModel *) onePedoMeterModel
{
 
    NSDate *oneDate = [NSDate dateWithString:onePedoMeterModel.dateString];
    //取得这一年的模型，没有就创建，有就更新数据
    NSInteger thisYearNumber = oneDate.year;
    /*
    NSString *where = [NSString stringWithFormat:@"_yearID = '%@'", [NSString stringWithFormat:@"%ld", (long)thisYearNumber]];
    YearModel *thisYearModel = [[YearModel getUsingLKDBHelper] searchSingle:[YearModel class] where:where orderBy:nil];
    if (!thisYearModel)
    {
        thisYearModel = [[YearModel alloc] init];
        thisYearModel._yearID = [NSString stringWithFormat:@"%ld", (long)thisYearNumber];
        
        [thisYearModel saveToDB];
    }
     */
    
    //周=-----------------------------------------------
    //取到这一周的模型，没有就创建，更新至年模型中
    
    NSInteger thisWeekNumber = oneDate.weekOfYear;
    NSString *where = [NSString stringWithFormat:@"_yearNumber = %ld AND _weekNumber = %ld", (long)thisYearNumber, (long)thisWeekNumber];
    WeekModel *thisWeekModel = [WeekModel searchSingleWithWhere:where orderBy:nil];
    if (!thisWeekModel)
    {
        thisWeekModel = [[WeekModel alloc] initWithWeekNumber:thisWeekNumber andYearNumber:thisYearNumber];
        thisWeekModel.userName = onePedoMeterModel.userName;
        thisWeekModel.wareUUID = onePedoMeterModel.wareUUID;
        [thisWeekModel saveToDB];
    }
    
    [thisWeekModel updateTotalWithModel:onePedoMeterModel];
    
    /*
    //从这一周的模型中取这一天的数据，没有就创建，有就更新
    SubOfPedometerModel *thisSubOfPedometerModel = [thisWeekModel._allSubPedModelArray objectForKey:onePedoMeterModel.dateString];
    
    if (!thisSubOfPedometerModel)
    {
        thisSubOfPedometerModel = [[SubOfPedometerModel alloc] init];
    }
    
    //更新此subPed
    [thisSubOfPedometerModel updateInfoFromAPedometerModel:onePedoMeterModel];
    
    //存入/更新进周模型中
    [thisWeekModel._allSubPedModelArray setObject:thisSubOfPedometerModel forKey:onePedoMeterModel.dateString];
    thisWeekModel._weekNumber = thisWeekNumber;
    thisWeekModel._yearNumber = thisYearNumber;
    
    //更新周模型的相关数据 根据pedometermodel的内容更新此weekmodel汇总信息
    [thisWeekModel updateInfo];
    
    //存入/更新进年模型中
    [thisYearModel._thisYearAllWeeks setObject:thisWeekModel forKey:[NSString stringWithFormat:@"%ld", (long)thisWeekNumber]];
     */
    
    //月=-----------------------------------------------
    //取到这一月的模型，没有就创建，更新至年模型中
    NSInteger thisMonthNumber = oneDate.month;
    where = [NSString stringWithFormat:@"_yearNumber = %ld AND _monthNumber = %ld", (long)thisYearNumber, (long)thisMonthNumber];
    MonthModel *thisMonthModel = [MonthModel searchSingleWithWhere:where orderBy:nil];
    if (!thisMonthModel)
    {
        thisMonthModel = [[MonthModel alloc] initWithmonthNumber:thisMonthNumber andYearNumber:thisYearNumber];
        thisMonthModel.userName = onePedoMeterModel.userName;
        thisMonthModel.wareUUID = onePedoMeterModel.wareUUID;
        [thisMonthModel saveToDB];
    }
    
    [thisMonthModel updateTotalWithModel:onePedoMeterModel];
    
    /*
    //从这一月的模型中取这一天的数据，没有就创建，有就更新
    SubOfPedometerModel *thisSubOfPedometerModelForMonth = [thisMonthModel._allSubPedModelArray objectForKey:onePedoMeterModel.dateString];
    
    if (!thisSubOfPedometerModelForMonth)
    {
        thisSubOfPedometerModelForMonth = [[SubOfPedometerModel alloc] init];
    }
    
    //更新此subPed
    [thisSubOfPedometerModelForMonth updateInfoFromAPedometerModel:onePedoMeterModel];
    
    //存入/更新进月模型中
    [thisMonthModel._allSubPedModelArray setObject:thisSubOfPedometerModelForMonth forKey:onePedoMeterModel.dateString];
    thisMonthModel._monthNumber = thisMonthNumber;
    thisMonthModel._yearNumber = thisYearNumber;
    
    //更新月模型的相关数据 根据pedometermodel的内容更新此weekmodel汇总信息
    [thisMonthModel updateInfo];
    
    //存入/更新进年模型中
    [thisYearModel._thisYearAllMonths setObject:thisMonthModel forKey:[NSString stringWithFormat:@"%ld", (long)thisMonthModel]];

    //存入/更新数据库
    // [[YearModel getUsingLKDBHelper] insertToDB:thisYearModel];
    [YearModel updateToDB:thisYearModel where:where];
     */
}

#pragma mark ---------------- 周相关 -----------------
/**
 *  得到一个周模型。通过指定的PedModel
 *
 *  @param onePedoMeterModel 传入的PedMode
 *
 *  @return 返回更新后的周模型
 */
+ (WeekModel *) initOrUpdateTheWeekModelFromAPedometerModel: (PedometerModel *) onePedoMeterModel
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *thisDate = [dateFormatter dateFromString:onePedoMeterModel.dateString];
    if (!thisDate)
    {
        [UIView showAlertView:@"日期字符串格式不匹配" andMessage:nil];
    }
    
    return [YearModel initOrUpdateTheWeekModelFromADate:thisDate andPedometerModel:onePedoMeterModel];
}

/**
 *  得到一个周模型。通过指定的日期和PedModel
 *
 *  @param oneDate 指定的日期
 *  @param onePedoMeterModel  传入的PedModel
 *
 *
 *  @return  返回更新后的周模型
 */
+ (WeekModel *) initOrUpdateTheWeekModelFromADate: (NSDate *) oneDate
                       andPedometerModel: (PedometerModel *) onePedoMeterModel
{
    //取得这一年的模型，没有就创建，有就更新数据
    NSInteger thisYearNumber = oneDate.year;
    NSString *where = [NSString stringWithFormat:@"_yearID = '%@'", [NSString stringWithFormat:@"%ld", (long)thisYearNumber]];
    YearModel *thisYearModel = [[YearModel getUsingLKDBHelper] searchSingle:[YearModel class] where:where orderBy:nil];
    
    if (!thisYearNumber)
    {
        thisYearModel = [[YearModel alloc] init];
        thisYearModel._yearID = [NSString stringWithFormat:@"%ld", (long)thisYearNumber];
    }
    
    //取到这一周的模型，没有就创建，更新至年模型中
    
    NSInteger thisWeekNumber = oneDate.weekOfYear;
    WeekModel *thisWeekModel = [thisYearModel._thisYearAllWeeks objectForKey:[NSString stringWithFormat:@"%ld", (long)thisWeekNumber]];
    
    if (!thisWeekModel)
    {
        thisWeekModel = [[WeekModel alloc]initWithWeekNumber:thisWeekNumber andYearNumber:thisYearNumber] ;
    }
    
    //从这一周的模型中取这一天的数据，没有就创建，有就更新
    SubOfPedometerModel *thisSubOfPedometerModel = [thisWeekModel._allSubPedModelArray objectForKey:onePedoMeterModel.dateString];
    
    if (!thisSubOfPedometerModel)
    {
        thisSubOfPedometerModel = [[SubOfPedometerModel alloc] init];
    }
    
    //更新此subPed
    [thisSubOfPedometerModel updateInfoFromAPedometerModel:onePedoMeterModel];
    
    //存入/更新进周模型中
    [thisWeekModel._allSubPedModelArray setObject:thisSubOfPedometerModel forKey:onePedoMeterModel.dateString];
    thisWeekModel._weekNumber = thisWeekNumber;
    thisWeekModel._yearNumber = thisYearNumber;
    
    //更新周模型的相关数据 根据pedometermodel的内容更新此weekmodel汇总信息
    [thisWeekModel updateInfo];
    
    //存入/更新进年模型中
    [thisYearModel._thisYearAllWeeks setObject:thisWeekModel forKey:[NSString stringWithFormat:@"%ld", (long)thisWeekNumber]];
    
    //存入/更新数据库
    [[YearModel getUsingLKDBHelper] insertToDB:thisYearModel];
    
    //在返回这个更新了的周模型
    return thisWeekModel;
}

/**
 *  返回一个指定的日期是今年的第几周
 *
 *  @param oneDate 指定的日期
 *
 *  @return 今年的第几周数
 */
+ (NSInteger) weekOfYearFromADate: (NSDate *) oneDate
{
    return oneDate.weekOfYear;
}

/**
 *   返回指定日期一年内所有的周模型
 *
 *  @param oneDate 指定日期
 *
 *  @return 这一年内所有周模型的字典
 */
+ (NSDictionary *) getThisYearAllWeekModelWithDate:(NSDate *) oneDate
{
    //取得这一年的模型，没有就返回
    NSInteger thisYearNumber = oneDate.year;
    NSString *where = [NSString stringWithFormat:@"_yearID = '%@'", [NSString stringWithFormat:@"%ld", (long)thisYearNumber]];
    YearModel *thisYearModel = [[YearModel getUsingLKDBHelper] searchSingle:[YearModel class] where:where orderBy:nil];
    
    if (!thisYearNumber)
    {
        NSLog(@"压根还没有此年份的数据,如需创建，请用本类的init类方法");
        return nil;
    }
    
    if (thisYearModel._thisYearAllWeeks.count == 0)
    {
        NSLog(@"此年份的周数据还为空,如需创建，请用本类的init类方法");
        return nil;
    }
    return thisYearModel._thisYearAllWeeks;
}

/**
 *  返回指定日期的周模型
 *
 *  @param oneDate 指定的日期
 *
 *  @return 取出来的周模型
 */
+ (WeekModel *) getTheWeekModelWithDate:(NSDate *) oneDate
{
    //取得这一年的模型，没有就返回
    NSDictionary *tempDictionary = [YearModel getThisYearAllWeekModelWithDate: oneDate];
    
    if (!tempDictionary)
    {
        return nil;
    }
    
    //取到这一周的模型，没有就返回
    NSInteger thisWeekNumber = oneDate.weekOfYear;
    WeekModel *thisWeekModel = [tempDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)thisWeekNumber]];
    
    if (!thisWeekModel)
    {
        NSLog(@"压根还没有此周的数据,如需创建，请用本类的init类方法");
        return nil;
    }
    return thisWeekModel;
}

+ (WeekModel *)getTheWeekModelWithDate:(NSDate *)date
                        withReturnModel:(BOOL)noEmpty
{
    NSInteger year = date.year;
    NSInteger order = date.weekOfYear;
    NSString *where = [NSString stringWithFormat:@"_yearNumber = %ld AND _weekNumber = %ld", (long)year, (long)order];
    WeekModel *model = [WeekModel searchSingleWithWhere:where orderBy:nil];
    
    if (model)
    {
        if (!model.showDate)
        {
            model.showDate = [NSString stringWithFormat:@"%ld/%ld周", (long)year, (long)order];
        }
        
        return model;
    }
    else
    {
        if (noEmpty)
        {
            model = [[WeekModel alloc] initWithWeekNumber:order andYearNumber:year];
            
            return model;
        }
        
        return nil;
    }
}

+ (NSArray *)getWeekModelArrayWithDate:(NSDate *)date
                       withReturnModel:(BOOL)noEmpty
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [DataShare sharedInstance].showCount; i++)
    {
        NSDate *tmpDate = [date dateAfterDay:i * 7];
        WeekModel *model = [YearModel getTheWeekModelWithDate:tmpDate withReturnModel:noEmpty];
        
        [array addObject:model];
    }

    return array;
}

+ (NSInteger)getYearWithMonthIndex:(NSInteger)index
{
    NSInteger currentYear = LS_Baseyear;
    if (index > 0)
    {
        currentYear = currentYear + (index - 1) / 12;
    }
    else
    {
        currentYear = currentYear + index / 12 - 1;
    }
    
    return currentYear;
}

+ (MonthModel *)getTheWeekModelWithIndex:(NSInteger)index
                         withReturnModel:(BOOL)noEmpty
{
    
    NSInteger currentYear = [self getYearWithMonthIndex:index];
    NSInteger month = index - (currentYear - LS_Baseyear) * 12;
    NSString *where = [NSString stringWithFormat:@"_yearNumber = %ld AND _monthNumber = %ld", (long)currentYear, (long)month];
    MonthModel *model = [WeekModel searchSingleWithWhere:where orderBy:nil];
    
    if (model)
    {
        if (!model.showDate)
        {
            model.showDate = [NSString stringWithFormat:@"%ld/%ld月", (long)currentYear, (long)month];
        }
        
        return model;
    }
    else
    {
        if (noEmpty)
        {
            model = [[MonthModel alloc] initWithmonthNumber:month andYearNumber:currentYear];
            
            return model;
        }
        
        return nil;
    }
    
    return nil;
}

+ (NSArray *)getMonthModelArrayWithIndex:(NSInteger)index
                       withReturnModel:(BOOL)noEmpty
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [DataShare sharedInstance].showCount; i++)
    {
        NSInteger tmpIndex = i + index;
        MonthModel *model = [YearModel getTheWeekModelWithIndex:tmpIndex withReturnModel:noEmpty];
        
        [array addObject:model];
    }
    
    return array;
}

#pragma mark ---------------- 月相关 -----------------

/**
 *  得到一个月模型。通过指定的PedModel
 *
 *  @param onePedoMeterModel 传入的PedMode
 *
 *  @return 返回更新后的月模型
 */
+ (MonthModel *) initOrUpdateThemonthModelFromAPedometerModel: (PedometerModel *) onePedoMeterModel
{    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *thisDate = [dateFormatter dateFromString:onePedoMeterModel.dateString];
    if (!thisDate)
    {
        [UIView showAlertView:@"日期字符串格式不匹配" andMessage:nil];
    }
    
    return [YearModel initOrUpdateThemonthModelFromADate:thisDate andPedometerModel:onePedoMeterModel];
}


/**
 *  得到一个月模型。通过指定的日期和PedModel
 *
 *  @param oneDate 指定的日期
 *  @param onePedoMeterModel  传入的PedModel
 *
 *
 *  @return  返回更新后的月模型
 */
+ (MonthModel *) initOrUpdateThemonthModelFromADate: (NSDate *) oneDate
                       andPedometerModel: (PedometerModel *) onePedoMeterModel
{
    //取得这一年的模型，没有就创建，有就更新数据
    NSInteger thisYearNumber = oneDate.year;
    NSString *where = [NSString stringWithFormat:@"_yearID = '%@'", [NSString stringWithFormat:@"%ld", (long)thisYearNumber]];
    YearModel *thisYearModel = [[YearModel getUsingLKDBHelper] searchSingle:[YearModel class] where:where orderBy:nil];
    
    if (!thisYearNumber)
    {
        thisYearModel = [[YearModel alloc] init];
        thisYearModel._yearID = [NSString stringWithFormat:@"%ld", (long)thisYearNumber];
    }
    
    //取到这一月的模型，没有就创建，更新至年模型中
    
    NSInteger thisMonthNumber = oneDate.month;
    MonthModel *thisMonthModel = [thisYearModel._thisYearAllMonths objectForKey:[NSString stringWithFormat:@"%ld", (long)thisMonthNumber]];
    
    if (!thisMonthModel)
    {
        thisMonthModel = [[MonthModel alloc]initWithmonthNumber:thisMonthNumber andYearNumber:thisYearNumber] ;
    }
    
    //从这一月的模型中取这一天的数据，没有就创建，有就更新
    SubOfPedometerModel *thisSubOfPedometerModel = [thisMonthModel._allSubPedModelArray objectForKey:onePedoMeterModel.dateString];
    
    if (!thisSubOfPedometerModel)
    {
        thisSubOfPedometerModel = [[SubOfPedometerModel alloc] init];
    }
    
    //更新此subPed
    [thisSubOfPedometerModel updateInfoFromAPedometerModel:onePedoMeterModel];
    
    //存入/更新进月模型中
    [thisMonthModel._allSubPedModelArray setObject:thisSubOfPedometerModel forKey:onePedoMeterModel.dateString];
    thisMonthModel._monthNumber = thisMonthNumber;
    thisMonthModel._yearNumber = thisYearNumber;

    
    //更新月模型的相关数据 根据pedometermodel的内容更新此weekmodel汇总信息
    [thisMonthModel updateInfo];
    
    //存入/更新进年模型中
    [thisYearModel._thisYearAllMonths setObject:thisMonthModel forKey:[NSString stringWithFormat:@"%ld", (long)thisMonthModel]];
    
    //存入/更新数据库
    [[YearModel getUsingLKDBHelper] insertToDB:thisYearModel];
    
    
    //在返回这个更新了的月模型
    return thisMonthModel;
}

/**
 *  返回一个指定的日期是今年的第几月
 *
 *  @param oneDate 指定的日期
 *
 *  @return 今年的第几月数
 */
+ (NSInteger) monthOfYearFromADate: (NSDate *) oneDate
{
    return oneDate.month;
}

+ (NSInteger)monthOfYearWithDate: (NSDate *)date
{
    return (date.year - LS_Baseyear) * 12 + date.month;
}

/**
 *   返回指定日期一年内所有的月模型
 *
 *  @param oneDate 指定日期
 *
 *  @return 这一年内所有月模型的字典
 */
+ (NSDictionary *) getThisYearAllMonthModelWithDate:(NSDate *) oneDate
{
    //取得这一年的模型，没有就返回
    NSInteger thisYearNumber = oneDate.year;
    NSString *where = [NSString stringWithFormat:@"_yearID = '%@'", [NSString stringWithFormat:@"%ld", (long)thisYearNumber]];
    YearModel *thisYearModel = [[YearModel getUsingLKDBHelper] searchSingle:[YearModel class] where:where orderBy:nil];
    
    if (!thisYearNumber)
    {
        NSLog(@"压根还没有此年份的数据,如需创建，请用本类的init类方法");
        return nil;
    }
    
    if (thisYearModel._thisYearAllMonths.count == 0)
    {
        NSLog(@"此年份的月数据还为空,如需创建，请用本类的init类方法");
        return nil;
    }
    return thisYearModel._thisYearAllMonths;
}

/**
 *  返回指定日期的月模型
 *
 *  @param oneDate 指定的日期
 *
 *  @return 取出来的月模型
 */
+ (MonthModel *) getTheMonthModelWithDate:(NSDate *) oneDate
{
    //取得这一年的模型，没有就返回
    NSDictionary *tempDictionary = [YearModel getThisYearAllWeekModelWithDate: oneDate];
    
    if (!tempDictionary)
    {
        return nil;
    }
    
    //取到这一月的模型，没有就返回
    NSInteger thisMonthNumber = oneDate.month;
    MonthModel *thisMonthModel = [tempDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)thisMonthNumber]];
    
    if (!thisMonthModel)
    {
        NSLog(@"压根还没有此月的数据,如需创建，请用本类的init类方法");
        return nil;
    }
    return thisMonthModel;
}


// 表名
+ (NSString *)getTableName
{
    return @"YearModel";
}

// 主键
+(NSString *)getPrimaryKey
{
    return @"_yearID";
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

