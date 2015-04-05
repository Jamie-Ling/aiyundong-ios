//
//  BraceletInfoViewController.m
//  Woyoli
//
//  Created by jamie on 14-12-2.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//

#define vChangeToFT(A)  ((A / 30.48) + 1)   //CM - >转换为英尺
#define vChangeToLB(A)  (A * 2.2046226)  //KG - >转换为磅

#define vChangeToMI(A)  (A * 0.6213712)  //千米- 》英里


#define vBackToCM(A)  ((A - 1) * 30.48)   //CM - >转换为英尺
#define vBackToKG(A)  (A / 2.2046226)  //KG - >转换为磅

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
}
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation BraceletInfoViewController
@synthesize _thisBraceletInfoModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.title = _thisBraceletInfoModel._name;
    
    //名字写死
    self.title = @"爱运动手环";
    
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    //初始化
    //    _cellTitleArray = [NSArray arrayWithObjects:@"每日目标", @"自定义", @"", @"时间与闹钟", @"久坐提醒", @"防丢提醒", @"固件升级", @"恢复到默认设置", @"蓝牙手环信息设置", nil];
    
    _cellTitleArrayFor240 = [NSArray arrayWithObjects:@"每日目标", @"步距", @"佩戴方式", @"久座提醒", @"振动闹钟", @"", @"恢复到默认设置", @"解除绑定", nil];
    
    _cellTitleArrayFor240N = [NSArray arrayWithObjects:@"每日目标", @"步距", @"佩戴方式", @"久座提醒", @"振动闹钟", @"实时同步", @"固件升级", @"", @"恢复到默认设置", @"解除绑定", nil];
    
    _stepNumbersArray = [[NSMutableArray alloc] initWithCapacity:32];
    for (int i = vStepNumberMin; i <= vStepNumberMax; i++)
    {
        NSString *stepLongString = [NSString stringWithFormat:@"%d000 步", i];
        [_stepNumbersArray addObject:stepLongString];
    }
    
    
    NSString *longBack = @"cm";
    NSString *weightBack = @"kg";
    
    _isMetricSystem = YES;
    
    if ([[_userInfoDictionary objectForKey:kUserInfoOfIsMetricSystemKey] isEqualToString:@"0"])
    {
        longBack = @"ft";   //英寸
        weightBack = @"lb";  //磅
        _isMetricSystem = NO;
    }
    
    _stepLongMustableArray = [[NSMutableArray alloc] initWithCapacity:32];
    for (float i = vStepLongMin(_isMetricSystem); i <= vStepLongMax(_isMetricSystem); i = i + (_isMetricSystem ? 1 : 0.1))
    {
        NSString *stepLongString = [NSString stringWithFormat:@"%.0f %@", i, longBack];
        if (!_isMetricSystem)
        {
            stepLongString = [NSString stringWithFormat:@"%.1f %@", i, longBack];
        }
        [_stepLongMustableArray addObject:stepLongString];
    }
    
    //初始化为240N
    _cellTitleArray = _cellTitleArrayFor240N;
    
    [self addTableView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    //用户信息
    _userInfoDictionary = nil;
    _userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];
    
    if (!_userInfoDictionary)
    {
        NSLog(@"用户信息出错");
    }
    
    [self reloadMainPage];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //将要消失时更新存储
    [[BraceletInfoModel getUsingLKDBHelper] insertToDB:_thisBraceletInfoModel];
    
    [[UserInfoHelp sharedInstance] updateUserInfo:_thisBraceletInfoModel];
}


//刷新整个页面
- (void) reloadMainPage
{
        if ([BLTManager sharedInstance].connectState != BLTManagerConnected)
        {
            //没有连接设备
            _haveConect = NO;
    
            SHOWMBProgressHUD(@"没有链接设备.", @"无法设置", nil, NO, 2.0);       //提示要连接设备
            [self reloadUserInfoTableView];  //刷新UI
            return;
        }
    _haveConect = YES;
    
        if (![BLTManager sharedInstance].model.isNewDevice)
        {
            _is240N = NO;  //不是最新的240n
            _cellTitleArray = _cellTitleArrayFor240;
            [self reloadUserInfoTableView];  //刷新UI
            return;
        }
    
    _cellTitleArray = _cellTitleArrayFor240N;
    _is240N = YES;
    NSLog(@"在此请求是否有新固件版本，请求完后再做标记 _newVersionInfoModel,并刷新list");
    //假设有
    static BOOL have = YES;
    _haveNewVersion = have;
    _newVersionInfoModel = [[VersionInfoModel alloc] init];
    if (_haveNewVersion)
    {
        _newVersionInfoModel._versionID = @"VB 2.1.3";
        _newVersionInfoModel._versionSize = @"80KB";
        _newVersionInfoModel._versionUpdatInfo = @"本更新改进了算法，提升了精确度";
        
    }
    else
    {
        _newVersionInfoModel._versionID = _thisBraceletInfoModel._deviceVersion;
        _newVersionInfoModel._versionSize = @"";
        _newVersionInfoModel._versionUpdatInfo = @"已经是最新版本";
    }
    have = !have;
    
    [self reloadUserInfoTableView];
}

