//
//  TimePickerView.h
//  KKConstraint
//
//  Created by zorro on 15/5/11.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSString *timeOrder;
@property (nonatomic, assign) NSInteger hourOrder;
@property (nonatomic, assign) NSInteger minutesOrder;
@property (nonatomic, strong) UIColor *textColor;

- (void)setPositionWithHour:(NSInteger)hour withMinute:(NSInteger)minutes;

@end
