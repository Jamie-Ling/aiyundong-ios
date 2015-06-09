//
//  BraceletInfoViewController.m
//  Woyoli
//
//  Created by jamie on 14-12-2.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//

#define vMetricSystemTag   10099
#define vHandTag   10100

#define vSyncTag   10101  // 同步

#define vStepNumberMin   5
#define vStepNumberMax  30

#define vGenderChoiceAciotnSheetTag  1234   //性别选择sheet  Tag
#define vPhotoGetAciotnSheetTag    1235  //相片选择sheet  tag

#define v_signOutButtonHeight (kIPhone4s ? 45 : 55.0 ) //退出按钮高度

#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vTableViewMoveLeftX 0  //tableview向左移20
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

//#define vHeightMin   60
//#define vHeightMax   220
//
//#define vWeightMin   20
//#define vWeightMax   250

#import "BraceletInfoViewController.h"

#import "TargetViewController.h"
#import "CustomViewController.h"
#import "TimeAndClockViewController.h"
#import "JSBadgeView.h"
#import "VersionInfoModel.h"
#import "DeviceUpdateViewController.h"
#import "TestBLTViewController.h"
#import "AlarmClockVC.h"
#import "BSModalPickerView.h"
#import "UserInfoViewController.h"
#import "UserInfoHelp.h"
#import "RemindVC.h"
#import "BLTDFUBaseInfo.h"

@interface BraceletInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    
    NSArray *_cellTitleArray;
    
    NSArray *_cellTitleArrayFor240;
    NSArray *_cellTitleArrayFor240N;
    
    UITableView *_listTableView;
    
    BOOL _haveNewVersion;   //是否有新版本
    
    TargetViewController *_targetVC;
    CustomViewController *_customVC;
    TimeAndClockViewController *_timeAndClockVC;
    DeviceUpdateViewController *_deviceUpdateVC;
    
    JSBadgeView *_badgeView;   //新礼物标记
    VersionInfoModel *_newVersionInfoModel;
    TestBLTViewController *_testBLTVC;
    
    NSMutableArray *_stepNumbersArray;
    
    BOOL _haveConect;  //是否已经连接
    BOOL _is240N; //是否是最新的240N
    
    NSDictionary *_userInfoDictionary;
    NSMutableArray *_stepLongMustableArray;
    BOOL _isMetricSystem;
    
    UILabel *_notConectLabel;
}


@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UISwitch *realTimeSwitch;

@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, strong) BLTModel *braceModel;

@end

@implementation BraceletInfoViewController
@synthesize _thisBraceletInfoModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.title = _thisBraceletInfoModel._name;
    
    //名字写死
    self.title = LS_Text(@"Isport bracelet");
    
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back")
                                                                                    target:self
                                                                                  selector:@selector(goBackPrePage)
                                                                                 ImageName:@""];
    
    _userInfo = [UserInfoHelp sharedInstance].userModel;
    _braceModel = [UserInfoHelp sharedInstance].braceModel;

    _cellTitleArrayFor240 = [NSArray arrayWithObjects:LS_Text(@"Daily Goals"), LS_Text(@"Stride Length"),
                             LS_Text(@"Wearing info"), LS_Text(@"Sedentary remind"),
                             LS_Text(@"Vibration Alarm"), @"",
                             LS_Text(@"Reset All Settings"), LS_Text(@"Unpair"), nil];
    
    _cellTitleArrayFor240N = [NSArray arrayWithObjects:LS_Text(@"Daily Goals"), LS_Text(@"Stride Length"),
                              LS_Text(@"Wearing info"), LS_Text(@"Sedentary remind"),
                              LS_Text(@"Vibration Alarm"), LS_Text(@"Real-time synchronization"),
                              LS_Text(@"Firmware update"), @"",
                              LS_Text(@"Reset All Settings"), LS_Text(@"Unpair"), nil];
    
    _stepNumbersArray = [[NSMutableArray alloc] initWithCapacity:32];
    _stepLongMustableArray = [[NSMutableArray alloc] initWithCapacity:32];
    
    //初始化为240N
    _is240N =  _braceModel.isNewDevice;
    _cellTitleArray = _is240N ? _cellTitleArrayFor240N : _cellTitleArrayFor240;
    
    [self addTableView];
    [self addDidnotConectLabel];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self reloadMainPage];
    
    DEF_WEAKSELF_(BraceletInfoViewController);
    [BLTRealTime sharedInstance].realTimeBlock = ^(BOOL success) {
        [weakSelf notifiRealTimeSwitchState:YES];
    };
    [BLTManager sharedInstance].connectBlock = ^() {
        [weakSelf refreshTableView:YES];
    };
    [BLTManager sharedInstance].disConnectBlock = ^() {
        [weakSelf refreshTableView:NO];
    };
}