//设置前的准备---防止中间断开了
- (BOOL) readyForSet
{
    if ([BLTManager sharedInstance].connectState != BLTManagerConnected)
    {
        //没有连接设备
        _haveConect = NO;
        
        SHOWMBProgressHUD(@"没有链接设备.", @"无法设置", nil, NO, 2.0);       //提示要连接设备
        [self reloadUserInfoTableView];  //刷新UI
        return NO;
    }
    return YES;
}

- (void) reloadUserInfoTableView
{
    //    self.title = _thisBraceletInfoModel._name;
    
    //用户信息
    _userInfoDictionary = nil;
    _userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];
    
    if (!_userInfoDictionary)
    {
        NSLog(@"用户信息出错");
    }
    
    
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
    NSLog(@"设置每日目标");
    
    //    if (!_targetVC)
    //    {
    //        _targetVC = [[TargetViewController alloc] init];
    //    }
    //    _targetVC._thisModel = _thisBraceletInfoModel;
    //    [self.navigationController pushViewController:_targetVC animated:YES];
    //
    //
    //    return;
    //
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_stepNumbersArray];
    
    long lastIndex;
    NSInteger lastLong = _thisBraceletInfoModel._stepNumber / 1000;
    
    lastIndex = lastLong - vStepNumberMin;
    
    
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ cm", lastHeight];
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
                            
                            //先要改过来。。。
                            NSInteger old = _thisBraceletInfoModel._stepNumber;
                            _thisBraceletInfoModel._stepNumber = targetSums;
                            
                            [[UserInfoHelp sharedInstance] sendSetUserInfo:^(id object) {
                                if ([object boolValue])
                                {
                                    NSLog(@"更新步数成功");
//                                    _thisBraceletInfoModel._stepNumber = targetSums;
                                    
                                    //更新界面
                                    [self reloadUserInfoTableView];
                                }
                                else
                                {
                                    NSLog(@"更新步数失败");
                                    _thisBraceletInfoModel._stepNumber = old;
                                }
                            }];
                            /*
                            //生日
                            NSDate *theDate = [NSDate date];
                            NSString *birthdayString = [_userInfoDictionary objectForKey:kUserInfoOfAgeKey];
                            if (![NSString isNilOrEmpty:birthdayString ])
                            {
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                                [dateFormatter setTimeZone:timeZone];
                                theDate = [dateFormatter dateFromString:birthdayString];
                            }
                            
                            //体重
                            NSString *weight = [_userInfoDictionary objectForKey:kUserInfoOfWeightKey];
                            if ([NSString isNilOrEmpty:weight])
                            {
                                weight = @"50";
                            }
                            
                            //步长
                            NSString *height = [_userInfoDictionary objectForKey:kUserInfoOfStepLongKey];
                            if ([NSString isNilOrEmpty:height])
                            {
                                height = @"50";
                            }
                            
                            //步数
                            NSString *longString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[longString componentsSeparatedByString:@" "] firstObject];
                            NSInteger targetSums = [nowSelectedString integerValue];
                            
                            [BLTSendData sendUserInformationBodyDataWithBirthDay:theDate withWeight:[weight integerValue] * 100 withTarget:targetSums withStepAway:[height integerValue] withSleepTarget:8*60 withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                if (type == BLTAcceptDataTypeSetUserInfo)
                                {
                                    NSLog(@"更新步数成功");
                                    _thisBraceletInfoModel._stepNumber = targetSums;
                                    
                                    //更新界面
                                    [self reloadUserInfoTableView];
                                }
                                else
                                {
                                    NSLog(@"更新步数失败");
                                }
                            }];*/
                        }
                    }];
}

- (void) choiceHand
{
    NSLog(@"设置带左手还是右手");
    UIActionSheet * aciotnSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:@"左手"
                                                     otherButtonTitles:@"右手", nil];
    aciotnSheet.tag = vHandTag;
    [aciotnSheet showInView:self.view];
    
}

