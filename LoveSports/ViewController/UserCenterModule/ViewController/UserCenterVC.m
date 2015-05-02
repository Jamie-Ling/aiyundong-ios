//
//  UserCenterVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//  Jamie  --- 用户中心


#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vVersionAlertTag    3993  //版本提示框tag
#define vCacheAlertTag      3994  //缓存提示框Tag

#define vTableViewMoveLeftX 0  //tableview向左移20,可快速弥补少了的分割线
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)



#import "UserCenterVC.h"
#import "FlatRoundedButton.h"
#import "ALBatteryView.h"
#import "UserInfoViewController.h"
#import "MSCustomWebViewController.h"
#import "AccountManageViewController.h"
#import "BraceletInfoModel.h"
#import "BraceletInfoViewController.h"
#import "BindIngDeviceViewController.h"
#import "HomeVC.h"
#import "AboutUSViewController.h"
#import "AlarmClockModel.h"
#import "RemindModel.h"

@interface UserCenterVC()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_listTableView;
    NSMutableArray *_cellTitleArray;       //左侧标题文字数组
    NSArray *_cellImageArray;       //左侧图标数组
    UIWebView *_phoneCallWebView;
    UserInfoViewController *_userInfoVC;
    AccountManageViewController *_AccountManageVC;
    BraceletInfoViewController *_braceletInfoVC;
    BraceletInfoModel *_showModel;
    AboutUSViewController *_aboutUSVC;
}
@property (nonatomic, assign) NSInteger _dumpEnergy;  //剩余电量

@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, strong) BLTModel *braceModel;
@end


@implementation UserCenterVC
@synthesize _dumpEnergy, _userHeadPhoto;

- (void)viewDidLoad
{
    self.title = @"设置";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    _userInfo = [UserInfoHelp sharedInstance].userModel;
    _braceModel = [UserInfoHelp sharedInstance].braceModel;
    
    //初始化
    _cellImageArray = [NSMutableArray arrayWithObjects:@"账号管理", @"用户信息",@"", @"爱动运手环", @"梆定硬件", @"", @"消息", @"朋友", @"",@"爱运动商城",  @"", @"求点赞", @"关于爱运动商城", nil];
    
    // @"消息", @"朋友",@"",
    _cellTitleArray = [NSMutableArray arrayWithObjects:@"账号管理", @"用户信息",@"", @"爱动运手环", @"绑定硬件", @"", @"消息", @"朋友", @"",@"爱运动商城",  @"", @"求点赞", @"关于爱运动", nil];
    
    //tableview
    [self addTableView];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    //刷新界面
    [self updateElecQuantity];
    
    DEF_WEAKSELF_(UserCenterVC);
    [BLTManager sharedInstance].elecQuantityBlock = ^{
        [weakSelf updateElecQuantity];
    };
}

