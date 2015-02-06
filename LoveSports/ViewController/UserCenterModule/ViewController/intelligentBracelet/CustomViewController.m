//
//  CustomViewController.m
//  LoveSports
//
//  Created by jamie on 15/1/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//
#define vMetricSystemTag   10099
#define vHandTag   10100


#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vTableViewMoveLeftX 0  //tableview向左移20
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#define vSectionHeight    30

#import "CustomViewController.h"
#import "UpdateBraceletNameViewController.h"


@interface CustomViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSArray *_titleArray;
    NSArray *_cellImageArray;
    
    UITableView *_listTableView;
    BOOL _showDistance;
}

@end

@implementation CustomViewController
@synthesize _thisModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"自定义";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    NSArray *list1Array = [NSArray arrayWithObjects:@"手环名称 ：", @"佩戴方向 ：", nil];
    NSArray *list2Array = [NSArray arrayWithObjects:@"时间", @"步数", @"卡路里", @"距离", @"公制", nil];
    _titleArray = [NSArray arrayWithObjects:list1Array, list2Array, nil];
    
    _cellImageArray = [NSArray arrayWithObjects:@"头像",@"头像", @"头像", @"头像", @"头像", nil];
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated: NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    _showDistance = _thisModel._showDistance;
    [self reloadUserInfoTableView];
}