- (void) changeStepLong
{
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_stepLongMustableArray];
    
    long lastIndex;
    NSString *lastLong = [_userInfoDictionary objectForKey:kUserInfoOfStepLongKey];
    if ([NSString isNilOrEmpty:lastLong])
    {
        lastIndex = 50 - vStepLongMin(YES);
        if (!_isMetricSystem)
        {
            lastIndex = (int) (((int)vChangeToFT(50) - vStepLongMin(NO)) * 10);
        }
    }
    else
    {
        lastIndex= [lastLong integerValue] - vStepLongMin(YES);
        
        
        if (!_isMetricSystem)
        {
            lastIndex = (int) (([lastLong floatValue] - vStepLongMin(NO)) * 10);
            if (lastIndex < 0)
            {
                lastIndex = 0;
            }
            if (lastIndex > vHeightMax(NO) - vHeightMin(NO) + 1)
            {
                lastIndex = vHeightMax(NO) - vHeightMin(NO) + 1;
            }
            
        }
        else
        {
            if (lastIndex < 0)
            {
                lastIndex = 0;
            }
            if (lastIndex > vHeightMax(YES) - vHeightMin(YES) + 1)
            {
                lastIndex = vHeightMax(YES) - vHeightMin(YES) + 1;
            }
            
        }
    }
    
    
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ cm", lastHeight];
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
                            
                            //                            if (!_isMetricSystem)
                            //                            {
                            //                                nowSelectedString = [NSString stringWithFormat:@"%d", vBackToCM([nowSelectedString integerValue])];
                            //                            }
                            
                            //先要改过来。。。
                            [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfStepLongKey withValue:nowSelectedString];
                            
                            [[UserInfoHelp sharedInstance] sendSetUserInfo:^(id object) {
                                if ([object boolValue])
                                {
                                    NSLog(@"更新步长成功");
                                    //                                    _thisBraceletInfoModel._stepNumber = targetSums;
                                    
                                    //更新界面
                                    [self reloadUserInfoTableView];
                                }
                                else
                                {
                                    NSLog(@"更新步长失败");
                                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfStepLongKey withValue:lastLong];
                                }
                            }];

                            
                            
                            
                            [self reloadUserInfoTableView];
                            //                                }
                            //                                else
                            //                                {
                            //                                    NSLog(@"修改步长失败");
                            //                                }
                            //                            }];
                            
                        }
                    }];
}


- (void) goToCustom
{
    NSLog(@"设置自定义");
    
    if (!_customVC)
    {
        _customVC = [[CustomViewController alloc] init];
    }
    _customVC._thisModel = _thisBraceletInfoModel;
    [self.navigationController pushViewController:_customVC animated:YES];
}

- (void) goToTimeAndClock
{
    NSLog(@"设置时间和闹钟");
    
    if (!_timeAndClockVC)
    {
        _timeAndClockVC = [[TimeAndClockViewController alloc] init];
    }
    _timeAndClockVC._thisModel = _thisBraceletInfoModel;
    
    AlarmClockVC *alarmVC = [[AlarmClockVC alloc] init];
    
    [self.navigationController pushViewController:alarmVC animated:YES];
    
}

