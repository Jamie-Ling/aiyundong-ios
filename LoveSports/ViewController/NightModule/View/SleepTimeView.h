//
//  SleepTimeView.h
//  LoveSports
//
//  Created by zorro on 15/3/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SleepTimeView : UIView

@property (nonatomic, strong) UILabel *qualityLabel;
@property (nonatomic, strong) UILabel *qualityText;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *timeText;

- (void)updateContentForLabelsWithPercent:(CGFloat)percent withTime:(NSInteger)time;

@end
