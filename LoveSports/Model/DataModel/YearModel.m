//
//  YearModel.m
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "YearModel.h"
#import "UserInfoHelp.h"

@implementation YearModel

- (instancetype)init
{
    self = [super init];
    if (self) {
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
    
    //取到这一周的模型，没有就创建，更新至年模型中
    NSInteger thisWeekNumber = oneDate.weekOfYear;
    NSString *where = [NSString stringWithFormat:@"yearNumber = %ld AND weekNumber = %ld AND userName = '%@' AND wareUUID = '%@'", (long)thisYearNumber, (long)thisWeekNumber, onePedoMeterModel.userName, onePedoMeterModel.wareUUID];
    WeekModel *thisWeekModel = [WeekModel searchSingleWithWhere:where orderBy:nil];
    if (!thisWeekModel)
    {
        thisWeekModel = [[WeekModel alloc] initWithWeekNumber:thisWeekNumber andYearNumber:thisYearNumber];
        thisWeekModel.userName = onePedoMeterModel.userName;
        thisWeekModel.wareUUID = onePedoMeterModel.wareUUID;
        [thisWeekModel saveToDB];
    }
    
    [thisWeekModel updateTotalWithModel:onePedoMeterModel];
    [WeekModel updateToDB:thisWeekModel where:where];

    //取到这一月的模型，没有就创建，更新至年模型中
    NSInteger thisMonthNumber = oneDate.month;
    where = [NSString stringWithFormat:@"yearNumber = %ld AND monthNumber = %ld AND userName = '%@' AND wareUUID = '%@'", (long)thisYearNumber, (long)thisMonthNumber, onePedoMeterModel.userName, onePedoMeterModel.wareUUID];
    MonthModel *thisMonthModel = [MonthModel searchSingleWithWhere:where orderBy:nil];
    if (!thisMonthModel)
    {
        thisMonthModel = [[MonthModel alloc] initWithmonthNumber:thisMonthNumber andYearNumber:thisYearNumber];
        thisMonthModel.userName = onePedoMeterModel.userName;
        thisMonthModel.wareUUID = onePedoMeterModel.wareUUID;
        [thisMonthModel saveToDB];
    }
    
    [thisMonthModel updateTotalWithModel:onePedoMeterModel];
    [MonthModel updateToDB:thisMonthModel where:where];
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
    return nil;
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
    
    if (thisYearModel.thisYearAllWeeks.count == 0)
    {
        NSLog(@"此年份的周数据还为空,如需创建，请用本类的init类方法");
        return nil;
    }
    return thisYearModel.thisYearAllWeeks;
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
    NSString *where = [NSString stringWithFormat:@"yearNumber = %ld AND weekNumber = %ld AND userName = '%@' AND wareUUID = '%@'", (long)year, (long)order, [UserInfoHelp sharedInstance].userModel.userName, [LS_LastWareUUID getObjectValue]];
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
    NSString *where = [NSString stringWithFormat:@"yearNumber = %ld AND monthNumber = %ld AND userName = '%@' AND wareUUID = '%@'", (long)currentYear, (long)month, [UserInfoHelp sharedInstance].userModel.userName, [LS_LastWareUUID getObjectValue]];
    MonthModel *model = [MonthModel searchSingleWithWhere:where orderBy:nil];
    
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
    return nil;
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
    
    if (thisYearModel.thisYearAllMonths.count == 0)
    {
        NSLog(@"此年份的月数据还为空,如需创建，请用本类的init类方法");
        return nil;
    }
    return thisYearModel.thisYearAllMonths;
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
    return @"yearID";
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end

