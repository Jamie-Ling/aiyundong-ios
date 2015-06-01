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

- (instancetype)initWithAlarmClock:(NSArray *)alarmArray
{
    self = [super init];
    if (self)
    {
        _alarmArray = alarmArray;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    DEF_WEAKSELF_(AlarmClockVC);
    [BLTManager sharedInstance].disConnectBlock = ^() {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTManager sharedInstance].disConnectBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundColor = UIColorFromHEX(0xf0f0f0);
    
    [self loadRightItem];
    [self loadTitleView];
    [self loadTableView];
}

- (void)loadRightItem
{
    UIButton *button = [UIButton simpleWithRect:CGRectMake(0, 0, 44, 44)
                                      withTitle:LS_Text(@"Save")
                                withSelectTitle:LS_Text(@"Save")
                                      withColor:[UIColor clearColor]];
    button.titleColorNormal = UIColorFromHEX(0x169ad8);
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

    [[UserInfoHelp sharedInstance] sendSetAlarmClock:^(id object) {
        if ([object boolValue])
        {
            SHOWMBProgressHUD(LS_Text(@"Setting success"), nil, nil, NO, 2.0);
        }
        else
        {
            SHOWMBProgressHUD(LS_Text(@"Setting fail"), nil, nil, NO, 2.0);
            [[BLTManager sharedInstance] dismissLink];
        }
    }];
}

- (void)loadTitleView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    
    label.text = LS_Text(@"Vibration Alarm");
    [label sizeToFit];
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, self.width, self.height - 64)];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

#pragma mark --- UITableView ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserInfoHelp sharedInstance].braceModel.isNewDevice)
    {
        return _alarmArray.count;
    }
    
    return _alarmArray.count - 1;
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
        cell.frame = CGRectMake(0, 0, tableView.width, 0);
    }
    
    AlarmClockModel *model = _alarmArray[indexPath.row];
    [cell updateContentForCellFromAlarmModel:model WithHeight:model.height withIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *theDate = [NSDate date];
    __weak AlarmClockModel *model = _alarmArray[indexPath.row];
    
    NSString *setTimeString = model.alarmTime;
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
    // [datePicker loadTimePickerViewWithTime:model.alarmTime];
    datePicker.showTodayButton = NO;
    datePicker.mode = UIDatePickerModeTime;
    datePicker.selectedDate = theDate;
    datePicker.isAlarm = NO;
    [datePicker presentWithWeekDayInView:self.view
                      withUpdatWeedArray:model.weekArray
                               withBlock:^(BOOL madeChoice) {
                                   if (madeChoice)
                                   {
                                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                       [dateFormatter setDateFormat:@"HH:mm"];     //大写HH，强制24小时
                                       NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                                       [dateFormatter setTimeZone:timeZone];
                                       NSString *choiceString = [dateFormatter stringFromDate:datePicker.selectedDate];
                                       
                                       NSLog(@"修改闹钟时间吧， 为 %@", choiceString);
                                       
                                       model.weekArray = datePicker._dayArray;
                                       
                                       /*
                                       NSString *alarmTime = [NSString stringWithFormat:@"%02ld:%02ld",
                                                              (long)datePicker.timePicker.hourOrder,
                                                              (long)datePicker.timePicker.minutesOrder];*/
                                       model.alarmTime = choiceString;
                                       
                                       NSLog(@".wareUUID = .%@", model.wareUUID);
                                       model.isRepeat = datePicker.repeatView.repeat.on;

                                       [weakSelf.tableView reloadData];
                                   }
                               }];
    datePicker.repeatView.repeat.on = model.isRepeat;
    //datePicker.selectedDate = theDate;
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