- (void) reloadUserInfoTableView
{
    [_listTableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //将要消失时更新存储
    [[BraceletInfoModel getUsingLKDBHelper] insertToDB:_thisModel];
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

- (void) setNickName
{
    NSLog(@"修改手环名字");
    UpdateBraceletNameViewController *updateBraceletNameVC = [[UpdateBraceletNameViewController alloc] init];
    updateBraceletNameVC._thisModel = _thisModel;
    updateBraceletNameVC._lastNickName = _thisModel._name;
    [self.navigationController pushViewController:updateBraceletNameVC animated:YES];
    
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


- (void) changeSwith:(UISwitch *) theSwitch
{
    if (theSwitch.tag == 0)
    {
        NSLog(@"更改是否显示时间的状态：%d", theSwitch.on);
        _thisModel._showTime = theSwitch.on;
        
        return;
    }
    if (theSwitch.tag == 1)
    {
        NSLog(@"更改是否显示步数的状态：%d", theSwitch.on);
        _thisModel._showSteps = theSwitch.on;
        
        return;
    }
    if (theSwitch.tag == 2)
    {
        NSLog(@"更改是否显示卡路里的状态：%d", theSwitch.on);
        _thisModel._showKa = theSwitch.on;
        
        return;
    }
    if (theSwitch.tag == 3)
    {
        NSLog(@"更改是否显示距离的状态：%d", theSwitch.on);
        _thisModel._showDistance = theSwitch.on;
        _showDistance = theSwitch.on;
        [self reloadUserInfoTableView];
        return;
    }

}

#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"check index = %ld", (long)buttonIndex);
    if (buttonIndex == 1)
    {
        
    }
}

#pragma mark ---------------- actionSheet delegate -----------------
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == vMetricSystemTag)
    {
        switch (buttonIndex)
        {
            case  0:
            {
                if (_thisModel._isShowMetricSystem)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成公制");
                    _thisModel._isShowMetricSystem = YES;
                }
            }
                break;
            case 1:
            {
                if (!_thisModel._isShowMetricSystem)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成英制");
                    _thisModel._isShowMetricSystem = NO;
                    
                }
            }
                break;
            case 2:
                return;
                break;
            default:
                break;
        }
        [BLTSendData sendBasicSetOfInformationData:_thisModel._isShowMetricSystem withHourly:_thisModel._is24HoursTime  withUpdateBlock:^(id object, BLTAcceptDataType type) {
            if (type == BLTAcceptDataTypeSetBaseInfo) {
                NSLog(@"设置公英制成功");
                [self reloadUserInfoTableView];
            }
            else
            {
                NSLog(@"设置公英制失败");
                _thisModel._isShowMetricSystem = !_thisModel._isShowMetricSystem;
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
                if (_thisModel._isLeftHand)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成左手");
                    _thisModel._isLeftHand = YES;
                    [self reloadUserInfoTableView];
                }
            }
                break;
            case 1:
            {
                if (!_thisModel._isLeftHand)
                {
                    return;
                }
                else
                {
                    NSLog(@"改成右手");
                    _thisModel._isLeftHand = NO;
                    [self reloadUserInfoTableView];
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


#pragma mark ---------------- TableView delegate -----------------

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 && !_showDistance)
    {
        return [[_titleArray objectAtIndex:section] count] - 1;
    }
    return [[_titleArray objectAtIndex:section] count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //不使用复用机制
    UITableViewCell *oneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    
    //label
    CGRect titleFrame = CGRectMake(0, 0, 100, vOneCellHeight);
    UILabel *title = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                 backgroundColor:[UIColor clearColor]
                                                            text:[[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
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
    
    UISwitch *slideSwitchH = [[UISwitch alloc]init];
    [slideSwitchH setFrame:CGRectMake(0, 0, 164.0, 26.0)];
    slideSwitchH.center = CGPointMake(rightImageView.centerX  - slideSwitchH.width / 2.0, vOneCellHeight / 2.0);
    [slideSwitchH setOnTintColor:kButtonBackgroundColor];
    slideSwitchH.tag = indexPath.row;
    [slideSwitchH addTarget:self action:@selector(changeSwith:) forControlEvents:UIControlEventValueChanged];
    
    
    //图标
    UIImageView *actionImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vTableViewMoveLeftX + 32.0, vOneCellHeight / 2.0) withImageName:[_cellImageArray objectAtIndex:indexPath.row] withImageZoomSize:1.0];
    
    
    if (indexPath.section == 0)
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    [rightTitle setText:_thisModel._name];
                    [rightTitle sizeToFit];
                    [rightTitle setCenter:CGPointMake(title.right + 5 + rightTitle.width / 2.0, vOneCellHeight / 2.0)];
                    [oneCell.contentView addSubview:rightTitle];
                }
                    break;
                case 1:
                {
                    NSString *handString = @"左手";
                    if (!_thisModel._isLeftHand)
                    {
                        handString = @"右手";
                    }
                    [rightTitle setText:handString];
                    [rightTitle sizeToFit];
                    [rightTitle setCenter:CGPointMake(rightImageView.x - 20 - rightTitle.width / 2.0, vOneCellHeight / 2.0)];
                    [oneCell.contentView addSubview:rightTitle];
                }
                    break;
                    
                default:
                    break;
            }
        }
    
    if ((indexPath.section == 1) && (indexPath.row != [[_titleArray objectAtIndex:1] count] - 1))
    {
        [oneCell.contentView addSubview:actionImageView];
        title.center = CGPointMake(vTableViewMoveLeftX + actionImageView.width + title.width / 2.0 + 15+ 10, vOneCellHeight / 2.0);
        
        [rightImageView setHidden:YES];
        oneCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        [oneCell.contentView addSubview:slideSwitchH];
        
        switch (indexPath.row)
        {
            case 0:
            {
                slideSwitchH.on = _thisModel._showTime;
            }
                break;
            case 1:
            {
                slideSwitchH.on = _thisModel._showSteps;
            }
                break;
            case 2:
            {
                slideSwitchH.on = _thisModel._showKa;
            }
                break;
            case 3:
            {
                slideSwitchH.on = _thisModel._showDistance;
            }
                break;
            default:
                break;
        }
        
    }
    
    
    if ((indexPath.section == 1) && (indexPath.row == [[_titleArray objectAtIndex:1] count] - 1))
    {
        NSString *gongzhi = @"公制";
        if (!_thisModel._isShowMetricSystem)
        {
            gongzhi = @"英制";
        }
        [title setText:gongzhi];
        title.center = CGPointMake(vTableViewMoveLeftX + actionImageView.width + title.width / 2.0 + 15+ 10, vOneCellHeight / 2.0);
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
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row )
        {
            case 0:
                [self setNickName];
                break;
            case 1:
                [self choiceHand];
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 1)
    {
        switch (indexPath.row )
        {
            case 4:
                //_isShowMetricSystem
                [self choiceMetricSystem];
                break;
            default:
                break;
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NSString isNilOrEmpty:[[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]])
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
    if ([NSString isNilOrEmpty:[[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]])
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return vSectionHeight;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vOneCellWidth, vSectionHeight)];
    [sectionView setBackgroundColor:kRGB(243.0, 243.0, 243.0)];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(vTableViewMoveLeftX + 16.0, 0, vOneCellWidth - (vTableViewMoveLeftX + 16.0), vSectionHeight)];
    [aLabel setBackgroundColor:[UIColor clearColor]];
    [aLabel setTextColor:kPageTitleColor];
    [aLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [aLabel setText:@"显示项目"];
    
    [sectionView addSubview: aLabel];
    
    return sectionView;
}

@end