- (void)refreshTableView:(BOOL)isAllow
{
    [self reloadMainPage];

    [_listTableView reloadData];
    [_notConectLabel setHidden:isAllow];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTRealTime sharedInstance].realTimeBlock = nil;
    [BLTManager sharedInstance].connectBlock = nil;
    [BLTManager sharedInstance].disConnectBlock = nil;
}

//刷新整个页面
- (void) reloadMainPage
{
    _braceModel = [UserInfoHelp sharedInstance].braceModel;
    _is240N = _braceModel.isNewDevice;
    _cellTitleArray = _is240N ? _cellTitleArrayFor240N : _cellTitleArrayFor240;

    if ([BLTManager sharedInstance].model.peripheral.state != CBPeripheralStateConnected)
    {
        //没有连接设备
        _haveConect = NO;
        [_notConectLabel setHidden:NO];
        [self reloadUserInfoTableView];  //刷新UI
        return;
    }
    
    [_notConectLabel setHidden:YES];
    _haveConect = YES;
    
    if (![BLTManager sharedInstance].model.isNewDevice)
    {
        [self reloadUserInfoTableView];  //刷新UI
        
        return;
    }
    
    // NSLog(@"..%d..%d", [BLTManager sharedInstance].model.firmVersion, [BLTDFUBaseInfo sharedInstance].zipVersion);
    //假设有
    _haveNewVersion = [BLTManager sharedInstance].model.firmVersion < [BLTDFUBaseInfo sharedInstance].zipVersion;
    _newVersionInfoModel = [[VersionInfoModel alloc] init];
    
    [self reloadUserInfoTableView];
}

//设置前的准备---防止中间断开了
- (BOOL) readyForSet
{
    if ([BLTManager sharedInstance].model.peripheral.state != CBPeripheralStateConnected)
    {
        _haveConect = NO;
        [_notConectLabel setHidden:NO];
        [self reloadUserInfoTableView];  //刷新UI
        return NO;
    }
    
    [_notConectLabel setHidden:YES];
    _haveConect = YES;
    return YES;
}

- (void) reloadUserInfoTableView
{
    [_listTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- 页面布局 -----------------
- (void) addTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, vTableViewLeaveTop, vOneCellWidth, kScreenHeight - vTableViewLeaveTop) style:UITableViewStylePlain];
    
    [_listTableView setBackgroundColor:kBackgroundColor];
    [[ObjectCTools shared] setExtraCellLineHidden:_listTableView];
    [_listTableView setDelegate:self];
    [_listTableView setDataSource:self];
    _listTableView.center = CGPointMake(_listTableView.centerX - vTableViewMoveLeftX, _listTableView.centerY);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _listTableView.separatorColor = kHoldPlacerColor;
    [self.view addSubview:_listTableView];
    
    //解决分割线左侧短-1
    if ([_listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_listTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) goToTarget
{
    [_stepNumbersArray removeAllObjects];
    for (int i = 1; i <= 300; i++)
    {
        NSString *stepLongString = [NSString stringWithFormat:@"%d %@", i * 100, LS_Text(@"steps")];
        [_stepNumbersArray addObject:stepLongString];
    }
    
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_stepNumbersArray];
    
    NSInteger lastIndex = (_userInfo.targetSteps - 100) / 100;
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ cm", lastHeight];
    
    DEF_WEAKSELF_(BraceletInfoViewController);
    [pickerView presentInView:self.view
                    withBlock:^(BOOL madeChoice) {
                        if (madeChoice) {
                            if (pickerView.selectedIndex == lastIndex)
                            {
                                NSLog(@"未做修改");
                                return;
                            }
                            
                            //步数
                            NSString *longString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[longString componentsSeparatedByString:@" "] firstObject];
                            NSInteger targetSums = [nowSelectedString integerValue];
                            
                            weakSelf.userInfo.targetSteps = targetSums;
                            
                            [[UserInfoHelp sharedInstance] sendSetUserInfo:^(id object) {
                                if ([object boolValue])
                                {
                                    SHOWMBProgressHUD(LS_Text(@"Setting success"), nil, nil, NO, 2.0);
                                    
                                    // 旧设备需要清除之前的数据.
                                    [[BLTSendOld sharedInstance] delaySendOldDeleteSportData];
                                }
                            }];
                            
                            [weakSelf.listTableView reloadData];
                        }
                    }];
}

