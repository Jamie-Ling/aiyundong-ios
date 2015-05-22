//
//  RemindPicker.m
//  LoveSports
//
//  Created by zorro on 15/4/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "RemindPicker.h"

@interface RemindPicker ()

@end

@implementation RemindPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadButtons];
        // [self loadTimePicker];
        [self loadDatePicker];
    }
    
    return self;
}

- (void)loadButtons
{
    _cancelButton = [UIButton simpleWithRect:CGRectMake(0, 0, 64, 44)
                                   withTitle:LS_Text(@"Cancel")
                             withSelectTitle:LS_Text(@"Cancel")
                                   withColor:[UIColor clearColor]];
    _cancelButton.titleColorNormal = UIColorFromHEX(0x169ad8);
    [_cancelButton addTouchUpTarget:self action:@selector(clickCancelButton:)];
    [self addSubview:_cancelButton];
    
    _confirmButton = [UIButton simpleWithRect:CGRectMake(self.width - 84, 0, 84, 44)
                                    withTitle:LS_Text(@"Confirm")
                              withSelectTitle:LS_Text(@"Confirm")
                                    withColor:[UIColor clearColor]];
    _confirmButton.titleColorNormal = UIColorFromHEX(0x169ad8);
    [_confirmButton addTouchUpTarget:self action:@selector(clickConfirmButton:)];
    [self addSubview:_confirmButton];
    
    _titleLabel = [UILabel simpleLabelWithRect:CGRectMake(0, 0, self.width, 44)
                                 withAlignment:NSTextAlignmentCenter
                                  withFontSize:15 withText:@""
                                 withTextColor:[UIColor blackColor]
                                       withTag:0];
    [self addSubview:_titleLabel];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5 - 0.5, self.width, 0.5)];
    downLine.backgroundColor = UIColorFromHEX(0xcfcdce);
    [self addSubview:downLine];
}

- (void)loadDatePicker
{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, self.width, self.height - 44)];
    
    [_datePicker setDatePickerMode:UIDatePickerModeTime];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[DataShare sharedInstance].isEnglish ? @"en_US" : @"zh_CN"];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [_datePicker setTimeZone:timeZone];
    [self addSubview:_datePicker];
}

- (void)loadTimePicker
{
    _timePicker = [[TimePickerView alloc] initWithFrame:CGRectMake(0, 44, self.width, self.height - 44)];
    
    [self addSubview:_timePicker];
}

- (void)clickCancelButton:(UIButton *)button
{
    if (_cancelBlock)
    {
        _cancelBlock(self, nil);
    }
}

- (void)clickConfirmButton:(UIButton *)button
{
    if (_confirmBlock)
    {
        _confirmBlock(self, _datePicker.date);
        // NSLog(@".._datePicker.date = %@ %d...%d..", _datePicker.date, _datePicker.date.hour, _datePicker.date.minute);
        // _confirmBlock(self, _timePicker);
    }
}

- (void)updateContentForDatePicker:(NSString *)time withIndex:(NSInteger)index
{
    NSString *string = [NSString stringWithFormat:@"2000-01-01 %@:00", time];
    NSDate *date = [NSDate dateWithString:string];
    
    [_datePicker setDate:date animated:NO];
    
    /*
    NSArray *array = [time componentsSeparatedByString:@":"];
    [_timePicker setPositionWithHour:[array[0] integerValue] withMinute:[array[1] integerValue]];
     */
    
    _titleLabel.text = index ? [NSString stringWithFormat:@"%@  ", LS_Text(@"Ending Time")] : [NSString stringWithFormat:@"%@  ", LS_Text(@"Beginning Time")];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
