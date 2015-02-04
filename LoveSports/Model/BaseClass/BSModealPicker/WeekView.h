//
//  WeekView.h
//  ZKKWaterHeater
//
//  Created by zorro on 15-1-5.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekView : UIView
typedef void(^WeekViewBlock)(WeekView *weekView);

@property (nonatomic, strong) NSMutableArray *selArray;
@property (nonatomic, strong) WeekViewBlock weekBlock;

- (instancetype)initWithFrame:(CGRect)frame withWeekBlock:(WeekViewBlock)block;
- (void)updateSelButtonForWeekView:(NSArray *)array;

@end
