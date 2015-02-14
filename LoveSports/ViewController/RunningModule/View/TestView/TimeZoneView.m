//
//  TimeZoneView.m
//  LoveSports
//
//  Created by zorro on 15-1-28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TimeZoneView.h"
#import "BLTSendData.h"

@implementation TimeZoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadLabelAndSegs];
    }
    
    return self;
}

- (void)loadLabelAndSegs
{
    _alertLabel = [UILabel customLabelWithRect:CGRectMake(0, 10, self.width, 20)];
    _alertLabel.backgroundColor = [UIColor redColor];
    _alertLabel.text = @"请选择公/英制和小时制";
    [self addSubview:_alertLabel];
    
    _seg1 = [[UISegmentedControl alloc] initWithItems:@[@"公制", @"英制"]];
    _seg1.frame = CGRectMake((self.width - 100) / 2, 50, 100, 40);
    _seg1.backgroundColor = [UIColor lightGrayColor];
    [_seg1 addTarget:self action:@selector(changeSeg1:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_seg1];
    _seg1.selectedSegmentIndex = 0;
    
    _seg2 = [[UISegmentedControl alloc] initWithItems:@[@"12H制", @"24H制"]];
    _seg2.frame = CGRectMake((self.width - 100) / 2, 95, 100, 40);
    _seg2.backgroundColor = [UIColor lightGrayColor];
    [_seg2 addTarget:self action:@selector(changeSeg2:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_seg2];
    _seg2.selectedSegmentIndex = 0;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 60) / 2, 145, 60, 48)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)changeSeg1:(UISegmentedControl *)seg
{
    
}

- (void)changeSeg2:(UISegmentedControl *)seg
{
    
}

- (void)clickConfirm
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"慎重选择" message:@"普通用户无法修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [BLTSendData sendBasicSetOfInformationData:_seg1.selectedSegmentIndex
                                        withHourly:_seg2.selectedSegmentIndex
                                   withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                   }];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self dismissPopup];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