- (void) choiceHand
{
    NSLog(@"设置带左手还是右手");
    UIActionSheet * aciotnSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:LS_Text(@"Cancel")
                                                destructiveButtonTitle:LS_Text(@"Right hand")
                                                     otherButtonTitles:LS_Text(@"Left hand"), nil];
    aciotnSheet.tag = vHandTag;
    [aciotnSheet showInView:self.view];
}

- (void) changeStepLong
{
    [_stepLongMustableArray removeAllObjects];
    
    for (float i = 30; i <= 150; i++)
    {
        NSString *stepLongString;
        if (_userInfo.isMetricSystem)
        {
            stepLongString = [NSString stringWithFormat:@"%.f cm", i];
        }
        else
        {
            stepLongString = [NSString stringWithFormat:@"%0.2f in",CMChangeToIN(i)];
        }
        [_stepLongMustableArray addObject:stepLongString];
    }
    
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_stepLongMustableArray];
    
    NSInteger lastIndex  = _userInfo.step - 30;
    
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ cm", lastHeight];
    
    DEF_WEAKSELF_(BraceletInfoViewController);
    [pickerView presentInView:self.view
                    withBlock:^(BOOL madeChoice) {
                        if (madeChoice) {
                            if (pickerView.selectedIndex == lastIndex)
                            {
                                NSLog(@"未做修改");
                                return;
                            }
                            
                            //                            [BraceletInfoModel updateUserInfoToBLTWithUserInfo:_userInfoDictionary withnewestModel:_thisModel WithSuccess:^(bool success) {
                            //                                if (success)
                            //                                {
                            NSLog(@"发送修改步长信息的请求吧");
                            NSString *longString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[longString componentsSeparatedByString:@" "] firstObject];
                            
                            _userInfo.step = weakSelf.userInfo.isMetricSystem ?
                            [nowSelectedString integerValue] :
                            INBackToCM([nowSelectedString floatValue]);
                            
                            [[UserInfoHelp sharedInstance] sendSetUserInfo:^(id object) {
                                if ([object boolValue])
                                {
                                    SHOWMBProgressHUD(LS_Text(@"Setting success"), nil, nil, NO, 2.0);
                                    
                                    // 旧设备需要清除之前的数据.
                                    [[BLTSendOld sharedInstance] delaySendOldDeleteSportData];
                                }
                            }];
                            
                            [weakSelf.listTableView reloadData];
                        }
                    }];
}

- (void) goToCustom
{
    if (!_customVC)
    {
        _customVC = [[CustomViewController alloc] init];
    }
    _customVC._thisModel = _thisBraceletInfoModel;
    [self.navigationController pushViewController:_customVC animated:YES];
}

- (void) goToTimeAndClock
{
    AlarmClockVC *alarmVC = [[AlarmClockVC alloc] initWithAlarmClock:_braceModel.alarmArray];
    [self.navigationController pushViewController:alarmVC animated:YES];
}

