//
//  RemindView.m
//  LoveSports
//
//  Created by zorro on 15/4/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "RemindView.h"

@interface RemindView () <UITextFieldDelegate>

@property (nonatomic, assign) CGFloat offset;

@end

@implementation RemindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _offset = 50;
        [self loadLabelsAndViews];
    }
    
    return self;
}

- (void)loadLabelsAndViews
{
    _openLabel = [UILabel simpleLabelWithRect:CGRectMake(0, 0, self.width, _offset)
                                withAlignment:NSTextAlignmentLeft
                                 withFontSize:16
                                     withText:@"  开关"
                                withTextColor:[UIColor blackColor]
                                      withTag:1000];
    [_openLabel addUpAndDownLine];
    [self addSubview:_openLabel];
    
    _openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.width - 90, 10, 60, 30)];
    [_openSwitch addTarget:self action:@selector(clickOpenSwitch:) forControlEvents:UIControlEventValueChanged];
    [_openLabel addSubview:_openSwitch];
    
    _intervalLabel = [UILabel simpleLabelWithRect:CGRectMake(0, _openLabel.totalHeight + 4, self.width, _offset)
                                    withAlignment:NSTextAlignmentLeft
                                     withFontSize:16
                                         withText:@"  时间间隔"
                                    withTextColor:[UIColor blackColor]
                                          withTag:1000];
    [_intervalLabel addUpAndDownLine];
    [self addSubview:_intervalLabel];
    
    _textField = [UITextField simpleInit:CGRectMake(self.width / 2, 0, self.width / 2, _offset)
                               withImage:nil
                         withPlaceholder:@"0"
                                withFont:16];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_intervalLabel addSubview:_textField];
    
    _startLabel = [UILabel simpleLabelWithRect:CGRectMake(0, _intervalLabel.totalHeight + 4, self.width, _offset)
                                 withAlignment:NSTextAlignmentLeft
                                  withFontSize:16
                                      withText:@"  开始时间"
                                 withTextColor:[UIColor blackColor]
                                       withTag:1000];
    [self addSubview:_startLabel];
    
    _startTimeLabel = [UILabel simpleLabelWithRect:CGRectMake(0, 0, self.width, _offset)
                                     withAlignment:NSTextAlignmentCenter
                                      withFontSize:16
                                          withText:@"00:00"
                                     withTextColor:[UIColor blackColor]
                                           withTag:1000];
    [_startTimeLabel addUpAndDownLine];
    [_startLabel addSubview:_startTimeLabel];
    
    _endLabel = [UILabel simpleLabelWithRect:CGRectMake(0, _startLabel.totalHeight + 4, self.width, _offset)
                               withAlignment:NSTextAlignmentLeft
                                withFontSize:16
                                    withText:@"  结束时间"
                               withTextColor:[UIColor blackColor]
                                     withTag:1000];
    [self addSubview:_endLabel];
    
    _endTimeLabel = [UILabel simpleLabelWithRect:CGRectMake(0, 0, self.width, _offset)
                                   withAlignment:NSTextAlignmentCenter
                                    withFontSize:16
                                        withText:@"00:00"
                                   withTextColor:[UIColor blackColor]
                                         withTag:1000];
    [_endTimeLabel addUpAndDownLine];
    [_endLabel addSubview:_endTimeLabel];
    
    [self addTapsForLabels];
}

- (void)addTapsForLabels
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickStartTimeLabel:)];
    [_startTimeLabel addGestureRecognizer:tap];
    _startLabel.userInteractionEnabled = YES;
    _startTimeLabel.userInteractionEnabled = YES;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEndTimeLabel:)];
    [_endTimeLabel addGestureRecognizer:tap];
    _endLabel.userInteractionEnabled = YES;
    _endTimeLabel.userInteractionEnabled = YES;
}

// 是否开启就做提醒.
- (void)clickOpenSwitch:(UISwitch *)sender
{
    _model.isOpen = sender.on;
}

- (void)clickStartTimeLabel:(UITapGestureRecognizer *)tap
{
    if (_tapBlock)
    {
        _tapBlock(self, @(0));
    }
}

- (void)clickEndTimeLabel:(UITapGestureRecognizer *)tap
{
    if (_tapBlock)
    {
        _tapBlock(self, @(1));
    }
}

- (void)updateContentWithModel:(RemindModel *)model
{
    _model = model;
    
    _openSwitch.on = model.isOpen;
    _textField.text = model.interval;
    _startTimeLabel.text = model.startTime;
    _endTimeLabel.text = model.endTime;
}

- (void)updateContentForLabelWithTime:(NSString *)time withIndex:(NSInteger)index
{
    if (index == 0)
    {
        _startTimeLabel.text = time;
        _model.startTime = time;
    }
    else
    {
        _endTimeLabel.text = time;
        _model.endTime = time;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0";
    }
    
    _model.interval = textField.text;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _model.interval = textField.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
