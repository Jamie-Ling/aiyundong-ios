//
//  WeekModel.h
//  LoveSports
//
//  Created by jamie on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekModel : NSObject

//@property (nonatomic, strong)
@property (nonatomic, assign) NSInteger weekTotalSteps;     // 当天的总步数
@property (nonatomic, assign) NSInteger weekTotalCalories;  // 当天的总卡路里
@property (nonatomic, assign) NSInteger weekTotalDistance ; // 当天的总路程

@end