- (void) goToUpdateSystem
{
    if (!_deviceUpdateVC)
    {
        _deviceUpdateVC = [[DeviceUpdateViewController alloc] init];
    }
    _deviceUpdateVC._thisBraceletInfoModel = _thisBraceletInfoModel;
    _deviceUpdateVC._thisVersionInfoModel = _newVersionInfoModel;
    [self.navigationController pushViewController:_deviceUpdateVC animated:YES];
    
}

- (void) goToRecoverDefaultSet
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:[NSString stringWithFormat:@"%@?", LS_Text(@"Reset All Settings")]
                                                  delegate:self
                                         cancelButtonTitle:LS_Text(@"Cancel")
                                         otherButtonTitles:LS_Text(@"Confirm") ,nil];
    [alert setTag:100861];
    [alert show];
}

- (void) changeSwith:(UISwitch *) theSwitch
{
    if (![self readyForSet])
    {
        return;
    }
    
    if (theSwitch.tag == 3)
    {
        _thisBraceletInfoModel._longTimeSetRemind = theSwitch.on;
        
        AlarmClockModel *oneClockBeginModel = [[AlarmClockModel alloc] init];
        [oneClockBeginModel setAllTimeFromTimeString:kBraceletLongSetBeginTime withRepeatUntStringArray:nil withFullWeekDay:YES];
        
        AlarmClockModel *oneClockOverModel = [[AlarmClockModel alloc] init];
        [oneClockOverModel setAllTimeFromTimeString:kBraceletLongSetOverTime24 withRepeatUntStringArray:nil withFullWeekDay:YES];
        
        [[UserInfoHelp sharedInstance] sendSetSedentariness:^(id object) {
            if ([object boolValue])
            {
                NSLog(@"更新久坐提醒状态成功");
            }
            else
            {
                NSLog(@"更新久坐提醒状态失败");
                theSwitch.on = !_thisBraceletInfoModel._longTimeSetRemind;
                _thisBraceletInfoModel._longTimeSetRemind = theSwitch.on;
            }
        }];
        
        return;
    }

    if (theSwitch.tag == 5)
    {
        DEF_WEAKSELF_(BraceletInfoViewController);
        if (theSwitch.on)
        {
            [[BLTRealTime sharedInstance] startRealTimeTransWithBackBlock:^(BOOL success) {
                if (success)
                {
                    SHOWMBProgressHUD(LS_Text(@"Setting success"), nil, nil, NO, 2.0);
                }
                else
                {
                    SHOWMBProgressHUD(LS_Text(@"Setting fail"), nil, nil, NO, 2.0);
                    weakSelf.realTimeSwitch.on = NO;
                }
            }];
        }
        else
        {
            [[BLTRealTime sharedInstance] closeRealTimeTransWithBackBlock:^(BOOL success) {
                if (success)
                {
                    SHOWMBProgressHUD(LS_Text(@"Setting success"), nil, nil, NO, 2.0);
                }
                else
                {
                    SHOWMBProgressHUD(LS_Text(@"Setting fail"), nil, nil, NO, 2.0);
                    weakSelf.realTimeSwitch.on = YES;
                }
            }];
        }
    }
    
}

- (void)notifiRealTimeSwitchState:(BOOL)isOn
{
    if (isOn)
    {
        _realTimeSwitch.on = YES;
    }
}

- (void) disConect
{
    NSLog(@"解除绑定");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:[NSString stringWithFormat:@"%@?", LS_Text(@"Unpair")]
                                                  delegate:self
                                         cancelButtonTitle:LS_Text(@"Cancel")
                                         otherButtonTitles:LS_Text(@"Confirm") ,nil];
    [alert setTag:100962];
    [alert show];
    
}

- (void) testBLT
{
    if (!_testBLTVC)
    {
        _testBLTVC = [[TestBLTViewController alloc] init];
    }
    [self.navigationController pushViewController:_testBLTVC animated:YES];
}