- (void) goToUpdateSystem
{
    NSLog(@"固件升级");
    
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
    NSLog(@"恢复默认设置");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"恢复到默认设置?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
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
        NSLog(@"更改久坐提醒的状态：%d", theSwitch.on);
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
        
//        [BLTSendData sendSedentaryRemindDataWithOpen:_thisBraceletInfoModel._longTimeSetRemind withTimes:[NSArray arrayWithObjects:oneClockBeginModel, oneClockOverModel, nil] withUpdateBlock:^(id object, BLTAcceptDataType type) {
//            if (type == BLTAcceptDataTypeSetSedentaryRemind)
//            {
//                NSLog(@"更新久坐提醒状态成功");
//            }
//            else
//            {
//                NSLog(@"更新久坐提醒状态失败");
//                theSwitch.on = !_thisBraceletInfoModel._longTimeSetRemind;
//                _thisBraceletInfoModel._longTimeSetRemind = theSwitch.on;
//            }
//        }];
        
        return;
    }
    //    if (theSwitch.tag == 5)
    //    {
    //        NSLog(@"更改防丢提醒的状态：%d", theSwitch.on);
    //        _thisBraceletInfoModel._PreventLossRemind = theSwitch.on;
    //
    //
    //        //。。。传输情况省略，暂无此交互
    //        return;
    //    }
    
    if (theSwitch.tag == 5)
    {
        
        NSLog(@"更改同步的状态：%d", theSwitch.on);
        
        
        _thisBraceletInfoModel._isSyn = theSwitch.on;
        
        if (theSwitch.on)
        {
            [[BLTRealTime sharedInstance] startRealTimeTransWithBackBlock:^(BOOL success) {
                if (!success)
                {
                    //                    [UIView showAlertView:@"打开同步失败" andMessage:nil];
                    theSwitch.on = !_thisBraceletInfoModel._isSyn;
                    _thisBraceletInfoModel._isSyn = theSwitch.on;
                    
                }
            }];
        }
        else
        {
            [[BLTRealTime sharedInstance] closeRealTimeTransWithBackBlock:^(BOOL success) {
                if (!success)
                {
                    //                    [UIView showAlertView:@"关闭同步失败" andMessage:nil];
                    theSwitch.on = !_thisBraceletInfoModel._isSyn;
                    _thisBraceletInfoModel._isSyn = theSwitch.on;
                    
                }
            }];
        }
    }
    
}

- (void) disConect
{
    NSLog(@"解除绑定");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定断开连接?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
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


#pragma mark ---------------- actionSheet delegate -----------------
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == vMetricSystemTag)
    {
        NSString __block *tempHeight = [_userInfoDictionary objectForKey:kUserInfoOfHeightKey];
        NSString __block *tempStepLong = [_userInfoDictionary objectForKey:kUserInfoOfStepLongKey];
        NSString __block *tempWeight = [_userInfoDictionary objectForKey:kUserInfoOfWeightKey];
        
        switch (buttonIndex)
        {
            case  0:
            {
                if (_thisBraceletInfoModel._isShowMetricSystem)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成公制");
                    _thisBraceletInfoModel._isShowMetricSystem = YES;
                }
            }
                break;
            case 1:
            {
                if (!_thisBraceletInfoModel._isShowMetricSystem)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成英制");
                    _thisBraceletInfoModel._isShowMetricSystem = NO;
                    
                }
            }
                break;
            case 2:
                return;
                break;
            default:
                break;
        }
        [BLTSendData sendBasicSetOfInformationData:_thisBraceletInfoModel._isShowMetricSystem withActivityTimeZone:8 withUpdateBlock:^(id object, BLTAcceptDataType type) {
            if (type == BLTAcceptDataTypeSetBaseInfo)
            {
                NSLog(@"设置公英制成功");
                [self reloadUserInfoTableView];
                if (_thisBraceletInfoModel._isShowMetricSystem)
                {
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfIsMetricSystemKey withValue:@"1"];
                    tempHeight = [NSString stringWithFormat:@"%.0f", vBackToCM([tempHeight floatValue])];
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfHeightKey withValue:tempHeight];
                    tempStepLong = [NSString stringWithFormat:@"%.0f", vBackToCM([tempStepLong floatValue])];
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfStepLongKey withValue:tempStepLong];
                    tempWeight= [NSString stringWithFormat:@"%.0f", vBackToKG([tempWeight integerValue])];
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfWeightKey withValue:tempWeight];
                }
                else
                {
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfIsMetricSystemKey withValue: @"0"];
                    
                    tempHeight = [NSString stringWithFormat:@"%.1f", vChangeToFT([tempHeight floatValue])];
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfHeightKey withValue:tempHeight];
                    tempStepLong = [NSString stringWithFormat:@"%.1f", vChangeToFT([tempStepLong floatValue])];
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfStepLongKey withValue:tempStepLong];
                    tempWeight= [NSString stringWithFormat:@"%.0f", vChangeToLB([tempWeight integerValue])];
                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfWeightKey withValue:tempWeight];
                }
            }
            else
            {
                NSLog(@"设置公英制失败");
                _thisBraceletInfoModel._isShowMetricSystem = !_thisBraceletInfoModel._isShowMetricSystem;
            }
        }];
        
        return;
    }
    if (actionSheet.tag == vHandTag)
    {
        switch (buttonIndex)
        {
            case  0:
            {
                if (_thisBraceletInfoModel._isLeftHand)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成左手");
                    _thisBraceletInfoModel._isLeftHand = YES;
                   
                    [[UserInfoHelp sharedInstance] sendSetAdornType:^(id object) {
                        if ([object boolValue])
                        {
                            NSLog(@"更新左手状态成功");
                        }
                        else
                        {
                            NSLog(@"更新左手状态失败");
                            _thisBraceletInfoModel._isLeftHand = NO;
                        }
                         [self reloadUserInfoTableView];
                    }];
                }
            }
                break;
            case 1:
            {
                if (!_thisBraceletInfoModel._isLeftHand)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成右手");
                    _thisBraceletInfoModel._isLeftHand = NO;
                    [[UserInfoHelp sharedInstance] sendSetAdornType:^(id object) {
                        if ([object boolValue])
                        {
                            NSLog(@"更新右手状态成功");
                        }
                        else
                        {
                            NSLog(@"更新右手状态失败");
                            _thisBraceletInfoModel._isLeftHand = YES;
                        }
                        [self reloadUserInfoTableView];
                    }];
                }
            }
                break;
            case 2:
                return;
                break;
            default:
                break;
        }
        return;
    }
    
    
    
}


