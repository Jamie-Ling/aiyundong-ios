//
//  RemindVC.m
//  LoveSports
//
//  Created by zorro on 15/4/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "RemindVC.h"
#import "RemindView.h"
#import "RemindPicker.h"
#import "UserInfoHelp.h"

@interface RemindVC ()

@property (nonatomic, strong) RemindView *remindView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) RemindPicker *remindPicker;
@property (nonatomic, assign) BOOL isHiddenPicker;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) RemindModel *remindModel;

@end

@implementation RemindVC

- (instancetype)initWithRemind:(RemindModel *)model
{
    self = [super init];
    if (self)
    {
        _remindModel = model;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundColor = UIColorFromHEX(0xf0f0f0);
    
    [self loadRightItem];
    [self loadTitleView];
    [self loadRemindView];
    [self loadRemindPicker];
}

- (void)loadRightItem
{
    UIButton *button = [UIButton simpleWithRect:CGRectMake(0, 0, 44, 44)
                                      withTitle:LS_Text(@"Save")
                                withSelectTitle:LS_Text(@"Save")
                                      withColor:[UIColor clearColor]];
    button.titleColorNormal = UIColorFromHEX(0x169ad8);
    [button addTouchUpTarget:self action:@selector(clickConfirmButton:)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    item.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)loadRemindView
{
    _remindView = [[RemindView alloc] initWithFrame:CGRectMake(0, 10, self.width, 54 * 4)];
    [self addSubview:_remindView];
    DEF_WEAKSELF_(RemindVC);
    _remindView.tapBlock = ^(UIView *view, id object) {
        [weakSelf appearRemindPicker:object];
    };
    [_remindView updateContentWithModel:_remindModel];
    
    _confirmButton = [UIButton simpleWithRect:CGRectMake(0, _remindView.totalHeight + 30, self.width, 44)
                                    withTitle:LS_Text(@"Confirm")
                              withSelectTitle:LS_Text(@"Confirm")
                                    withColor:[UIColor whiteColor]];
    [_confirmButton addUpAndDownLine];
    _confirmButton.titleColorNormal = UIColorFromHEX(0x169ad8);
    [_confirmButton addTouchUpTarget:self action:@selector(clickConfirmButton:)];
    // [self addSubview:_confirmButton];
}

- (void)appearRemindPicker:(NSNumber *)number
{
    _currentIndex = [number integerValue];

    [_remindPicker updateContentForDatePicker: _currentIndex ? _remindModel.endTime : _remindModel.startTime
                                    withIndex:_currentIndex];
    
    [self controlRemindPickerHidden:NO];
}

- (void)controlRemindPickerHidden:(BOOL)isHidden
{
    CGRect rect = isHidden ?
    CGRectMake(0, self.view.height, self.width, 200) :
    CGRectMake(0, self.view.height - 200, self.width, 200);
    
    [UIView animateWithDuration:0.2 animations:^{
        _remindPicker.frame = rect;
    }];
 }

- (void)clickConfirmButton:(UIButton *)button
{
    [[UserInfoHelp sharedInstance] sendSetSedentariness:^(id object) {
        if ([object boolValue])
        {
            SHOWMBProgressHUD(LS_Text(@"Setting success"), nil, nil, NO, 2.0);
        }
        else
        {
            SHOWMBProgressHUD(LS_Text(@"Setting fail"), nil, nil, NO, 2.0);
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
    
    label.text = LS_Text(@"Sedentary remind");
    [label sizeToFit];
}

- (void)loadRemindPicker
{
    _remindPicker = [[RemindPicker alloc] initWithFrame:CGRectMake(0, self.view.height, self.width, 200)];
    
    [self addSubview:_remindPicker];
    DEF_WEAKSELF_(RemindVC);
    _remindPicker.cancelBlock = ^(UIView *view, id object) {
        [weakSelf updateContentForRemindView:nil];
    };
    _remindPicker.confirmBlock = ^(UIView *view, id object) {
        [weakSelf updateContentForRemindView:object];
    };
}

- (void)updateContentForRemindView:(NSDate *)date
{
    [self controlRemindPickerHidden:YES];
    
    if (date)
    {
        NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)date.hour,
                            (long)date.minute];
        [_remindView updateContentForLabelWithTime:string withIndex:_currentIndex];
    }
}

/*
- (void)updateContentForRemindView:(TimePickerView *)timePicker
{
    [self controlRemindPickerHidden:YES];
    
    if (timePicker)
    {
        NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)timePicker.hourOrder,
                            (long)timePicker.minutesOrder];
        [_remindView updateContentForLabelWithTime:string withIndex:_currentIndex];
    }
}
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch  =[touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(_remindView.textField.frame, point))
    {
        [self.view endEditing:YES];
    }
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
