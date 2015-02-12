//
//  BraceletInfoViewController.m
//  Woyoli
//
//  Created by jamie on 14-12-2.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//
#define vSheetTag1  1234   //时区选择
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

#import "TargetViewController.h"
#import "CustomViewController.h"
#import "TimeAndClockViewController.h"
#import "JSBadgeView.h"
#import "VersionInfoModel.h"
#import "DeviceUpdateViewController.h"
#import "TestBLTViewController.h"
#import "BSModalPickerView.h"


@interface TestBLTViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    
    NSArray *_cellTitleArray;
    UITableView *_listTableView;
    
}
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation TestBLTViewController
@synthesize _thisModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"蓝牙手环信息设置";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    //初始化
    _cellTitleArray = [NSArray arrayWithObjects:@"时差的绝对值-设置", @"本地时间和时区-设置", @"", nil];
    
    //tableview
    [self addTableView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    [self.navigationController setNavigationBarHidden:NO];
    
   
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //将要消失时更新存储
    [[BraceletInfoModel getUsingLKDBHelper] insertToDB:_thisModel];
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


#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

#pragma mark ---------------- actionSheet delegate -----------------
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"check index = %ld", (long)buttonIndex);
    switch (actionSheet.tag) {
        case vSheetTag1:
        {
            bool change;
            if (buttonIndex == 0)
            {
                if (!_thisModel._timeZone)
                {
                    change = YES;
                    _thisModel._timeZone = NO;
                }
            }
            else if (buttonIndex == 1)
            {
                if (_thisModel._timeZone)
                {
                    change = YES;
                    _thisModel._timeZone = YES;
                }
            }
            
            if (!change)
            {
                return;
            }
            NSDate *nowDate = [NSDate date];
            [BLTSendData sendLocalTimeInformationData:nowDate withUpdateBlock:^(id object, BLTAcceptDataType type) {
                if (type == BLTAcceptDataTypeSetLocTime)
                {
                    NSLog(@"修改时区成功");
                }
                else
                {
                    NSLog(@"修改时区失败");
                    _thisModel._timeZone = !_thisModel._timeZone;
                }
            }];
        
        }
            break;
            
        default:
            break;
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
                                                                 font:[UIFont systemFontOfSize:12]
                                                        textAlignment:NSTextAlignmentCenter
                                                        lineBreakMode:NSLineBreakByCharWrapping
                                                        numberOfLines:2];
    
    [rightTitle setWidth:rightImageView.x - title.right - 2 - 18];
    //    NSLog(@"lent = %f", rightTitle.width);
    
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
        {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:32];
            int min = 0;
            int max = 10000;
            for (int i = min; i <= max; i++)
            {
                NSString *heightString = [NSString stringWithFormat:@"%d 秒", i];
                [tempArray addObject:heightString];
            }
            
            BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:tempArray];
            
            long lastIndex;
            NSInteger lastValue = _thisModel._timeAbsoluteValue;
            if (lastValue)
            {
                lastIndex = max - min;
            }
            else
            {
                lastIndex= lastValue - min;
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
                                    
                                    NSString *heightString = pickerView.selectedValue;
                                    NSString *nowSelectedString = [[heightString componentsSeparatedByString:@" "] firstObject];
                                    
                                    _thisModel._timeAbsoluteValue = [nowSelectedString integerValue];
                                    [BLTSendData sendBasicSetOfInformationData:_thisModel._isShowMetricSystem withHourly:_thisModel._is24HoursTime withUpdateBlock:^(id object, BLTAcceptDataType type) {
                                        if (type == BLTAcceptDataTypeSetBaseInfo) {
                                            NSLog(@"设置时差绝对值成功");
                                        }
                                        else
                                        {
                                            NSLog(@"设置时差绝对值失败");
                                            _thisModel._timeAbsoluteValue = lastValue;
                                        }
                                    }];
                                }
                            }];
        }
            break;
        case 1:
        {
            UIActionSheet * genderChoiceAciotnSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"取消"
                                                                    destructiveButtonTitle:@"正时区"
                                                                         otherButtonTitles:@"负时区", nil];
            genderChoiceAciotnSheet.tag = vSheetTag1;
            [genderChoiceAciotnSheet showInView:self.view];
        
        }
            break;
            
        case 3:
//            [self goToTimeAndClock];
            break;
            
        case 6:
//            [self goToUpdateSystem];
            break;
        case 7:
//            [self goToRecoverDefaultSet];
            break;
        case 8:
//            [self goToRecoverDefaultSet];
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


@end
