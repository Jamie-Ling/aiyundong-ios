//
//  BraceletInfoViewController.m
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

#define vHeightMin   60
#define vHeightMax   220

#define vWeightMin   20
#define vWeightMax   250

#import "BraceletInfoViewController.h"
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

@interface BraceletInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    NSArray *_cellTitleArray;
    
    NSDictionary *_userInfoDictionary;
    UpdateNickNameViewController *_updateNickNameVC;
    UpdatePasswordViewController *_updatePasswordVC;
    UpdateInterestingViewController *_updateInterestingVC;
    UpSignatureViewController *_signatureVC;
    
    UITableView *_listTableView;
    
}
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation BraceletInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户信息";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    //初始化
    _cellTitleArray = [NSArray arrayWithObjects:@"每日目标", @"自定义", @"", @"时间与闹钟", @"久座提醒", @"防丢提醒", @"固件升级", @"恢复到默认设置", nil];

    //tableview
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


/*

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

- (void) changeNickName
{
    if (!_updateNickNameVC)
    {
        _updateNickNameVC = [[UpdateNickNameViewController alloc] init];
    }
    _updateNickNameVC._lastNickName = [_userInfoDictionary objectForKey:kUserInfoOfNickNameKey];
    [self.navigationController pushViewController:_updateNickNameVC animated:YES];
}

- (void) changeInteresting
{
    if (!_updateInterestingVC)
    {
        _updateInterestingVC = [[UpdateInterestingViewController alloc] init];
    }
    _updateInterestingVC._lastInteresting = [_userInfoDictionary objectForKey:kUserInfoOfInterestingKey];
    [self.navigationController pushViewController:_updateInterestingVC animated:YES];
    
}

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
                            
                            NSLog(@"开始进行 生日  修改的请求吧,请求成功后请写入NSUserDefaults,再调用刷新方法reloadUserInfoTableView");
                            [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfAgeKey withValue:getDateString];
                            [self reloadUserInfoTableView];
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

- (void) changeHeight
{
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:_heightMutableArray];
    
    long lastIndex;
    NSString *lastHeight = [_userInfoDictionary objectForKey:kUserInfoOfHeightKey];
    if ([NSString isNilOrEmpty:lastHeight])
    {
        lastIndex = 178 - vHeightMin;
    }
    else
    {
        lastIndex= [lastHeight integerValue] - vHeightMin;
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
        lastIndex = 50 - vWeightMin;
    }
    else
    {
        lastIndex= [lastWeight integerValue] - vWeightMin;
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
                            
                            NSLog(@"发送体重修改的请求吧");
                            NSString *heightString = pickerView.selectedValue;
                            NSString *nowSelectedString = [[heightString componentsSeparatedByString:@" "] firstObject];
                            [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfWeightKey withValue:nowSelectedString];
                            [self reloadUserInfoTableView];
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
    _signatureVC._signatureString = [_userInfoDictionary objectForKey:kUserInfoOfDeclarationKey];
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
    UIImageView *rightImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vOneCellWidth - vOneCellHeight / 2.0 + 5, vOneCellHeight / 2.0) withImageName:@"right.png" withImageZoomSize:1.0];
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
        FlatRoundedButton *userImageButton = [[ObjectCTools shared] getARoundedButtonWithSize:vOneCellHeight - 13 withImageUrl:[_userInfoDictionary objectForKey:kUserInfoOfHeadPhotoKey]];  //实际应该是一个url从服务器获取图片显示
        [userImageButton setCenter:CGPointMake(rightImageView.x - userImageButton.width / 2.0 - 12.0, vOneCellHeight / 2.0)];
        
        userImageButton.userInteractionEnabled = NO;
        [oneCell.contentView addSubview:userImageButton];
    }
    else
    {
        NSString *nameString = [_userInfoDictionary objectForKey: [_cellTitleKeyArray objectAtIndex:indexPath.row]];
        if (![NSString isNilOrEmpty:nameString ])
        {
            switch (indexPath.row)
            {
                case 2:
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    
                    NSTimeInterval dateDiff = [[dateFormatter dateFromString:nameString] timeIntervalSinceNow];
                    
                    int age = trunc(dateDiff / (60 * 60 * 24)) / 365;
                    nameString = [NSString stringWithFormat:@"%.0f岁", fabs(age)];
                }
                    break;
                case 4:
                {
                    nameString = [NSString stringWithFormat:@"%@cm", nameString];
                }
                    break;
                case 5:
                {
                    nameString = [NSString stringWithFormat:@"%@kg", nameString];
                }
                    break;
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
    
    [rightTitle setCenter:CGPointMake(title.right + 2 + rightTitle.width / 2.0, vOneCellHeight / 2.0)];
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
            [self choicePicForUserHeadImage];
            break;
        case 1:
            [self changeNickName];
            break;
        case 2:
            [self changeBirth];
            break;
        case 3:
            [self changeGender];
            break;
            
        case 4:
            [self changeHeight];
            break;
        case 5:
            [self changeWeight];
            break;
        case 6:
            [self changeInteresting];
            break;
        case 7:
            [self changeCity];
            break;
        case 8:
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
        return 13.0;
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
*/
@end