// 更新电量
- (void)updateElecQuantity
{
    //得到电量
    if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
    {
        _dumpEnergy = [BLTManager sharedInstance].elecQuantity; //_showModel._deviceElectricity;
        _showModel._deviceVersion = [NSString stringWithFormat:@"VB %ld", (long)[BLTManager sharedInstance].model.hardVersion];
    }
    else
    {
        _dumpEnergy = 0;
        _showModel._deviceVersion = @"";
    }
    
    [self refreshMainPage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTManager sharedInstance].elecQuantityBlock = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage{
    
    if ([self.navigationController.viewControllers.lastObject isKindOfClass:self.class])
    {
        /*
        //动画方式消失
        CATransition *animation = [CATransition animation];
        [animation setDuration:1.0];
        [animation setType:kCATransitionFade]; //淡入淡出
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController.view.layer addAnimation:animation forKey:nil ];
        
        [self.navigationController popViewControllerAnimated:NO];
        
        HomeVC *temoHomeVC = [ObjectCTools shared].getAppDelegate._mainNavigationController.viewControllers.firstObject;
        [temoHomeVC.tabBar setUserInteractionEnabled:NO];
        
        [self performSelector:@selector(setNavigationBarUserEnabled) withObject:nil afterDelay:0.8];*/
        
        [UIView transitionWithView:self.navigationController.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.navigationController popViewControllerAnimated:NO];
                        } completion:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) setNavigationBarUserEnabled
{
    HomeVC *temoHomeVC = [ObjectCTools shared].getAppDelegate._mainNavigationController.viewControllers.firstObject;
    [temoHomeVC.tabBar setUserInteractionEnabled:YES];
}

- (void) accountManage
{
    // 暂时取消用户登录这块。等服务器恢复。
    return;
    NSLog(@"账号管理");
    if (!_AccountManageVC)
    {
        _AccountManageVC = [[AccountManageViewController alloc] init];
    }
    [self.navigationController pushViewController:_AccountManageVC animated:YES];
}

- (void) intelligentBracelet
{
    NSLog(@"爱运动手环");
    if (!_braceletInfoVC)
    {
        _braceletInfoVC = [[BraceletInfoViewController alloc] init];
    }
    _braceletInfoVC._thisBraceletInfoModel = _showModel;
    [self.navigationController pushViewController:_braceletInfoVC animated:YES];
}

- (void) bindingDevice
{
    NSLog(@"绑定硬件");
    BindIngDeviceViewController *bindIngDeviceVC = [[BindIngDeviceViewController alloc] init];
    [self.navigationController pushViewController:bindIngDeviceVC animated:YES];
}

- (void) message
{
    NSLog(@"消息");
}

- (void) friends
{
    NSLog(@"朋友");
}

- (void) ourShop
{
    NSLog(@"爱运动商城");
    
    MSCustomWebViewController *oneWebVC = [[MSCustomWebViewController alloc] init];
    [oneWebVC setNavTitle:@"爱运动商城"];
    oneWebVC.hidesBottomBarWhenPushed = YES;
    oneWebVC.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"  返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    [oneWebVC loadURL:[NSURL URLWithString:kShopUrl]];
    [oneWebVC.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:oneWebVC animated:YES];
}

- (void) userInfoVC
{
    NSLog(@"用户信息");
    if (!_userInfoVC)
    {
        _userInfoVC = [[UserInfoViewController alloc] init];
    }
    _userInfoVC._thisModel = _showModel;
    [self.navigationController pushViewController:_userInfoVC animated:YES];
}

- (void) praise
{
    NSLog(@"求点赞,跳转至测试");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8"]];
}

- (void) clearCache
{
    NSLog(@"清除缓存");
    UIAlertView *cacheAlert =  [[UIAlertView alloc]initWithTitle:@"确定清除缓存?"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    [cacheAlert setTag:vCacheAlertTag];
    [cacheAlert show];
    
}

- (void) clearAllCache
{
    
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSString *filePath = cachesDir;
    
    //     清除图片缓存：
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    //清除剩下的缓存
    [self clearFileWithPath:filePath withExtension:nil];
    
    [UIView showAlertView:@"清除缓存成功" andMessage:nil];
    
}

- (void) clearFileWithPath: (NSString *) fullPath withExtension: (NSString *) extension
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    //    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = homePath;
    if (![NSString isNilOrEmpty:fullPath ])
    {
        filePath = fullPath;
    }
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([NSString isNilOrEmpty:extension ])
        {
            [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
        }
        else if ([[filename pathExtension] isEqualToString:extension])
        {
            
            [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}



- (void) aboutUs
{
    NSLog(@"关与爱运动");
    if (!_aboutUSVC)
    {
        _aboutUSVC = [[AboutUSViewController alloc] init];
    }
    [self.navigationController pushViewController:_aboutUSVC animated:YES];
}


#pragma mark ---------------- 页面布局 -----------------
- (void) addTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, vTableViewLeaveTop, vOneCellWidth, kScreenHeight - vTableViewLeaveTop - kIOS7OffHeight) style:UITableViewStylePlain];
    
    [_listTableView setBackgroundColor:kBackgroundColor];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_listTableView setTableFooterView:view];
    
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

/**
 *  刷新界面
 */
- (void) refreshMainPage
{
    [_listTableView reloadData];
}

#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == vCacheAlertTag && buttonIndex == 1)
    {
        [self clearAllCache];
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
    NSString *leftText = [_cellTitleArray objectAtIndex:indexPath.row];
    
    if ([NSString isNilOrEmpty:leftText])
    {
        oneCell.userInteractionEnabled = NO;
        return oneCell;
    }
    
    //图标
    UIImageView *actionImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vTableViewMoveLeftX + 28.0, vOneCellHeight / 2.0) withImageName:[_cellImageArray objectAtIndex:indexPath.row] withImageZoomSize:1.0];
    [oneCell.contentView addSubview:actionImageView];
    
    // left label
    CGRect titleFrame = CGRectMake(0, 0, 140, vOneCellHeight);
    UILabel *title = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                 backgroundColor:[UIColor clearColor]
                                                            text:[_cellTitleArray objectAtIndex:indexPath.row]
                                                       textColor:kLabelTitleDefaultColor
                                                            font:[UIFont systemFontOfSize:14]
                                                   textAlignment:NSTextAlignmentLeft
                                                   lineBreakMode:0
                                                   numberOfLines:0];
    title.center = CGPointMake(vTableViewMoveLeftX + actionImageView.width + title.width / 2.0 + 15+ 12, vOneCellHeight / 2.0);
    [oneCell.contentView addSubview:title];
    
    //右侧箭头
    UIImageView *rightImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vOneCellWidth - vOneCellHeight / 2.0 + 2, vOneCellHeight / 2.0) withImageName:@"右箭头" withImageZoomSize:1.0];
    [oneCell.contentView addSubview:rightImageView];
    [rightImageView setHidden:NO];
    
    //右侧titlelable
    UILabel *rightTitle = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                      backgroundColor:[UIColor clearColor]
                                                                 text:@""
                                                            textColor:kLabelTitleDefaultColor
                                                                 font:[UIFont systemFontOfSize:14]
                                                        textAlignment:NSTextAlignmentLeft
                                                        lineBreakMode:0
                                                        numberOfLines:2];
    [oneCell.contentView addSubview:rightTitle];
    switch (indexPath.row)
    {
        case 0:
        {
            /*
            FlatRoundedButton *userImageButton = [[ObjectCTools shared] getARoundedButtonWithSize:vOneCellHeight - 13 withImageUrl:_userInfo.avatar];
            [userImageButton setCenter:CGPointMake(rightImageView.x - userImageButton.width / 2.0 - 12.0, vOneCellHeight / 2.0)];
            
            userImageButton.userInteractionEnabled = NO;
             */
            
            UIView *headImage = [[UIView alloc] initWithFrame:CGRectMake(self.width - 88, (vOneCellHeight - 36) / 2.0, 36, 36)];
            headImage.backgroundColor = [UIColor clearColor];
            headImage.userInteractionEnabled = NO;
            headImage.layer.masksToBounds = YES;
            headImage.layer.cornerRadius = 18;
            headImage.image = [[DataShare sharedInstance] getHeadImage];
            [oneCell.contentView addSubview:headImage];
        }
            break;
        case 3:
        {
            ALBatteryView *batteryView = [[ALBatteryView alloc] initWithFrame:CGRectMake(0, 0, 12.8 * 2, 12.8 * 2)];
                [batteryView setCenter:CGPointMake(rightImageView.x - batteryView.width / 2.0 - 12.0, vOneCellHeight / 2.0)];
            
            if (_dumpEnergy < 0)
            {
                _dumpEnergy = 0;
            }
            if (_dumpEnergy > 100)
            {
                _dumpEnergy = 10;
            }
            
            [batteryView setBatteryLevelWithAnimation:NO forValue:_dumpEnergy inPercent:YES];
            [oneCell.contentView addSubview:batteryView];
            
            if (_dumpEnergy == 0)
            {
                [rightTitle setText:@"0%"];
            }
            else
            {
                [rightTitle setText:[NSString stringWithFormat:@"%.0ld%%", (long)_dumpEnergy]];
            }
            
            [rightTitle sizeToFit];
            [rightTitle setCenter:CGPointMake(batteryView.x - 2 - rightTitle.width / 2.0, vOneCellHeight / 2.0)];
            [oneCell.contentView addSubview:rightTitle];
        }
            break;
        case 5:
        {
            [rightTitle setText:@"收获地址? 订单?"];
            [rightTitle sizeToFit];
            [rightTitle setCenter:CGPointMake(rightImageView.x - 12 - rightTitle.width / 2.0, vOneCellHeight / 2.0)];
            [oneCell.contentView addSubview:rightTitle];
        }
            break;
        case 10:
        {
            [rightTitle setText:@"    帮助  \n意见反馈"];
            [rightTitle sizeToFit];
            [rightTitle setCenter:CGPointMake(rightImageView.x - 12 - rightTitle.width / 2.0, vOneCellHeight / 2.0)];
            [oneCell.contentView addSubview:rightTitle];
        }
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == 0)
    {
        rightImageView.hidden = YES;
        oneCell.userInteractionEnabled = NO;
    }
    else
    {
        rightImageView.hidden = NO;
        oneCell.userInteractionEnabled = YES;
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
        {
            [self accountManage];
        }
            break;
        case 3:
        {
            [self intelligentBracelet];
        }
            break;
        case 4:
        {
            [self bindingDevice];
        }
            break;
        case 6:
        {
            [self message];
        }
            break;
        case 7:
        {
            [self friends];
        }
            break;
        case 9:
        {
            [self ourShop];
        }
            break;
        case 1:
        {
            [self userInfoVC];
        }
            break;
        case 11:
        {
            [self praise];
        }
            break;
        case 900:
        {
            [self clearCache];
        }
            break;
        case 12:
        {
            [self aboutUs];
        }
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
