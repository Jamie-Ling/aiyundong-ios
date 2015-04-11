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
        [self loadDatePicker];
    }
    
    return self;
}

- (void)loadButtons
{
    _cancelButton = [UIButton simpleWithRect:CGRectMake(0, 0, 64, 44)
                                   withTitle:@"取消"
                             withSelectTitle:@"取消"
                                   withColor:[UIColor clearColor]];
    [_cancelButton addTouchUpTarget:self action:@selector(clickCancelButton:)];
    [self addSubview:_cancelButton];
    
    _confirmButton = [UIButton simpleWithRect:CGRectMake(self.width - 64, 0, 64, 44)
                                    withTitle:@"确定"
                              withSelectTitle:@"确定"
                                    withColor:[UIColor clearColor]];
    [_confirmButton addTouchUpTarget:self action:@selector(clickConfirmButton:)];
    [self addSubview:_confirmButton];
    
    _titleLabel = [UILabel simpleLabelWithRect:CGRectMake(0, 0, self.width, 44)
                                 withAlignment:NSTextAlignmentCenter
                                  withFontSize:15 withText:@""
                                 withTextColor:[UIColor blackColor]
                                       withTag:0];
    [self addSubview:_titleLabel];
    
    [self addSubViewWithRect:CGRectMake(0, 43.5, self.width, 1)
                   withColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]
                   withImage:nil];
}

- (void)loadDatePicker
{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, self.width, self.height - 44)];
    
    [_datePicker setDatePickerMode:UIDatePickerModeTime];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [_datePicker setTimeZone:timeZone];
    [self addSubview:_datePicker];
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
    }
}

- (void)updateContentForDatePicker:(NSString *)time withIndex:(NSInteger)index
{
    NSString *string = [NSString stringWithFormat:@"2000-01-01 %@:00", time];
    NSDate *date = [NSDate dateWithString:string];
    
    [_datePicker setDate:date animated:NO];
    _titleLabel.text = index ? @"结束时间" : @"开始时间";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
