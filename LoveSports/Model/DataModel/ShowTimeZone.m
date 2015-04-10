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
        _showPlace = @"亚洲/北京";
    }
    
    _timeZone = [array[3] integerValue] * 2 / 3600;
    NSInteger totalMin = _timeZone * 3600 / 2 / 60;
    NSString *timeString = [NSString stringWithFormat:@"%@%ld:%02ld",
                            _timeZone >= 0 ? @"＋" : @"", totalMin / 60, totalMin % 60];
    _showString = [NSString stringWithFormat:@"%@  GMT %@", _showPlace, timeString];
}

@end
