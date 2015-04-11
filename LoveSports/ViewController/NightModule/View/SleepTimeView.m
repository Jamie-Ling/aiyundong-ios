//
//  SleepTimeView.m
//  LoveSports
//
//  Created by zorro on 15/3/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "SleepTimeView.h"

@implementation SleepTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self loadLabels];
    }
    
    return self;
}

- (void)loadLabels
{
    _qualityLabel = [UILabel simpleLabelWithRect:CGRectMake(0, 0, self.width / 2, self.height / 2)
                                   withAlignment:NSTextAlignmentCenter
                                    withFontSize:14
                                        withText:@"睡眠质量"
                                   withTextColor:[UIColor lightGrayColor]
                                         withTag:3000];
    [self addSubview:_qualityLabel];
    
    _qualityText = [UILabel simpleLabelWithRect:CGRectMake(0, self.height / 2, self.width / 2, self.height / 2)
                                  withAlignment:NSTextAlignmentCenter
                                   withFontSize:12
                                       withText:@"70%"
                                  withTextColor:[UIColor blackColor]
                                        withTag:3001];
    [self addSubview:_qualityText];
    
    _timeLabel = [UILabel simpleLabelWithRect:CGRectMake(self.width / 2, 0, self.width / 2, self.height / 2)
                                withAlignment:NSTextAlignmentCenter
                                 withFontSize:14
                                     withText:@"总睡眠时间"
                                withTextColor:[UIColor lightGrayColor]
                                      withTag:3002];
    [self addSubview:_timeLabel];
    
    _timeText = [UILabel simpleLabelWithRect:CGRectMake(self.width / 2, self.height / 2, self.width / 2, self.height / 2)
                               withAlignment:NSTextAlignmentCenter
                                withFontSize:12
                                    withText:@"7小时45分"
                               withTextColor:[UIColor blackColor]
                                     withTag:3002];
    [self addSubview:_timeText];
}

- (void)updateContentForLabelsWithPercent:(CGFloat)percent withTime:(NSInteger)time
{
    _qualityText.text = [NSString stringWithFormat:@"%.f%%", percent * 100];
    if (percent > 0.9999)
    {
        _qualityText.text = @"100%";
    }
    
    _timeText.text = [NSString stringWithFormat:@"%ld小时%ld分", time / 60, time % 60];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
