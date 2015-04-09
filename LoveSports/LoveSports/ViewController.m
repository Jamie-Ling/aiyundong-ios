//
//  ViewController.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//
//  用户信息完善

#define vGenderChoiceAciotnSheetTag  1234   //性别选择sheet  Tag
#define vPhotoGetAciotnSheetTag    1235  //相片选择sheet  tag

#define vMetricSystemTag   10099

#define v_signOutButtonHeight (kIPhone4s ? 45 : 55.0 ) //退出按钮高度

#define vTableViewLeaveTop   108   //tableView距离顶部的距离

#define vTableViewMoveLeftX 0  //tableview向左移20
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#define vChangeToFT(A)  (A / 30.48) + 1   //CM - >转换为英尺
#define vChangeToLB(A)  A * 2.2046226  //KG - >转换为磅


#import "FlatRoundedButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"
#import "UserInfoViewController.h"
#import "BSModalDatePickerView.h"
#import "BSModalPickerView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    NSArray *_cellTitleArray;
    NSArray *_cellTitleKeyArray;
    
    NSMutableArray *_heightMutableArray;
    NSMutableArray *_weightMutableArray;
    NSMutableArray *_stepLongMustableArray;
    
    NSDictionary *_userInfoDictionary;
    UITableView *_listTableView;
    BOOL _isMetricSystem;
    FlatRoundedButton *_userImageButton;
    
}
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置个人信息";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    //    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:@"完成" target:self selector:@selector(complete) ImageName:@""];
    //初始化
    _cellTitleArray = [NSArray arrayWithObjects:@"出生日期", @"性别", @"公/英制", @"身高", @"体重", @"经常活动地时区", nil];
    _cellTitleKeyArray = [NSArray arrayWithObjects:kUserInfoOfAgeKey, kUserInfoOfSexKey, kUserInfoOfIsMetricSystemKey, kUserInfoOfHeightKey, kUserInfoOfWeightKey, kUserInfoOfAreaKey, nil];
    
    
    _weightMutableArray = [[NSMutableArray alloc] initWithCapacity:32];
    _heightMutableArray = [[NSMutableArray alloc] initWithCapacity:32];
    _stepLongMustableArray  = [[NSMutableArray alloc] initWithCapacity:32];
    //tableview
    [self addUserHead];
    [self addTableView];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self reloadUserInfoTableView];
}

- (void) reloadUserInfoTableView
{
    _userInfoDictionary = nil;
    _userInfoDictionary = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey];
    
    if (!_userInfoDictionary)
    {
        NSLog(@"用户信息出错");
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
    
    
    [_heightMutableArray removeAllObjects];
    [_weightMutableArray removeAllObjects];
    [_stepLongMustableArray removeAllObjects];
    
    for (float i = vHeightMin(_isMetricSystem); i <= vHeightMax(_isMetricSystem); i = i + (_isMetricSystem ? 1 : 0.1))
    {
        NSString *heightString = [NSString stringWithFormat:@"%.0f %@", i, longBack];
        if (!_isMetricSystem)
        {
            heightString = [NSString stringWithFormat:@"%.1f %@", i, longBack];
        }
        [_heightMutableArray addObject:heightString];
    }
    
    
    for (float i = vWeightMin(_isMetricSystem); i <= vWeightMax(_isMetricSystem); i++)
    {
        NSString *weightString = [NSString stringWithFormat:@"%.0f %@", i, weightBack];
        [_weightMutableArray addObject:weightString];
    }
    
    for (float i = vStepLongMin(_isMetricSystem); i <= vStepLongMax(_isMetricSystem); i = i + (_isMetricSystem ? 1 : 0.1))
    {
        NSString *stepLongString = [NSString stringWithFormat:@"%.0f %@", i, longBack];
        if (!_isMetricSystem)
        {
            stepLongString = [NSString stringWithFormat:@"%.1f %@", i, longBack];
        }
        [_stepLongMustableArray addObject:stepLongString];
    }
    
    [self addUserHead];
    [_listTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- 页面布局 -----------------
- (void) addUserHead
{
    
    [_userImageButton removeFromSuperview];
    _userImageButton = nil;
    _userImageButton = [[ObjectCTools shared] getARoundedButtonWithSize:68.0 withImageUrl:[_userInfoDictionary objectForKey:kUserInfoOfHeadPhotoKey]];  //实际应该是一个url从服务器获取图片显示
    [_userImageButton setCenter:CGPointMake(kScreenWidth / 2.0, 55.0)];
    
    [_userImageButton addTarget:self action:@selector(choicePicForUserHeadImage) forControlEvents:UIControlEventTouchUpInside];
    
    [_userImageButton setUserInteractionEnabled:NO]; //暂不替换
    
    [self.view addSubview:_userImageButton];
    
}

- (void) addTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, vTableViewLeaveTop, vOneCellWidth, kScreenHeight - vTableViewLeaveTop - 64) style:UITableViewStylePlain];
    
    [_listTableView setBackgroundColor:kBackgroundColor];
    [[ObjectCTools shared] setExtraCellLineHidden:_listTableView];
    [_listTableView setDelegate:self];
    [_listTableView setDataSource:self];
    _listTableView.center = CGPointMake(_listTableView.centerX - vTableViewMoveLeftX, _listTableView.centerY);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (void)complete
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"保存后 <公/英制> 和 <时区> 将不能再修改，是否确认保存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    alertView.delegate = self;
    [alertView show];
}

