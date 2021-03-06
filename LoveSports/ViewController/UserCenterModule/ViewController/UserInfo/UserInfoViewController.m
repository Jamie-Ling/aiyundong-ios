//
//  UserInfoViewController.m
//  Woyoli
//
//  Created by jamie on 14-12-2.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//
#define vGenderChoiceAciotnSheetTag  1234   //性别选择sheet  Tag
#define vPhotoGetAciotnSheetTag    1235  //相片选择sheet  tag

#define v_signOutButtonHeight (kIPhone4s ? 45 : 55.0 ) //退出按钮高度

#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vTableViewMoveLeftX 0  //tableview向左移20
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#import "UserInfoViewController.h"
#import "FlatRoundedButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UpdateNickNameViewController.h"
#import "UpdatePasswordViewController.h"
#import "ProvinceViewController.h"
#import "UpSignatureViewController.h"
#import "UpdateInterestingViewController.h"
#import "UpSignatureViewController.h"
#import "BSModalPickerView.h"
#import "BSModalDatePickerView.h"
#import "BSWeightPickerView.h"

@interface UserInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    NSArray *_cellTitleArray;
    NSArray *_cellTitleKeyArray;
    
    NSMutableArray *_heightMutableArray;
    NSMutableArray *_weightMutableArray;
    NSMutableArray *_stepLongMustableArray;
    
    NSDictionary *_userInfoDictionary;
    UpdateNickNameViewController *_updateNickNameVC;
    UpdatePasswordViewController *_updatePasswordVC;
    UpdateInterestingViewController *_updateInterestingVC;
    UpSignatureViewController *_signatureVC;
    
    UITableView *_listTableView;
    BOOL _isMetricSystem;
    UILabel *_notConectLabel;
    
    BOOL _haveConect;
    
}
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UserInfoModel *userInfo;

@end

@implementation UserInfoViewController
@synthesize _thisModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LS_Text(@"User info");
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back")
                                                                                    target:self
                                                                                  selector:@selector(goBackPrePage)
                                                                                 ImageName:@""];
    
    _userInfo = [UserInfoHelp sharedInstance].userModel;

    //初始化
//    _cellTitleArray = [NSArray arrayWithObjects:@"头像", @"昵称 ：", @"年龄 ：", @"性别 ：", @"身高 ：", @"体重 ：", @"步距 ：", @"兴趣爱好 ：", @"经常活动地 ：", @"运动宣言 ：", nil];
    
    _cellTitleArray = [NSArray arrayWithObjects:LS_Text(@"Photo"), LS_Text(@"Nickname:"),
                       @"", LS_Text(@"Age"), LS_Text(@"Gender"),
                       LS_Text(@"Height"), LS_Text(@"Weight"), @"",
                       LS_Text(@"Hobby"), LS_Text(@"Time zone of regular activity place"),
                       LS_Text(@"Manifesto"), nil];

    
    _heightMutableArray = [[NSMutableArray alloc] initWithCapacity:32];
    _weightMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
  
    
    //tableview
    [self addTableView];
    
    [self addDidnotConectLabel];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self readyForSet];
    
    DEF_WEAKSELF_(UserInfoViewController);
    [BLTManager sharedInstance].connectBlock = ^() {
        [weakSelf refreshTableView:YES];
    };
    [BLTManager sharedInstance].disConnectBlock = ^() {
        [weakSelf refreshTableView:NO];
    };
}

- (void)refreshTableView:(BOOL)isAllow
{
    [self readyForSet];

    [_listTableView reloadData];
    [_notConectLabel setHidden:isAllow];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTManager sharedInstance].connectBlock = nil;
    [BLTManager sharedInstance].disConnectBlock = nil;
}

