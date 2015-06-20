//
//  ShowTimeZone.m
//  LoveSports
//
//  Created by zorro on 15/4/11.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShowTimeZone.h"

@implementation ShowTimeZone

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _place = @"";
        _showPlace = @"";
        _showString = @"";
    }
    
    return self;
}

+ (ShowTimeZone *)simpleWithString:(NSString *)string
{
    ShowTimeZone *model = [[ShowTimeZone alloc] init];
    
    [model updateTimeZone:string];
    
    return model;
}

+ (ShowTimeZone *)simpleWithHour:(NSInteger)hour andMinutes:(NSInteger)minutes andDirection:(NSInteger)direction
{
    ShowTimeZone *model = [[ShowTimeZone alloc] init];
    
    model.hour = hour;
    model.minutes = minutes;
    model.direction = direction;
    
    model.timeZone = (hour + ((minutes > 0) ? 0.5 : 0)) * 2 * direction;
    
    return model;
}

- (NSString *)showString
{
    NSString *show = [NSString stringWithFormat:@"%@ %02d:%02d", (_direction == 1) ? @"＋" : @"－", _hour, _minutes];
    
    return show;
}

- (void)updateTimeZone:(NSString *)string
{
    NSTimeZone *tempTimeZone = [NSTimeZone timeZoneWithName:string];
    NSArray *array =[tempTimeZone.description componentsSeparatedByString:@" "];
    
    if (array.count < 4)
    {
        return;
    }
    
    _place = array[0];
    _showPlace = array[0];
    NSRange range = [_place rangeOfString:@"Shanghai"];
    if (range.location != NSNotFound)
    {
        _showPlace = LS_Text(@"Asia/Beijing");
    }
    
    _timeZone = [array[3] integerValue] * 2 / 3600;
    NSInteger totalMin = _timeZone * 3600 / 2 / 60;
    NSString *timeString = [NSString stringWithFormat:@"%@%d:%02d",
                            _timeZone >= 0 ? @"＋" : @"", totalMin / 60, totalMin % 60];
    _showString = [NSString stringWithFormat:@"%@  GMT %@", _showPlace, timeString];
}

@end
