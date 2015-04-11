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
        self.layer.cornerRadius = 6.0;
        self.backgroundColor = [UIColor whiteColor];
        
        _offset = 44.0;
        
        [self loadLines];
        [self loadLabelsAndViews];
    }
    
    return self;
}

- (void)loadLines
{
    for (int i = 0; i < 3; i++)
    {
        [self addSubViewWithRect:CGRectMake(0, 44 * (i + 1), self.width, 1)
                       withColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]
                       withImage:nil];
    }
}

- (void)loadLabelsAndViews
{
    _openLabel = [UILabel simpleLabelWithRect:CGRectMake(10, 0, self.width / 2 - 10, _offset)
                                withAlignment:NSTextAlignmentLeft
                                 withFontSize:16
                                     withText:@"开关"
                                withTextColor:[UIColor blackColor]
                                      withTag:1000];
    [self addSubview:_openLabel];
    
    _openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.width / 3 * 2, 7, 60, 30)];
    [_openSwitch addTarget:self action:@selector(clickOpenSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_openSwitch];
    
    _intervalLabel = [UILabel simpleLabelWithRect:CGRectMake(10, _offset, self.width / 2 - 10, _offset)
                                    withAlignment:NSTextAlignmentLeft
                                     withFontSize:16
                                         withText:@"时间间隔"
                                    withTextColor:[UIColor blackColor]
                                          withTag:1000];
    [self addSubview:_intervalLabel];
    
    _textField = [UITextField simpleInit:CGRectMake(self.width / 2, _offset, self.width / 2, _offset)
                               withImage:nil
                         withPlaceholder:@"0"
                                withFont:16];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_textField];
    
    _startLabel = [UILabel simpleLabelWithRect:CGRectMake(10, _offset * 2, self.width / 2, _offset)
                                 withAlignment:NSTextAlignmentLeft
                                  withFontSize:16
                                      withText:@"开始时间"
                                 withTextColor:[UIColor blackColor]
                                       withTag:1000];
    [self addSubview:_startLabel];
    
    _startTimeLabel = [UILabel simpleLabelWithRect:CGRectMake(0, _offset * 2, self.width, _offset)
                                     withAlignment:NSTextAlignmentCenter
                                      withFontSize:16
                                          withText:@"00:00"
                                     withTextColor:[UIColor blackColor]
                                           withTag:1000];
    [self addSubview:_startTimeLabel];
    
    _endLabel = [UILabel simpleLabelWithRect:CGRectMake(10, _offset * 3, self.width / 2, _offset)
                               withAlignment:NSTextAlignmentLeft
                                withFontSize:16
                                    withText:@"结束时间"
                               withTextColor:[UIColor blackColor]
                                     withTag:1000];
    [self addSubview:_endLabel];
    
    _endTimeLabel = [UILabel simpleLabelWithRect:CGRectMake(0, _offset * 3, self.width, _offset)
                                   withAlignment:NSTextAlignmentCenter
                                    withFontSize:16
                                        withText:@"00:00"
                                   withTextColor:[UIColor blackColor]
                                         withTag:1000];
    [self addSubview:_endTimeLabel];
    
    [self addTapsForLabels];
}

- (void)addTapsForLabels
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickStartTimeLabel:)];
    [_startTimeLabel addGestureRecognizer:tap];
    _startTimeLabel.userInteractionEnabled = YES;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEndTimeLabel:)];
    [_endTimeLabel addGestureRecognizer:tap];
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
