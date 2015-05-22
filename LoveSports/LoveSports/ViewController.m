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
#import "TimeZoneChoiceViewController.h"

#import "UserInfoHelp.h"
#import "LoginBindingVC.h"

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
    
    NSMutableArray *_timeZoneArray;
    
    TimeZoneChoiceViewController *_timeZoneVC;
}
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) NSInteger  _timeZoneNumber;

@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, strong) BLTModel *braceModel;

@end

@implementation ViewController
@synthesize _timeZoneNumber;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LS_Text(@"Set Personal Data");
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    //    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:LS_Text(@"Accomplish")
                                                                                      target:self
                                                                                    selector:@selector(complete)
                                                                                   ImageName:@""];
    
    _userInfo = [UserInfoHelp sharedInstance].userModel;
    _braceModel = [UserInfoHelp sharedInstance].braceModel;
    
    //初始化
    _cellTitleArray = [NSArray arrayWithObjects:LS_Text(@"Date of Birth"), LS_Text(@"Gender"),
                       LS_Text(@"Metric/Imperial"), LS_Text(@"Height"),
                       LS_Text(@"Weight"), LS_Text(@"Time zone of regular activity place"), nil];
    
    NSLog(@"..%d", _userInfo.isMetricSystem );
    _cellTitleKeyArray = [NSArray arrayWithObjects:_userInfo.birthDay, _userInfo.genderSex,
                          _userInfo.isMetricSystem ? LS_Text(@"Metric") : LS_Text(@"Imperial"), NSStringWithInt(_userInfo.height),
                          NSStringWithInt(_userInfo.weight), _userInfo.showTimeZone, nil];
    
    
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
 */


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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LS_Text(@"Important tips")
                                                        message:LS_Text(@"Metric/imperial and time zone can't be modified once saved. Confirm to save?")
                                                       delegate:self
                                              cancelButtonTitle:LS_Text(@"Cancel")
                                              otherButtonTitles:LS_Text(@"Confirm"), nil];
    
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
    
    DEF_WEAKSELF_(ViewController);
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

- (void) choiceMetricSystem
{
    NSLog(@"设置是否是公制");
    UIActionSheet * aciotnSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:LS_Text(@"Cancel")
                                                destructiveButtonTitle:LS_Text(@"Metric")
                                                     otherButtonTitles:LS_Text(@"Imperial"), nil];
    aciotnSheet.tag = vMetricSystemTag;
    [aciotnSheet showInView:self.view];
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
            heightString = [NSString stringWithFormat:@"%0.2f ft", vChangeToFT(i)];
        }
        
        [_heightMutableArray addObject:heightString];
    }

    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_heightMutableArray];
    
    NSInteger lastIndex = _userInfo.height - 60;
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ cm", lastHeight];
    
    DEF_WEAKSELF_(ViewController);
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
                            vBackToCM([nowSelectedString floatValue]);
                            
                            [weakSelf.listTableView reloadData];
                        }
                    }];
}

- (void) changeWeight
{
    [_weightMutableArray removeAllObjects];
    for (float i = 20; i <= 300; i++)
    {
        NSString *weightString;
        if (_userInfo.isMetricSystem)
        {
            weightString = [NSString stringWithFormat:@"%.f kg", i];
        }
        else
        {
            weightString = [NSString stringWithFormat:@"%0.2f lb", vChangeToLB(i)];
        }
        [_weightMutableArray addObject:weightString];
    }
    
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_weightMutableArray];
    
    long lastIndex = _userInfo.weight - 20;
    pickerView.selectedIndex = lastIndex;
    //    pickerView.selectedValue = [NSString stringWithFormat:@"%@ kg", lastWeight];
    
    DEF_WEAKSELF_(ViewController);
    [pickerView presentInView:self.view
                    withBlock:^(BOOL madeChoice) {
                        if (madeChoice) {
                            if (pickerView.selectedIndex == lastIndex)
                            {
                                NSLog(@"未做修改");
                                return;
                            }
                            
                            NSLog(@"发送体重修改的请求吧");
                            NSString *heightString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[heightString componentsSeparatedByString:@" "] firstObject];
                            
                            weakSelf.userInfo.weight = weakSelf.userInfo.isMetricSystem ?
                            [nowSelectedString integerValue] :
                            vBackToKG([nowSelectedString floatValue]);
                            
                            [weakSelf.listTableView reloadData];
                        }
                    }];
}

- (void) changeTimeZone
{

}

#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"check index = %ld", (long)buttonIndex);
    if (buttonIndex == 1)
    {
        //不再进入此页面
        [[ObjectCTools shared] setobject:[NSNumber numberWithInt:1] forKey:@"addVC"];
        // [self pushToHomeVC];
        
        LoginBindingVC *vc = [[LoginBindingVC alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---------------- actionSheet delegate -----------------
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == vMetricSystemTag)
    {
        if (buttonIndex != 2)
        {
            _userInfo.isMetricSystem = !buttonIndex;
        }
    }
    else if (actionSheet.tag == vGenderChoiceAciotnSheetTag)
    {
        if (buttonIndex != 2)
        {
            _userInfo.genderSex = buttonIndex ? LS_Text(@"Female") : LS_Text(@"Male");
        }
    }
    
    [_listTableView reloadData];
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
    CGRect titleFrame = CGRectMake(0, 0, 150, vOneCellHeight);
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
    
    {
        NSString *nameString = [_cellTitleKeyArray objectAtIndex:indexPath.row];
        if (![NSString isNilOrEmpty:nameString ])
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    nameString = [NSDate stringToAge:_userInfo.birthDay];
                }
                    break;
                case 1:
                {
                    nameString = _userInfo.showGenderSex;
                }
                    break;
                case 2:
                {
                    nameString = _userInfo.isMetricSystem ? LS_Text(@"Metric") : LS_Text(@"Imperial");
                }
                    break;
                    
                case 3:
                {
                    nameString = _userInfo.showHeight;
                }
                    break;
                case 4:
                {
                    nameString = _userInfo.showWeight;
                }
                    break;
                case 5:
                {
                    nameString = _userInfo.showTimeZone;
                }
                    break;
                    
                default:
                    break;
            }

            [rightTitle setText:nameString];
        }
        else
        {
            [rightTitle setText:@"(未设置)"];
        }
        
        //        NSLog(@"lenth---- = %lu", (unsigned long)rightTitle.text.length);
    }
    
    [rightTitle setWidth:136];
    [rightTitle setCenter:CGPointMake(vOneCellWidth - 35 - rightTitle.width / 2.0, vOneCellHeight / 2.0)];
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
        case 5:
//            [self changeTimeZone];
        {
         
             TimeZoneChoiceViewController *timeZoneVC = [[TimeZoneChoiceViewController alloc] init];
        
            [self.navigationController pushViewController:timeZoneVC animated:YES];
        }
            break;
        case 600:
            [self changeStepLong];
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
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}

- (void) refreshTheHeadImage
{
    
    //通知首页等也刷新头像吧
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
    
    
    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfSexKey withValue:gender];
}

@end