#pragma mark --------------- actionSheet delegate -----------------
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == vHandTag)
    {
        if (buttonIndex != 2)
        {
            _braceModel.isLeftHand = buttonIndex;
            
            // DEF_WEAKSELF_(BraceletInfoViewController);
            [[UserInfoHelp sharedInstance] sendSetAdornType:^(id object) {
                [NSObject showMessageOnMain:object];
            }];
            
            [_listTableView reloadData];
        }
    }
}

#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"check index = %ld", (long)buttonIndex);
    if (buttonIndex == 1)
    {
        if (alertView.tag == 100861) {
            /*
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alert.tag = 100862;
            [alert show];
             */
            
            [_userInfo restoreToDefaultSettings];
            [[UserInfoHelp sharedInstance] sendSetUserInfo:^(id object) {
                if ([object boolValue])
                {
                    SHOWMBProgressHUD(LS_Text(@"Setting success"), nil, nil, NO, 2.0);
                    
                    // 旧设备需要清除之前的数据.
                    [[BLTSendOld sharedInstance] delaySendOldDeleteSportData];
                }
            }];

            [_listTableView reloadData];

            return;
        }
        if (alertView.tag == 100862) {
            //得到输入框
            UITextField *tf=[alertView textFieldAtIndex:0];
            if ([NSString isNilOrEmpty:tf.text])
            {
                [UIView showAlertView:@"密码不能为空" andMessage:@"校验身份失败"];
                return;
            }
            NSLog(@"发送请求校验身份吧，密码为  %@", tf.text);
            
            [BLTSendData sendSetFactoryModelDataWithUpdateBlock:^(id object, BLTAcceptDataType type) {
                if (type == BLTAcceptDataTypeSetFactoryModel)
                {
                    [UIView showAlertView:@"恢复到默认设置成功" andMessage:nil];
                    [_thisBraceletInfoModel initAllSet];  //初始化所有设置
                    
                    [_thisBraceletInfoModel setNameAndSaveToDB];
                    
                    [self reloadUserInfoTableView];
                }
                else
                {
                    [UIView showAlertView:@"恢复到默认设置失败" andMessage:nil];
                }
            }];
            
            return;
        }
        if (alertView.tag == 100962)
        {
            BLTModel *model = [BLTManager sharedInstance].model;
            if (model)
            {
                model.isBinding = NO;
            }

            [[BLTManager sharedInstance] dismissLink];
            
            //刷新整个页面
            [self reloadMainPage];
            
            return;
        }
    }
}