- (void)pushToHomeVC
{
    HIDDENMBProgressHUD;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [app pushToContentVC];
}

- (void) choicePicForUserHeadImage
{
    
    UIActionSheet *sheet;
    sheet.tag = vPhotoGetAciotnSheetTag;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:@"从相册选择"
                                    otherButtonTitles:@"拍照", nil];
    }
    else
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:@"从相册选择"
                                    otherButtonTitles:nil];
        
    }
    
    [sheet showInView:self.view];
}

//- (void) changeNickName
//{
//    if (!_updateNickNameVC)
//    {
//        _updateNickNameVC = [[UpdateNickNameViewController alloc] init];
//    }
//    _updateNickNameVC._lastNickName = [_userInfoDictionary objectForKey:kUserInfoOfNickNameKey];
//    [self.navigationController pushViewController:_updateNickNameVC animated:YES];
//}
//
//- (void) changeInteresting
//{
//    if (!_updateInterestingVC)
//    {
//        _updateInterestingVC = [[UpdateInterestingViewController alloc] init];
//    }
//    _updateInterestingVC._lastInteresting = [_userInfoDictionary objectForKey:kUserInfoOfInterestingKey];
//    [self.navigationController pushViewController:_updateInterestingVC animated:YES];
//
//}

- (void) changeBirth
{
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
    
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:theDate];
    datePicker.showTodayButton = NO;
    [datePicker presentInView:self.view
                    withBlock:^(BOOL madeChoice) {
                        if (madeChoice) {
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                            [dateFormatter setTimeZone:timeZone];
                            
                            NSString *getDateString = [dateFormatter stringFromDate:datePicker.selectedDate];
                            
                            if ([getDateString isEqualToString:birthdayString])
                            {
                                //相同，没有修改
                                return;
                            }
                            //                            [BraceletInfoModel updateUserInfoToBLTWithUserInfo:_userInfoDictionary withnewestModel:_thisModel WithSuccess:^(bool success) {
                            //                                if (success)
                            //                                {
                            //                                    NSLog(@"修改蓝牙设备生日信息成功");
                            NSLog(@"开始进行 生日  修改的请求吧,请求成功后请写入NSUserDefaults,再调用刷新方法reloadUserInfoTableView");
                            [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfAgeKey withValue:getDateString];
                            [self reloadUserInfoTableView];
                            //                                }
                            //                                else
                            //                                {
                            //                                    NSLog(@"修改生日失败");
                            //                                }
                            //                            }];
                            
                        }
                    }];
    
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
                            
                            
                            [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfStepLongKey withValue:nowSelectedString];
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

- (void) changeGender
{
    UIActionSheet * genderChoiceAciotnSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"取消"
                                                            destructiveButtonTitle:@"男"
                                                                 otherButtonTitles:@"女", nil];
    genderChoiceAciotnSheet.tag = vGenderChoiceAciotnSheetTag;
    [genderChoiceAciotnSheet showInView:self.view];
}

- (void) choiceMetricSystem
{
    NSLog(@"设置是否是公制");
    UIActionSheet * aciotnSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:@"公制"
                                                     otherButtonTitles:@"英制", nil];
    aciotnSheet.tag = vMetricSystemTag;
    [aciotnSheet showInView:self.view];
}

