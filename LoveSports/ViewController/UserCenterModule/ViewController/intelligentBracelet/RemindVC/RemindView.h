//
//  RemindView.h
//  LoveSports
//
//  Created by zorro on 15/4/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindModel.h"

@interface RemindView : UIView

@property (nonatomic, strong) UILabel *openLabel;
@property (nonatomic, strong) UISwitch *openSwitch;

@property (nonatomic, strong) UILabel *intervalLabel;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;

@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;

@property (nonatomic, strong) UIViewSimpleBlock tapBlock;
@property (nonatomic, strong) RemindModel *model;

- (void)updateContentWithModel:(RemindModel *)model;
- (void)updateContentForLabelWithTime:(NSString *)time withIndex:(NSInteger)index;

@end
