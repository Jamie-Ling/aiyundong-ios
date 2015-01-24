//
//  MSDatePicker.h
//  Woyoli
//
//  Created by jamie on 14/12/16.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MSDatePickerDelegate <NSObject>

- (void) checkOneDate: (NSDate *) theDate;

@end

@interface MSDatePicker : UIView


-(id)initwithYMDDatePickerDelegate:(id<MSDatePickerDelegate>)delegate withMinimumDate:(NSString *)minimumDate withMaximumDate: (NSDate *) maximumDate withNowDate: (NSDate *) nowDate;

/**
 *  弹出模态视窗
 *
 *  @param view 展现的父view
 */
-(void) showInView:(UIView *)view;

@end
