//
//  BSWeightPickerView.m
//  LoveSports
//
//  Created by zorro on 15/5/23.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BSWeightPickerView.h"

@interface BSWeightPickerView ()

@property (nonatomic) NSUInteger indexSelectedBeforeDismissal;

@end

@implementation BSWeightPickerView

#pragma mark - Designated Initializer

- (id)initWithInteger:(NSArray *)integers withDecimals:(NSArray *)decimals withUnit:(NSString *)unitString
{
    self = [super init];
    if (self) {
        self.integers = integers;
        self.decimals = decimals;
        self.unitString = unitString;
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Custom Getters

- (UIView *)pickerWithFrame:(CGRect)pickerFrame {
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    [pickerView setBackgroundColor:vPickViewBackgroudColor];
    [pickerView selectRow:self.selectedIndex1 inComponent:0 animated:NO];
    [pickerView selectRow:self.selectedIndex2 inComponent:2 animated:NO];

    return pickerView;
}

- (CGFloat)selectedValue {
    NSString *baseInt = [self.integers objectAtIndex:self.selectedIndex1];
    NSString *baseFloat = [self.decimals objectAtIndex:self.selectedIndex2];

    return [baseInt intValue] + [baseFloat intValue] * 1.0 / 10;
}

#pragma mark - Custom Setters

- (void)setIntegers:(NSArray *)integers
{
    _integers = integers;

    if (_integers) {
        if (self.picker) {
            UIPickerView *pickerView = (UIPickerView *)self.picker;
            [pickerView reloadAllComponents];
            self.selectedIndex1 = 0;
        }
    }
}

- (void)setDecimals:(NSArray *)decimals
{
    _decimals = decimals;
    
    if (_decimals) {
        if (self.picker) {
            UIPickerView *pickerView = (UIPickerView *)self.picker;
            [pickerView reloadAllComponents];
            self.selectedIndex2 = 0;
        }
    }
}

- (void)setUnitString:(NSString *)unitString
{
    _unitString = unitString;
    if (_unitString)
    {
        if (self.picker) {
            UIPickerView *pickerView = (UIPickerView *)self.picker;
            [pickerView reloadAllComponents];
        }
    }
}

- (void)setSelectedIndex1:(NSUInteger)selectedIndex1 {
    if (_selectedIndex1 != selectedIndex1) {
        _selectedIndex1 = selectedIndex1;
        if (self.picker) {
            UIPickerView *pickerView = (UIPickerView *)self.picker;
            [pickerView selectRow:selectedIndex1 inComponent:0 animated:YES];
        }
    }
}

- (void)setSelectedIndex2:(NSUInteger)selectedIndex2 {
    if (_selectedIndex2 != selectedIndex2) {
        _selectedIndex2 = selectedIndex2;
        if (self.picker) {
            UIPickerView *pickerView = (UIPickerView *)self.picker;
            [pickerView selectRow:selectedIndex2 inComponent:2 animated:YES];
        }
    }
}

#pragma mark - Event Handler

- (void)onDone:(id)sender {
    //    self.selectedIndex = self.indexSelectedBeforeDismissal;
    [super onDone:sender];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
    {
        return _integers.count;
    }
    else if (component == 1)
    {
        return 1;
    }
    else if (component == 2)
    {
        return _decimals.count;
    }
    else
    {
        return 1;
    }
}

#pragma mark - Picker View Delegate

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0)
    {
        return [_integers objectAtIndex:row];
    }
    else
    {
        return [_decimals objectAtIndex:row];
    }
}
*/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.textColor = [UIColor blackColor];
    }
    
    if (component == 0)
    {
        pickerLabel.textAlignment = NSTextAlignmentRight;
        pickerLabel.font = [UIFont systemFontOfSize:15];
        pickerLabel.text = [_integers objectAtIndex:row];
    }
    else if (component == 1)
    {
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:15];
        pickerLabel.text = @".";
    }
    else if (component == 2)
    {
        pickerLabel.textAlignment = NSTextAlignmentLeft;
        pickerLabel.font = [UIFont systemFontOfSize:15];
        pickerLabel.text = [_decimals objectAtIndex:row];
    }
    else
    {
        pickerLabel.textAlignment = NSTextAlignmentLeft;
        pickerLabel.font = [UIFont systemFontOfSize:15];
        
        if (_unitString)
        {
            pickerLabel.text = _unitString;
        }
    }
    
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0)
    {
        self.selectedIndex1 = row;
    }
    else if (component == 2)
    {
        self.selectedIndex2 = row;
    }
}

@end