#pragma mark ---------------- TableView delegate -----------------

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellTitleArray count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //不使用复用机制
    UITableViewCell *oneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    if ([NSString isNilOrEmpty:[_cellTitleArray objectAtIndex:indexPath.row]])
    {
        oneCell.userInteractionEnabled = NO;
        return oneCell;
    }
    
    //label
    CGRect titleFrame = CGRectMake(0, 0, 100, vOneCellHeight);
    UILabel *title = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                 backgroundColor:[UIColor clearColor]
                                                            text:[_cellTitleArray objectAtIndex:indexPath.row]
                                                       textColor:kLabelTitleDefaultColor
                                                            font:[UIFont systemFontOfSize:14]
                                                   textAlignment:NSTextAlignmentLeft
                                                   lineBreakMode:0
                                                   numberOfLines:1];
    [title sizeToFit];
    title.center = CGPointMake(vTableViewMoveLeftX + 16.0 + title.width / 2.0, vOneCellHeight / 2.0);
    [oneCell.contentView addSubview:title];
    
    //右侧箭头
    UIImageView *rightImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vOneCellWidth - vOneCellHeight / 2.0 + 2, vOneCellHeight / 2.0) withImageName:@"右箭头" withImageZoomSize:1.0];
    [oneCell.contentView addSubview:rightImageView];
    
    
    //右侧titlelable
    UILabel *rightTitle = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                      backgroundColor:[UIColor clearColor]
                                                                 text:@""
                                                            textColor:kRGBAlpha(0, 0, 0, 0.5)
                                                                 font:[UIFont systemFontOfSize:12]
                                                        textAlignment:NSTextAlignmentCenter
                                                        lineBreakMode:NSLineBreakByCharWrapping
                                                        numberOfLines:2];
    
    [rightTitle setWidth:rightImageView.x - title.right - 2 - 18];
    //    NSLog(@"lent = %f", rightTitle.width);
    
    UISwitch *slideSwitchH = [[UISwitch alloc]init];
    [slideSwitchH setFrame:CGRectMake(0, 0, 164.0, 26.0)];
    slideSwitchH.center = CGPointMake(rightImageView.centerX  - slideSwitchH.width / 2.0, vOneCellHeight / 2.0);
    [slideSwitchH setOnTintColor:kButtonBackgroundColor];
    slideSwitchH.tag = indexPath.row;
    [slideSwitchH addTarget:self action:@selector(changeSwith:) forControlEvents:UIControlEventValueChanged];
    
    
    switch (indexPath.row)
    {
        case 0:
        {
            //目标
            
            NSString *stepLongString = [NSString stringWithFormat:@"%ld %@", (long)_userInfo.targetSteps, LS_Text(@"steps per day")];
            [rightTitle setText:stepLongString];
            
            [rightTitle sizeToFit];
            [rightTitle setCenterY:vOneCellHeight / 2.0];
            [rightTitle setX: vOneCellWidth / 2.0 + 40];
            [oneCell.contentView addSubview:rightTitle];
            
            break;
        }
            
        case 1:
        {
            //步子
            [rightTitle setText:_userInfo.showStep];
            
            [rightTitle sizeToFit];
            [rightTitle setCenterY:vOneCellHeight / 2.0];
            [rightTitle setX: vOneCellWidth / 2.0 + 40];
            [oneCell.contentView addSubview:rightTitle];
            
            break;
        }
            
        case 2:
        {
            //左右手
            NSString *show =  _braceModel.isLeftHand ? LS_Text(@"Left hand") : LS_Text(@"Right hand");
    
            [rightTitle setText:show];
            
            [rightTitle sizeToFit];
            [rightTitle setCenterY:vOneCellHeight / 2.0];
            [rightTitle setX: vOneCellWidth / 2.0 + 40];
            [oneCell.contentView addSubview:rightTitle];
            
            break;
        }
            
        case 3:
        {
            oneCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
            break;
        case 5:
        {
            if (_is240N)
            {
                slideSwitchH.on = _braceModel.isRealTime;
                
                // NSLog(@"isRealTime..%d", _braceModel.isRealTime);
                [oneCell.contentView addSubview:slideSwitchH];
                
                [rightImageView setHidden:YES];
                
                oneCell.selectionStyle =  UITableViewCellSelectionStyleNone;
                
                _realTimeSwitch = slideSwitchH;
            }
        }
            break;
        case 6:
        {
            if (_is240N)
            {
                [rightTitle setText:_thisBraceletInfoModel._deviceVersion];
                
                [rightTitle sizeToFit];
                [rightTitle setCenterY:vOneCellHeight / 2.0];
                [rightTitle setX: vOneCellWidth / 2.0 + 40];
                [oneCell.contentView addSubview:rightTitle];
                
                //添加未读标记
                _badgeView = [[JSBadgeView alloc] initWithParentView:rightImageView alignment:JSBadgeViewAlignmentTopLeft];;
                [_badgeView setBadgePositionAdjustment:CGPointMake(_badgeView.x - 20 , _badgeView.y + 6)];
                [_badgeView setBadgeBackgroundColor:[UIColor redColor]];
                //    [_badgeView setBadgeStrokeWidth:3.5];
                [_badgeView setBadgeTextFont:[UIFont systemFontOfSize:10]];
                [_badgeView setBadgeTextColor:[UIColor blackColor]];
                [_badgeView setUserInteractionEnabled:NO];
                
                if (!_haveNewVersion)
                {
                    _badgeView.hidden = YES;
                    rightImageView.hidden = YES;
                }
                else
                {
                    _badgeView.hidden = NO;
                    _badgeView.badgeText = @"1";
                    rightImageView.hidden = NO;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    if (!_haveConect)
    {
        oneCell.userInteractionEnabled = NO;
        [oneCell.contentView setBackgroundColor:kRGBAlpha(243.0, 243.0, 243.0, 0.5)];
        slideSwitchH.userInteractionEnabled = NO;
    }
    else
    {
        oneCell.userInteractionEnabled = YES;
        [oneCell.contentView setBackgroundColor:kBackgroundColor];
        slideSwitchH.userInteractionEnabled = YES;
        
        if (indexPath.row == 6 && _is240N)
        {
            if (!_haveNewVersion)
            {
                oneCell.userInteractionEnabled = NO;
            }
        }
    }

    return oneCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击第%ld行",  (long)indexPath.row);
    //去除点击的选中色
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    if (![self readyForSet])
    {
        //  return;
    }
    
    if (_is240N)
    {
        switch (indexPath.row )
        {
            case 0:
                [self goToTarget];
                break;
            case 1:
                //            [self goToCustom];
                [self changeStepLong];
                break;
                
            case 2:
                [self choiceHand];
                break;
                
            case 3:
                [self goToSetRemindVC];
                break;
                
            case 4:
                [self goToTimeAndClock];
                break;
                
            case 6:
                [self goToUpdateSystem];
                break;
            case 7:
                [self goToRecoverDefaultSet];
                break;
            case 8:
                [self goToRecoverDefaultSet];
                break;
            case 9:
                [self disConect];
                break;
            default:
                break;
        }
        
    }
    else
    {
        switch (indexPath.row )
        {
            case 0:
                [self goToTarget];
                break;
            case 1:
                //            [self goToCustom];
                [self changeStepLong];
                break;
                
            case 2:
                [self choiceHand];
                break;
                
            case 3:
                [self goToSetRemindVC];
                break;
                
            case 4:
                [self goToTimeAndClock];
                break;
            case 6:
                [self goToRecoverDefaultSet];
                break;
            case 7:
                [self disConect];
                break;
            default:
                break;
        }
        
    }
}

#pragma --- 久坐提醒. ---
- (void)goToSetRemindVC
{
    RemindVC *remindVC = [[RemindVC alloc] initWithRemind:[_braceModel.remindArray lastObject]];
    
    [self.navigationController pushViewController:remindVC animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NSString isNilOrEmpty:[_cellTitleArray objectAtIndex:indexPath.row]])
    {
        return 10.0;
    }
    return vOneCellHeight;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"";
    }
    return nil;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *backGroundColor = kBackgroundColor;
    if ([NSString isNilOrEmpty:[_cellTitleArray objectAtIndex:indexPath.row]])
    {
        backGroundColor = kRGB(243.0, 243.0, 243.0);
    }
    
    [cell setBackgroundColor:backGroundColor];
    
    //解决分割线左侧短-2
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark ---------------- 未连接相关 -----------------
/**
 *  添加未连接的按钮
 */
- (void) addDidnotConectLabel
{
    CGRect titleFrame = CGRectMake(0, 0, kButtonDefaultWidth, 35);
    _notConectLabel = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                  backgroundColor:[UIColor blackColor]
                                                             text:LS_Text(@"No connection, can't be set")
                                                        textColor:[UIColor whiteColor]
                                                             font:[UIFont boldSystemFontOfSize:15]
                                                    textAlignment:NSTextAlignmentCenter
                                                    lineBreakMode:0
                                                    numberOfLines:0];
    [_notConectLabel.layer setBorderColor:[[UIColor redColor] CGColor] ];
    [_notConectLabel.layer setCornerRadius:5.0];
    [_notConectLabel.layer setMasksToBounds:YES];
//    [_notConectLabel sizeToFit];
    [_notConectLabel setCenter:CGPointMake(kScreenWidth / 2.0, self.view.height - 35 - _notConectLabel.height  - kNavigationBarHeight + LS_NavBarOffset)];
    [self.view addSubview:_notConectLabel];
    
    [_notConectLabel setHidden:YES];
}



@end
