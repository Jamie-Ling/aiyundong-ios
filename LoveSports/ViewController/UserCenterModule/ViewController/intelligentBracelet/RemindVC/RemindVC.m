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
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    [self loadTitleView];
    [self loadRemindView];
    [self loadRemindPicker];
}

- (void)loadRemindView
{
    _remindView = [[RemindView alloc] initWithFrame:CGRectMake(6, 20, self.width - 12, 44 * 4)];
    [self addSubview:_remindView];
    DEF_WEAKSELF_(RemindVC);
    _remindView.tapBlock = ^(UIView *view, id object) {
        [weakSelf appearRemindPicker:object];
    };
    [_remindView updateContentWithModel:_remindModel];
    
    _confirmButton = [UIButton simpleWithRect:CGRectMake((self.width - 80) / 2, _remindView.totalHeight + 30, 80, 44)
                                    withTitle:@"确定"
                              withSelectTitle:@"确定"
                                    withColor:[UIColor yellowColor]];
    [_confirmButton addTouchUpTarget:self action:@selector(clickConfirmButton:)];
    [self addSubview:_confirmButton];
    _confirmButton.backgroundColor = [UIColor greenColor];
    _confirmButton.layer.cornerRadius = 6.0;
}

- (void)appearRemindPicker:(NSNumber *)number
{
    _currentIndex = [number integerValue];

    [_remindPicker updateContentForDatePicker: _currentIndex ? _remindModel.endTime : _remindModel.startTime];
    
    [self controlRemindPickerHidden:NO];
}

- (void)controlRemindPickerHidden:(BOOL)isHidden
{
    CGRect rect = isHidden ?
    CGRectMake(0, self.height, self.width, 300) :
    CGRectMake(0, self.height - 300, self.width, 300);
    
    [UIView animateWithDuration:0.2 animations:^{
        _remindPicker.frame = rect;
    }];
 }

- (void)clickConfirmButton:(UIButton *)button
{
    [[UserInfoHelp sharedInstance] sendSetSedentariness:^(id object) {
        if ([object boolValue])
        {
            SHOWMBProgressHUD(@"设置成功.", nil, nil, NO, 2.0);
        }
        else
        {
            SHOWMBProgressHUD(@"设置失败.", nil, nil, NO, 2.0);
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
    
    label.text = @"久坐提醒";
    [label sizeToFit];
}

- (void)loadRemindPicker
{
    _remindPicker = [[RemindPicker alloc] initWithFrame:CGRectMake(0, self.height, self.width, 300)];
    
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
        NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)date.hour, (long)date.minute];
        [_remindView updateContentForLabelWithTime:string withIndex:_currentIndex];
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