#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"check index = %ld", (long)buttonIndex);
    if (buttonIndex == 1)
    {
        if (alertView.tag == 100861) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alert.tag = 100862;
            [alert show];
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
            
            NSString *stepLongString = [NSString stringWithFormat:@"%ld 步/天", (long)_thisBraceletInfoModel._stepNumber];
            [rightTitle setText:stepLongString];
            
            [rightTitle sizeToFit];
            [rightTitle setCenterY:vOneCellHeight / 2.0];
            [rightTitle setX: vOneCellWidth / 2.0 + 50];
            [oneCell.contentView addSubview:rightTitle];
            
            break;
        }
            
        case 1:
        {
            //步子
            NSString *stepLong = [_userInfoDictionary objectForKey:kUserInfoOfStepLongKey];
            
            NSString *stepLongString = [NSString stringWithFormat:@"%@ cm", stepLong];
            [rightTitle setText:stepLongString];
            
            [rightTitle sizeToFit];
            [rightTitle setCenterY:vOneCellHeight / 2.0];
            [rightTitle setX: vOneCellWidth / 2.0 + 50];
            [oneCell.contentView addSubview:rightTitle];
            
            break;
        }
            
        case 2:
        {
            //左右手
            NSString *show = @"左手";
            if (!_thisBraceletInfoModel._isLeftHand)
            {
                show = @"右手";
            }
            
            
            [rightTitle setText:show];
            
            [rightTitle sizeToFit];
            [rightTitle setCenterY:vOneCellHeight / 2.0];
            [rightTitle setX: vOneCellWidth / 2.0 + 50];
            [oneCell.contentView addSubview:rightTitle];
            
            break;
        }
            
        case 3:
        {
            if (_thisBraceletInfoModel._is24HoursTime)
            {
                [rightTitle setText:kBraceletLongSetRemind24];
            }
            else
            {
                [rightTitle setText:kBraceletLongSetRemind];
            }
            [rightTitle setNumberOfLines:1];
            
            [rightTitle setCenter:CGPointMake(vOneCellWidth / 2.0, vOneCellHeight / 2.0)];
            [oneCell.contentView addSubview:rightTitle];
            
            slideSwitchH.on = _thisBraceletInfoModel._longTimeSetRemind;
            [oneCell.contentView addSubview:slideSwitchH];
            
            [rightImageView setHidden:YES];
            
            oneCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
            break;
        case 5:
        {
            if (_is240N)
            {
                slideSwitchH.on = _thisBraceletInfoModel._PreventLossRemind;
                [oneCell.contentView addSubview:slideSwitchH];
                
                [rightImageView setHidden:YES];
                
                oneCell.selectionStyle =  UITableViewCellSelectionStyleNone;
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
                [rightTitle setX: vOneCellWidth / 2.0 + 50];
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
                }
                else
                {
                    _badgeView.hidden = NO;
                    _badgeView.badgeText = @"1";
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
        }
        else
    {
        oneCell.userInteractionEnabled = YES;
        [oneCell.contentView setBackgroundColor:kBackgroundColor];
    }
    
    //设置点选颜色
    //    [oneCell setSelectedBackgroundView:[[UIView alloc] initWithFrame:oneCell.frame]];
    //    //kHexRGB(0x0e822f)
    //    oneCell.selectedBackgroundView.backgroundColor = kHexRGBAlpha(0x0e822f, 0.6);
    //
    return oneCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击第%ld行",  (long)indexPath.row);
    //去除点击的选中色
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    
    if (![self readyForSet])
    {
        return;
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



@end
