//
//  TimePickerView.m
//  KKConstraint
//
//  Created by zorro on 15/5/11.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define TPV_MaxNumber_Hour (20)
#define TPV_MaxNumber_Min (10)

#import "TimePickerView.h"

@interface TimePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minutesArray;

@end

@implementation TimePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textColor = [UIColor blackColor];
        
        [self loadData];
        [self loadPickView];
    }
    
    return self;
}

- (void)setPositionWithHour:(NSInteger)hour withMinute:(NSInteger)minutes
{
    _timeOrder = hour > 12 ? @"PM" : @"AM";
    _hourOrder = hour;
    _minutesOrder = minutes;
    
    [_pickerView selectRow:[_timeArray indexOfObject:_timeOrder]
               inComponent:0
                  animated:NO];
    [_pickerView selectRow:(24 * TPV_MaxNumber_Hour / 2) - ((24 * TPV_MaxNumber_Hour / 2) % 24 + 1) + (_hourOrder - 1) % 24
               inComponent:1
                  animated:NO];
    [_pickerView selectRow:(60 * TPV_MaxNumber_Min / 2) - ((60 * TPV_MaxNumber_Min / 2) % 60) + _minutesOrder % 60
               inComponent:2
                  animated:NO];
}

- (void)loadData
{
    _timeArray = @[@"AM", @"PM"];
    
    _hoursArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i <= 24 * TPV_MaxNumber_Hour; i++)
    {
        [_hoursArray addObject:[NSString stringWithFormat:@"%d", i % 24 + 1]];
    }
    
    _minutesArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 60 * TPV_MaxNumber_Min; i++)
    {
        [_minutesArray addObject:[NSString stringWithFormat:@"%d", i % 60]];
    }
}

- (void)loadPickView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    [self addSubview:_pickerView];
    
    [_pickerView selectRow:(24 * TPV_MaxNumber_Hour / 2) - ((24 * TPV_MaxNumber_Hour / 2) % 24 + 1)
               inComponent:1
                  animated:NO];
    [_pickerView selectRow:(60 * TPV_MaxNumber_Min / 2) - ((60 * TPV_MaxNumber_Min / 2) % 60)
               inComponent:2
                  animated:NO];
}

//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 2;
    }
    else if (component == 1)
    {
        return 24 * TPV_MaxNumber_Hour;
    }
    else
    {
        return 60 * TPV_MaxNumber_Min;
    }
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _timeArray[row];
    }
    else if (component == 1)
    {
        return _hoursArray[row];
    }
    else
    {
        return _minutesArray[row];
    }
}
 */

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.textColor = _textColor;
    }
    
    if (component == 0)
    {
        pickerLabel.font = [UIFont systemFontOfSize:12.0];
        pickerLabel.text = _timeArray[row];
    }
    else if (component == 1)
    {
        pickerLabel.font = [UIFont systemFontOfSize:18.0];
        NSInteger number = [_hoursArray[row] integerValue];
        pickerLabel.text = [NSString stringWithFormat:@"%ld", (number > 12) ? number - 12: number];
    }
    else
    {
        pickerLabel.font = [UIFont systemFontOfSize:18.0];
        pickerLabel.text = [NSString stringWithFormat:@"%@", _minutesArray[row]];
    }
    
    return pickerLabel;
}

// 监听
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        _timeOrder = _timeArray[row];
        
        NSInteger maxNumber = 24 * TPV_MaxNumber_Hour;
        NSInteger base = (maxNumber / 2) - ((maxNumber / 2) % 24 + 1);
        
        if (row == 0)
        {
            if (_hourOrder > 12)
            {
                [pickerView selectRow:[pickerView selectedRowInComponent:1] % 24 + 1 + base - 12
                          inComponent:1
                             animated:NO];
                _hourOrder -= 12;

            }
        }
        else
        {
            if (_hourOrder <= 12)
            {
                [pickerView selectRow:[pickerView selectedRowInComponent:1] % 24 + 1 + base + 12
                          inComponent:1
                             animated:NO];
                _hourOrder += 12;
            }
        }
    }
    else if (component == 1)
    {
        _hourOrder = [_hoursArray[row] integerValue];
        
        if (_hourOrder > 12)
        {
            [pickerView selectRow:1
                       inComponent:0
                          animated:YES];
            _timeOrder = _timeArray[1];
        }
        else
        {
            [pickerView selectRow:0
                       inComponent:0
                          animated:YES];
            _timeOrder = _timeArray[0];
        }
        
        NSInteger maxNumber = 24 * TPV_MaxNumber_Hour;
        NSInteger base = (maxNumber / 2) - ((maxNumber / 2) % 24 + 1);
        [pickerView selectRow:[pickerView selectedRowInComponent:component] % 24 + 1 + base inComponent:component animated:NO];
    }
    else
    {
        _minutesOrder = [_minutesArray[row] integerValue];

        NSInteger maxNumber = 60 * TPV_MaxNumber_Min;
        NSInteger base = (maxNumber / 2) - ((maxNumber / 2) % 60);
        [pickerView selectRow:[pickerView selectedRowInComponent:component] % 60 + base inComponent:component animated:NO];
    }
}

@end