/*
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
    
    _weightMutableArray = [[NSMutableArray alloc] initWithCapacity:32];
    for (float i = vWeightMin(_isMetricSystem); i <= vWeightMax(_isMetricSystem); i++)
    {
        NSString *weightString = [NSString stringWithFormat:@"%.0f %@", i, weightBack];
        [_weightMutableArray addObject:weightString];
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
    
    [_listTableView reloadData];
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- 页面布局 -----------------

//设置前的准备---防止中间断开了
- (BOOL) readyForSet
{
    if ([BLTManager sharedInstance].connectState != BLTManagerConnected)
    {
        //没有连接设备
        _haveConect = NO;
        [_notConectLabel setHidden:NO];
        //        SHOWMBProgressHUD(@"没有链接设备.", @"无法设置", nil, NO, 2.0);       //提示要连接设备
        [_listTableView reloadData];  //刷新UI
        return NO;
    }
    [_notConectLabel setHidden:YES];
    _haveConect = YES;
    return YES;
}


- (void) addTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, vTableViewLeaveTop, vOneCellWidth, kScreenHeight - vTableViewLeaveTop - 64) style:UITableViewStylePlain];
    
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

- (void) choicePicForUserHeadImage
{
    
    UIActionSheet *sheet;
    sheet.tag = vPhotoGetAciotnSheetTag;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:LS_Text(@"Cancel")
                               destructiveButtonTitle:LS_Text(@"Choose from the album")
                                    otherButtonTitles:LS_Text(@"take a picture"), nil];
    }
    else
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:LS_Text(@"Cancel")
                               destructiveButtonTitle:LS_Text(@"Choose from the album")
                                    otherButtonTitles:nil];
        
    }
    
    [sheet showInView:self.view];
}

- (void) changeNickName
{
    if (!_updateNickNameVC)
    {
        _updateNickNameVC = [[UpdateNickNameViewController alloc] init];
    }
    _updateNickNameVC._lastNickName = _userInfo.nickName;
    [self.navigationController pushViewController:_updateNickNameVC animated:YES];
}

- (void) changeInteresting
{
    if (!_updateInterestingVC)
    {
        _updateInterestingVC = [[UpdateInterestingViewController alloc] init];
    }
    _updateInterestingVC._lastInteresting = _userInfo.interest;
    [self.navigationController pushViewController:_updateInterestingVC animated:YES];
    
}

- (void) changeBirth
{
    NSDate *theDate = [NSDate date];
    NSString *birthdayString = _userInfo.birthDay;
    if (![NSString isNilOrEmpty:birthdayString ])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:timeZone];
        theDate = [dateFormatter dateFromString:birthdayString];
    }
    
    DEF_WEAKSELF_(UserInfoViewController);

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
                            weakSelf.userInfo.birthDay = getDateString;
                            [weakSelf.listTableView reloadData];
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
            lastIndex = (int) (((int)CMChangeToIN(50) - vStepLongMin(NO)));
        }
    }
    else
    {
        lastIndex= [lastLong integerValue] - vStepLongMin(YES);
        
        if (!_isMetricSystem)
        {
            lastIndex = (int) (([lastLong floatValue] - vStepLongMin(NO)));
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
                                return;
                            }
                            
//                            [BraceletInfoModel updateUserInfoToBLTWithUserInfo:_userInfoDictionary withnewestModel:_thisModel WithSuccess:^(bool success) {
//                                if (success)
//                                {
                                    NSString *longString = pickerView.selectedValue;
                                    NSString *nowSelectedString = [[longString componentsSeparatedByString:@" "] firstObject];
                            
//                            if (!_isMetricSystem)
//                            {
//                                nowSelectedString = [NSString stringWithFormat:@"%d", vBackToCM([nowSelectedString integerValue])];
//                            }
                            
                            
                                    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfStepLongKey withValue:nowSelectedString];
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
                                                                 cancelButtonTitle:LS_Text(@"Cancel")
                                                            destructiveButtonTitle:LS_Text(@"Male")
                                                                 otherButtonTitles:LS_Text(@"Female"), nil];
    genderChoiceAciotnSheet.tag = vGenderChoiceAciotnSheetTag;
    [genderChoiceAciotnSheet showInView:self.view];
}

- (void) changeHeight
{
    [_heightMutableArray removeAllObjects];
    for (float i = 60; i <= 220; i++)
    {
        NSString *heightString;
        if (_userInfo.isMetricSystem)
        {
            heightString = [NSString stringWithFormat:@"%.f cm", i];
        }
        else
        {
            heightString = [NSString stringWithFormat:@"%0.2f in", CMChangeToIN(i)];
        }
        
        [_heightMutableArray addObject:heightString];
    }
    
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_heightMutableArray];
    
    NSInteger lastIndex = _userInfo.height - 60;
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ cm", lastHeight];
    
    DEF_WEAKSELF_(UserInfoViewController);
    [pickerView presentInView:self.view
                    withBlock:^(BOOL madeChoice) {
                        if (madeChoice) {
                            if (pickerView.selectedIndex == lastIndex)
                            {
                                NSLog(@"未做修改");
                                return;
                            }
                            
                            NSString *heightString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[heightString componentsSeparatedByString:@" "] firstObject];
                            
                            weakSelf.userInfo.height = weakSelf.userInfo.isMetricSystem ?
                            [nowSelectedString integerValue] :
                            INBackToCM([nowSelectedString floatValue]);
                            
                            [weakSelf.listTableView reloadData];
                            
                        }
                    }];
}


- (void) changeWeight
{
    [_weightMutableArray removeAllObjects];
    NSMutableArray *intArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *floatArray = [[NSMutableArray alloc] initWithCapacity:0];

    for (float i = 20; i <= 300; i++)
    {
        NSString *weightString;
        if (_userInfo.isMetricSystem)
        {
            weightString = [NSString stringWithFormat:@"%d", (int)i];
        }
        else
        {
            weightString = [NSString stringWithFormat:@"%d", (int)i];
        }
        [intArray addObject:weightString];
    }
    
    for (float i = 0; i <= 9; i++)
    {
        NSString *weightString;
        if (_userInfo.isMetricSystem)
        {
            weightString = [NSString stringWithFormat:@"%d", (int)i];
        }
        else
        {
            weightString = [NSString stringWithFormat:@"%d", (int)i];
        }
        [floatArray addObject:weightString];
    }
    
    BSWeightPickerView *pickerView = [[BSWeightPickerView alloc] initWithInteger:intArray
                                                                    withDecimals:floatArray
                                                                        withUnit:_userInfo.isMetricSystem ? @"kg" : @"lb"];
    
    int index1 = 0;
    int index2 = 0;
    
    if (_userInfo.isMetricSystem)
    {
        index1 = (int)_userInfo.weight - 20;
        index2 = ((int)(_userInfo.weight * 10)) % 10;
    }
    else
    {
        CGFloat lbWeight = vChangeToLB(_userInfo.weight);
        index1 = (int)lbWeight - 20;
        index2 = ((int)(lbWeight * 10)) % 10;
    }

    pickerView.selectedIndex1 = index1;
    pickerView.selectedIndex2 = index2;

    DEF_WEAKSELF_(UserInfoViewController);
    [pickerView presentInView:self.view
                    withBlock:^(BOOL madeChoice) {
                        if (madeChoice) {
                 
                            CGFloat weight = pickerView.selectedValue;
                            weakSelf.userInfo.weight = weakSelf.userInfo.isMetricSystem ?
                                                        weight : vBackToKG(weight);
                            
                            [weakSelf.listTableView reloadData];
                        }
                    }];
}

- (void) changeCity
{
    ProvinceViewController *provinceCtl = [[ProvinceViewController alloc]init];
    provinceCtl.setUserInfoViewCtl = self;
    [self.navigationController pushViewController:provinceCtl animated:YES];
    
}

- (void) changeDeclaration
{
    if (!_signatureVC)
    {
        _signatureVC = [[UpSignatureViewController alloc] init];
    }
    _signatureVC._signatureString = _userInfo.manifesto;
    [self.navigationController pushViewController:_signatureVC animated:YES];
    
}

- (void) changePassword
{
    if (!_updatePasswordVC)
    {
        _updatePasswordVC = [[UpdatePasswordViewController alloc] init];
    }
    [self.navigationController pushViewController:_updatePasswordVC animated:YES];
}


#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"check index = %ld", (long)buttonIndex);
    if (buttonIndex == 1)
    {
        
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
                                                            textColor:kLabelTitleDefaultColor
                                                                 font:[UIFont systemFontOfSize:14]
                                                        textAlignment:NSTextAlignmentLeft
                                                        lineBreakMode:NSLineBreakByCharWrapping
                                                        numberOfLines:1];
    
    [rightTitle setWidth:rightImageView.x - title.right - 2 - 18];
    //    NSLog(@"lent = %f", rightTitle.width);
    
    if (indexPath.row == 0)
    {
        /*
        FlatRoundedButton *userImageButton = [[ObjectCTools shared] getARoundedButtonWithSize:vOneCellHeight - 13 withImageUrl:[_userInfoDictionary objectForKey:kUserInfoOfHeadPhotoKey]];  //实际应该是一个url从服务器获取图片显示
        [userImageButton setCenter:CGPointMake(rightImageView.x - userImageButton.width / 2.0 - 12.0, vOneCellHeight / 2.0)];
        
        userImageButton.userInteractionEnabled = NO;
         */
        
        UIView *headImage = [[UIView alloc] initWithFrame:CGRectMake(self.width - 80, (vOneCellHeight - 36) / 2.0, 36, 36)];
        headImage.backgroundColor = [UIColor clearColor];
        headImage.userInteractionEnabled = NO;
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 18;
        headImage.image = [[DataShare sharedInstance] getHeadImage];
        [oneCell.contentView addSubview:headImage];
    }
    else
    {
        NSString *nameString;
            switch (indexPath.row)
            {
                case 1:
                {
                    nameString = _userInfo.nickName;
                }
                    break;
                case 3:
                {
                    nameString = [NSDate stringToAge:_userInfo.birthDay];
                }
                    break;
                case 4:
                {
                    nameString = _userInfo.showGenderSex;
                }
                    break;
                case 5:
                {
                    nameString = _userInfo.showHeight;
                }
                    break;
                case 6:
                {
                    nameString = _userInfo.showWeight;
                }
                    break;
                case 600:
                {
                    nameString = [NSString stringWithFormat:@"%@cm", nameString];
                    if (!_isMetricSystem)
                    {
                        nameString = [NSString stringWithFormat:@"%.1fft", [nameString floatValue]];
                    }
                }
                    break;
                case 8:
                {
                    nameString = _userInfo.interest;
                }
                    break;
                case 9:
                {
                    nameString = _userInfo.showTimeZone;
                }
                    break;
                case 10:
                {
                    nameString = _userInfo.manifesto;
                }
                    break;
                default:
                    break;
            }

            [rightTitle setText:nameString];
   
        //        NSLog(@"lenth---- = %lu", (unsigned long)rightTitle.text.length);
    }
    
    [rightTitle setCenter:CGPointMake(title.right + 2 + rightTitle.width / 2.0, vOneCellHeight / 2.0)];
    [oneCell.contentView addSubview:rightTitle];
    
    
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
    
    if (indexPath.row == 9)
    {
        //将活动地屏蔽
        oneCell.userInteractionEnabled = NO;
        [rightImageView setHidden:YES];
        
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
    
    switch (indexPath.row )
    {
        case 0:
            [self choicePicForUserHeadImage];
            break;
        case 1:
            [self changeNickName];
            break;
        case 3:
            [self changeBirth];
            break;
        case 4:
            [self changeGender];
            break;
            
        case 5:
            [self changeHeight];
            break;
        case 6:
            [self changeWeight];
            break;
        case 600:
            [self changeStepLong];
            break;
        case 8:
            [self changeInteresting];
            break;
        case 9:
            [self changeCity];
            break;
        case 10:
            [self changeDeclaration];
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

#pragma mark ---------------- actionSheet delegate -----------------
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == vGenderChoiceAciotnSheetTag)
    {
        if (buttonIndex != 2)
        {
            _userInfo.genderSex = buttonIndex ? LS_Text(@"Female") : LS_Text(@"Male");
            
            [_listTableView reloadData];
        }
        
        return;
    }
    
    NSLog(@"button = %ld", (long)buttonIndex);
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    switch (buttonIndex)
    {
        case  0:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1:
        {
            if ([[ObjectCTools shared] isCameraAvailable]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                return;
            }
        }
            break;
        case 2:
            return;
            break;
        default:
            break;
    }//d77409195a1edd783e1d4b9c042cf640
    [imagePicker.navigationBar setTintColor:kNavigationBarTitleColor];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    [[ObjectCTools shared].getAppDelegate.window.rootViewController presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    }];
}

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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *scaleImage = [image scaleToSize:CGSizeMake(100.0, 100.0)];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    NSString *headFold = [[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_HeadImage];
    NSString *filePath = [headFold stringByAppendingPathComponent:DS_HeadImage];
    NSData *data = UIImageJPEGRepresentation(scaleImage, 1.0);
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];

    [_listTableView reloadData];

    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) refreshTheHeadImage
{
    
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
