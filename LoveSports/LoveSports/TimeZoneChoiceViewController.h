//
//  TimeZoneChoiceViewController.h
//  LoveSports
//
//  Created by jamie on 15/4/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChoiceTimZoneOver)(long choiceIndex, NSString *choiceValue);

@interface TimeZoneChoiceViewController : UIViewController



@property (nonatomic, assign) NSInteger _choiceIndex;
@property (nonatomic, strong) ChoiceTimZoneOver choiceOverBlock;

@end
