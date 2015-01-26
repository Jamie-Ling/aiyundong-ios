//
//  BSModalDatePickerView.m
//  CustomPicker
//
//  Created by Seth Friedman on 5/22/13.
//  Copyright (c) 2013 Fickle Bits, LLC. All rights reserved.
//

#import "BSModalDatePickerView.h"

@implementation BSModalDatePickerView

@synthesize selectedDate = _selectedDate;
@synthesize mode = _mode;

#pragma mark - Designated Initializer

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _selectedDate = date;
        _mode = UIDatePickerModeDate;
    }
    return self;
}

#pragma mark - Custom Getters

- (UIView *)pickerWithFrame:(CGRect)pickerFrame {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    //设置固定最大最小值  -- by jamie
    // 设置时区
    //    [_customDatePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [datePicker setTimeZone:timeZone];
    //设置为显示中文
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    [datePicker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //设置日期最大最小值
    datePicker.minimumDate= [dateFormatter dateFromString:@"1900-01-01"];
    
    
    [datePicker setBackgroundColor:vPickViewBackgroudColor];
    if (self.selectedDate) {
        datePicker.date = self.selectedDate;
    }

    datePicker.datePickerMode = self.mode;
    return datePicker;
}

- (NSDate *)selectedDate {
    if (_picker) {
        UIDatePicker *datePicker = (UIDatePicker *)self.picker;
        _selectedDate = datePicker.date;
    }

    return _selectedDate;
}

- (UIDatePickerMode)mode {
    if (_picker) {
        UIDatePicker *datePicker = (UIDatePicker *)self.picker;
        _mode = datePicker.datePickerMode;
    }

    return _mode;
}

- (NSArray *)additionalToolbarItems {
    if (self.showTodayButton) {
        return @[
                 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                               target:nil action:nil],
                 [[UIBarButtonItem alloc] initWithTitle:@"Today"
                                                  style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(onToday:)],
                 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                               target:nil action:nil],
                 ];
    } else {
        return [super additionalToolbarItems];
    }
}

#pragma mark - Custom Setters

- (void)setSelectedDate:(NSDate *)selectedDate {
    if (_selectedDate != selectedDate) {
        _selectedDate = selectedDate;
        
        if (self.picker) {
            UIDatePicker *datePicker = (UIDatePicker *)self.picker;
            datePicker.date = _selectedDate;
        }
    }
}

- (void)setMode:(UIDatePickerMode)mode {
    if (_mode != mode) {
        _mode = mode;
        
        if (self.picker) {
            UIDatePicker *datePicker = (UIDatePicker *)self.picker;
            datePicker.datePickerMode = _mode;
        }
    }
}

#pragma mark - Event Handler

- (void)onToday:(id)sender {
    self.selectedDate = [NSDate date];
}

@end