- (void) changeHeight
{
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_heightMutableArray];
    
    long lastIndex;
    NSString *lastHeight = [_userInfoDictionary objectForKey:kUserInfoOfHeightKey];
    if ([NSString isNilOrEmpty:lastHeight])
    {
        lastIndex = 178 - vHeightMin(YES);
        if (!_isMetricSystem)
        {
            lastIndex = (int) ((vChangeToFT(178) - vHeightMin(NO)) * 10);
        }
    }
    else
    {
        lastIndex= [lastHeight floatValue] - vHeightMin(YES);
        
        if (!_isMetricSystem)
        {
            lastIndex = (int) (([lastHeight floatValue] * 10 - vHeightMin(NO) * 10) );
            if (lastIndex < 0)
            {
                lastIndex = 0;
            }
            if (lastIndex > (vHeightMax(NO) - vHeightMin(NO) + 1) * 10)
            {
                lastIndex = (vHeightMax(NO) - vHeightMin(NO) + 1) * 10;
            }
        }
        else
        {
            if (lastIndex < 0)
            {
                lastIndex = 0;
            }
            if (lastIndex > (vHeightMax(YES) - vHeightMin(YES) + 1) * 10)
            {
                lastIndex = (vHeightMax(YES) - vHeightMin(YES) + 1) * 10;
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
                            
                            NSLog(@"发送身高修改的请求吧");
                            NSString *heightString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[heightString componentsSeparatedByString:@" "] firstObject];
                            //
                            //                            if (!_isMetricSystem)
                            //                            {
                            //                                nowSelectedString = [NSString stringWithFormat:@"%d", vBackToCM([nowSelectedString integerValue])];
                            //                            }
                            
                            
                            [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfHeightKey withValue:nowSelectedString];
                            [self reloadUserInfoTableView];
                            
                        }
                    }];
}

- (void) changeWeight
{
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_weightMutableArray];
    
    long lastIndex;
    NSString *lastWeight = [_userInfoDictionary objectForKey:kUserInfoOfWeightKey];
    if ([NSString isNilOrEmpty:lastWeight])
    {
        lastIndex = 50 - vWeightMin(YES);
        if (!_isMetricSystem)
        {
            lastIndex = (int) (vChangeToLB(50) - vWeightMin(NO));
        }
    }
    else
    {
        lastIndex= [lastWeight integerValue] - vWeightMin(YES);
        
        if (!_isMetricSystem)
        {
            lastIndex = (int) (([lastWeight integerValue]) - vWeightMin(NO));
            if (lastIndex < 0)
            {
                lastIndex = 0;
            }
            if (lastIndex > vWeightMax(NO) - vWeightMin(NO) + 1)
            {
                lastIndex = vWeightMax(NO) - vWeightMin(NO) + 1;
            }
        }
        else
        {
            if (lastIndex < 0)
            {
                lastIndex = 0;
            }
            if (lastIndex > vWeightMax(YES) - vWeightMin(YES) + 1)
            {
                lastIndex = vWeightMax(YES) - vWeightMin(YES) + 1;
            }
        }
    }
    
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ kg", lastWeight];
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
                            //                                    NSLog(@"修改蓝牙设备体重 信息成功");
                            NSLog(@"发送体重修改的请求吧");
                            NSString *heightString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[heightString componentsSeparatedByString:@" "] firstObject];
                            
                            //                            if (!_isMetricSystem)
                            //                            {
                            //                                nowSelectedString = [NSString stringWithFormat:@"%d", vBackToKG([nowSelectedString integerValue])];
                            //                            }
                            
                            
                            
                            [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfWeightKey withValue:nowSelectedString];
                            [self reloadUserInfoTableView];
                            //                                }
                            //                                else
                            //                                {
                            //                                    NSLog(@"修改体重失败");
                            //                                }
                            //                            }];
                            
                            
                        }
                    }];
}

//- (void) changeCity
//{
//    ProvinceViewController *provinceCtl = [[ProvinceViewController alloc]init];
//    provinceCtl.setUserInfoViewCtl = self;
//    [self.navigationController pushViewController:provinceCtl animated:YES];
//
//}

//- (void) changeDeclaration
//{
//    if (!_signatureVC)
//    {
//        _signatureVC = [[UpSignatureViewController alloc] init];
//    }
//    _signatureVC._signatureString = [_userInfoDictionary objectForKey:kUserInfoOfDeclarationKey];
//    [self.navigationController pushViewController:_signatureVC animated:YES];
//
//}

//- (void) changePassword
//{
//    if (!_updatePasswordVC)
//    {
//        _updatePasswordVC = [[UpdatePasswordViewController alloc] init];
//    }
//    [self.navigationController pushViewController:_updatePasswordVC animated:YES];
//}


#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"check index = %ld", (long)buttonIndex);
    if (buttonIndex == 1)
    {
        [self pushToHomeVC];
    }
}

