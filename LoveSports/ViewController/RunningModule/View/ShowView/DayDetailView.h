//
//  DayDetailView.h
//  LoveSports
//
//  Created by zorro on 15/2/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PedometerModel.h"

@interface DayDetailView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PedometerModel *model;

- (void)updateContentForView:(PedometerModel *)model;

@end
