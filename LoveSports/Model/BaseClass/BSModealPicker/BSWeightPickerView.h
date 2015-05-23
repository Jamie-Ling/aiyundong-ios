//
//  BSWeightPickerView.h
//  LoveSports
//
//  Created by zorro on 15/5/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BSModalPickerBase.h"

@interface BSWeightPickerView : BSModalPickerBase <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSUInteger selectedIndex1;
@property (nonatomic) NSUInteger selectedIndex2;

@property (nonatomic, assign) CGFloat selectedValue;
@property (nonatomic, strong) NSArray *integers;
@property (nonatomic, strong) NSArray *decimals;
@property (nonatomic, strong) NSString *unitString;

/* Initializes a new instance of the picker with the values to present to the user.
 (Note: call presentInView:withBlock: or presentInWindowWithBlock: to display the control)
 */
- (id)initWithInteger:(NSArray *)integers withDecimals:(NSArray *)decimals withUnit:(NSString *)unitString;


@end
