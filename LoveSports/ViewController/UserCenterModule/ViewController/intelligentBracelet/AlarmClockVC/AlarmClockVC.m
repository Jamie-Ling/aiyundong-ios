//
//  AlarmClockVC.m
//  LoveSports
//
//  Created by zorro on 15/4/4.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AlarmClockVC.h"
#import "AlarmClockCell.h"
#import "BSModalDatePickerView.h"

@interface AlarmClockVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *alarmArray;

@end

@implementation AlarmClockVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundColor = UIColorRGB(214, 214, 212);
    _alarmArray = [AlarmClockModel getAlarmClockFromDB];
    
    [self loadRightItem];
    [self loadTitleView];
    [self loadTableView];
}

- (void)loadRightItem
{
    UIButton *button = [UIButton simpleWithRect:CGRectMake(0, 0, 44, 44)
                                      withTitle:@"保存"
                                withSelectTitle:@"保存"
                                      withColor:[UIColor clearColor]];
    [button addTouchUpTarget:self action:@selector(clickSaveButton:)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    item.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickSaveButton:(UIButton *)button
{
    for (AlarmClockModel *model in _alarmArray)
    {
        [model convertToBLTNeed];
    }
}

- (void)loadTitleView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    
    label.text = @"振动提醒";
    [label sizeToFit];
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, self.width, self.height - 64)];
    
    _tableView.backgroundColor = UIColorRGB(214, 214, 212);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

#pragma mark --- UITableView ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _alarmArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmClockModel *model = _alarmArray[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellString = @"AlarmClockCell";
    AlarmClockCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell)
    {
        cell = [[AlarmClockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    AlarmClockModel *model = _alarmArray[indexPath.row];
    [cell updateContentForCellFromAlarmModel:model WithHeight:model.height withIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *theDate = [NSDate date];
    __weak AlarmClockModel *model = _alarmArray[indexPath.row];
    
    NSString *setTimeString = model.alarmTime ;
    if (![NSString isNilOrEmpty:setTimeString ])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];     //大写HH，强制24小时
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:timeZone];
        theDate = [dateFormatter dateFromString:setTimeString];
    }
    
    DEF_WEAKSELF_(AlarmClockVC);
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:theDate];
    datePicker.showTodayButton = NO;
    datePicker.mode = UIDatePickerModeTime;
    [datePicker presentWithWeekDayInView:self.view
                      withUpdatWeedArray:model.weekArray
                               withBlock:^(BOOL madeChoice) {
                                   if (madeChoice) {
                                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                       [dateFormatter setDateFormat:@"HH:mm"];     //大写HH，强制24小时
                                       NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                                       [dateFormatter setTimeZone:timeZone];
                                       NSString *choiceString = [dateFormatter stringFromDate:datePicker.selectedDate];
                                       NSLog(@"dayarray = %@", datePicker._dayArray);
                                       //                            if (![choiceString isEqualToString:setTimeString] )
                                       //                            {
                                       NSLog(@"修改闹钟时间吧， 为 %@", choiceString);
                                       model.weekArray = datePicker._dayArray;
                                       model.alarmTime = choiceString;

                                       [weakSelf.tableView reloadData];
                                       [model updateToDB];
                                   }
                               }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