#pragma mark ---------------- actionSheet delegate -----------------
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == vMetricSystemTag)
    {
        NSString __block *tempHeight = [_userInfoDictionary objectForKey:kUserInfoOfHeightKey];
        NSString __block *tempStepLong = [_userInfoDictionary objectForKey:kUserInfoOfStepLongKey];
        NSString __block *tempWeight = [_userInfoDictionary objectForKey:kUserInfoOfWeightKey];
        
        NSString *isShowMetricSystemString = [_userInfoDictionary objectForKey: kUserInfoOfIsMetricSystemKey];
        
        BOOL isShowMetricSystem = [isShowMetricSystemString boolValue];
        
        switch (buttonIndex)
        {
            case  0:
            {
                if (isShowMetricSystem)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成公制");
                    isShowMetricSystem = YES;
                }
            }
                break;
            case 1:
            {
                if (!isShowMetricSystem)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成英制");
                    isShowMetricSystem = NO;
                    
                }
            }
                break;
            case 2:
                return;
                break;
            default:
                break;
        }
        
        [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfIsMetricSystemKey withValue:[NSString stringWithFormat:@"%d", isShowMetricSystem]];
        //        [BLTSendData sendBasicSetOfInformationData:_thisModel._isShowMetricSystem withActivityTimeZone:8
        //                                   withUpdateBlock:^(id object, BLTAcceptDataType type) {
        //                                       if (type == BLTAcceptDataTypeSetBaseInfo)
        //                                       {
        NSLog(@"设置公英制成功");
        
        if (isShowMetricSystem)
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
        
        [self reloadUserInfoTableView];
    }
    //                                       else
    //                                       {
    //                                           NSLog(@"设置公英制失败");
    //                                           _thisModel._isShowMetricSystem = !_thisModel._isShowMetricSystem;
    //                                       }
    //                                   }];
    //
    //        return;
    //    }
    
    if (actionSheet.tag == vGenderChoiceAciotnSheetTag)
    {
        NSString *gender = @"";
        switch (buttonIndex)
        {
            case  0:
            {
                gender = @"男";
            }
                break;
            case 1:
            {
                gender = @"女";
            }
                break;
            case 2:
                return;
                break;
            default:
                break;
        }
        [self changeGenderRequeset:gender];
        return;
    }
    
    //    NSLog(@"button = %ld", (long)buttonIndex);
    //    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //
    //    switch (buttonIndex)
    //    {
    //        case  0:
    //            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //            break;
    //        case 1:
    //        {
    //            if ([[ObjectCTools shared] isCameraAvailable]) {
    //                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //            }
    //            else
    //            {
    //                return;
    //            }
    //        }
    //            break;
    //        case 2:
    //            return;
    //            break;
    //        default:
    //            break;
    //    }//d77409195a1edd783e1d4b9c042cf640
    //    [imagePicker.navigationBar setTintColor:kNavigationBarTitleColor];
    //    imagePicker.allowsEditing = YES;
    //    imagePicker.delegate = self;
    //
    //    [[ObjectCTools shared].getAppDelegate.window.rootViewController presentViewController:imagePicker animated:YES completion:^{
    //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    //    }];
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
    CGRect titleFrame = CGRectMake(0, 0, 200, vOneCellHeight);
    UILabel *title = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                 backgroundColor:[UIColor clearColor]
                                                            text:[_cellTitleArray objectAtIndex:indexPath.row]
                                                       textColor:[UIColor blackColor]
                                                            font:[UIFont systemFontOfSize:18]
                                                   textAlignment:NSTextAlignmentLeft
                                                   lineBreakMode:0
                                                   numberOfLines:0];
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
                                                            textColor:kRGBAlpha(0, 0, 0, 0.6)
                                                                 font:[UIFont systemFontOfSize:18]
                                                        textAlignment:NSTextAlignmentLeft
                                                        lineBreakMode:NSLineBreakByCharWrapping
                                                        numberOfLines:1];
    
    
    
    
    //    NSLog(@"lent = %f", rightTitle.width);
    
    //    if (indexPath.row == 0)
    //    {
    //        FlatRoundedButton *userImageButton = [[ObjectCTools shared] getARoundedButtonWithSize:vOneCellHeight - 13 withImageUrl:[_userInfoDictionary objectForKey:kUserInfoOfHeadPhotoKey]];  //实际应该是一个url从服务器获取图片显示
    //        [userImageButton setCenter:CGPointMake(rightImageView.x - userImageButton.width / 2.0 - 12.0, vOneCellHeight / 2.0)];
    //
    //        userImageButton.userInteractionEnabled = NO;
    //        [oneCell.contentView addSubview:userImageButton];
    //    }
    //    else
    {
        NSString *nameString = [_userInfoDictionary objectForKey: [_cellTitleKeyArray objectAtIndex:indexPath.row]];
        if (![NSString isNilOrEmpty:nameString ])
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    if ([NSString isNilOrEmpty:nameString])
                    {
                        nameString = @"24岁";
                    }
                    else
                    {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSTimeInterval dateDiff = [[dateFormatter dateFromString:nameString] timeIntervalSinceNow];
                        
                        int age = trunc(dateDiff / (60 * 60 * 24)) / 365;
                        nameString = [NSString stringWithFormat:@"%.0f岁", fabs(age)];
                        
                    }
                }
                    break;
                case 2:
                {
                    if ([NSString isNilOrEmpty:nameString])
                    {
                        nameString = @"公制";
                    }
                    else
                    {
                        if ([nameString boolValue])
                        {
                            nameString = @"公制";
                        }
                        else
                        {
                            nameString = @"英制";
                        }
                    }
                }
                    break;
                    
                case 3:
                {
                    if ([NSString isNilOrEmpty:nameString])
                    {
                        nameString = @"172";
                    }
                    nameString = [NSString stringWithFormat:@"%@cm", nameString];
                    if (!_isMetricSystem)
                    {
                        nameString = [NSString stringWithFormat:@"%.1fft", ([nameString floatValue])];
                    }
                }
                    break;
                case 4:
                {
                    if ([NSString isNilOrEmpty:nameString])
                    {
                        nameString = @"62";
                    }
                    nameString = [NSString stringWithFormat:@"%@kg", nameString];
                    if (!_isMetricSystem)
                    {
                        nameString = [NSString stringWithFormat:@"%.0flb", ([nameString floatValue])];
                    }
                }
                    break;
                    //                case 600:
                    //                {
                    //                    nameString = [NSString stringWithFormat:@"%@cm", nameString];
                    //                    if (!_isMetricSystem)
                    //                    {
                    //                        nameString = [NSString stringWithFormat:@"%.1fft", [nameString floatValue]];
                    //                    }
                    //                }
                    //                    break;
                default:
                    break;
            }
            
            if (nameString.length >= 15)
            {
                nameString = [NSString stringWithFormat:@"%@...", [nameString substringToIndex:12]];
                //                NSLog(@"name = %@", nameString);
            }
            [rightTitle setText:nameString];
        }
        else
        {
            [rightTitle setText:@"(未设置)"];
        }
        
        //        NSLog(@"lenth---- = %lu", (unsigned long)rightTitle.text.length);
    }
    
    [rightTitle setWidth:126];
    [rightTitle setCenter:CGPointMake(vOneCellWidth - 25 - rightTitle.width / 2.0, vOneCellHeight / 2.0)];
    [oneCell.contentView addSubview:rightTitle];
    
    
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
    
    switch (indexPath.row )
    {
        case 0:
            [self changeBirth];
            break;
        case 1:
            [self changeGender];
            break;
        case 2:
            [self choiceMetricSystem];
            break;
        case 3:
            [self changeHeight];
            break;
        case 4:
            [self changeWeight];
            break;
        case 600:
            [self changeStepLong];
            break;
        case 5:
            //            [self changeInteresting];
            break;
        default:
            break;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NSString isNilOrEmpty:[_cellTitleArray objectAtIndex:indexPath.row]])
    {
        return 10.0;
    }
    
    if (indexPath.row == _cellTitleArray.count - 1)
    {
        return 70;
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

#pragma mark ---------------- 图片选取 delegate -----------------

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"上传图像....，开始网络请求吧,请求成功后请URL写入NSUserDefaults,再调用刷新方法refreshTheHeadImage");
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}

- (void) refreshTheHeadImage
{
    [self reloadUserInfoTableView];
    
    //通知首页等也刷新头像吧
    NSLog(@"通知首页等地方刷新头像");
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ---------------- 其它请求 -----------------
- (void) changeGenderRequeset:(NSString *) gender
{
    if ([gender isEqualToString:[_userInfoDictionary objectForKey:kUserInfoOfSexKey]])
    {
        //相同，没有修改
        return;
    }
    
    NSLog(@"开始进行性别修改的请求吧,请求成功后请写拉NSUserDefaults,再调用刷新方法reloadUserInfoTableView");
    
    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfSexKey withValue:gender];
    [self reloadUserInfoTableView];
}

@end

