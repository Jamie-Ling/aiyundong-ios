//
//  AccountManageViewController.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//  Jamie  --- 用户中心


#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vVersionAlertTag    3993  //版本提示框tag
#define vCacheAlertTag      3994  //缓存提示框Tag

#define vTableViewMoveLeftX 0  //tableview向左移20,快速弥补少了的分割线
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#import "AccountManageViewController.h"
#import "FlatRoundedButton.h"
#import "ALBatteryView.h"
#import "UserInfoViewController.h"
#import "MSCustomWebViewController.h"
#import "FlatRoundedButton.h"

@interface AccountManageViewController()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_listTableView;
    NSArray *_userInfoValueArray;       //用户信息数组
    NSArray *_userInfoKeyArray;       //用户信息key的数组
    UIWebView *_phoneCallWebView;
    UserInfoViewController *_userInfoVC;
    BOOL _isEditing;  //是否是在编辑状态中
    UIButton *_signOutButton;
}
@property (nonatomic, assign) CGFloat _dumpEnergy;  //剩余电量

@end


@implementation AccountManageViewController

- (void)viewDidLoad
{
    self.title = @"帐号管理";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:@"编辑" target:self selector:@selector(editTableView) ImageName:@""];
    
    
    //tableview
    [self addTableView];
    
    [self addSignOutButton];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //刷新界面
    [self refreshMainPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addAccount
{
    NSLog(@"添加帐号，请跳转至登录页面");
 
    [[[ObjectCTools shared] getAppDelegate] signOut];
}


- (void) editTableView
{
    [_listTableView setEditing:!_listTableView.editing animated:YES];
    _isEditing = _listTableView.editing;
    if (_isEditing)
    {
        self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:@"保存" target:self selector:@selector(editTableView) ImageName:@""];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage image:@""] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:button];
        [_signOutButton setHidden:YES];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
        self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:@"编辑" target:self selector:@selector(editTableView) ImageName:@""];
        [_signOutButton setHidden:NO];
    }
    if (_userInfoValueArray.count == 0)
    {
        //帐号全部删除了，跳转至登录页面
        [[[ObjectCTools shared] getAppDelegate] addLoginView:YES];
    }
    [_listTableView reloadData];
}

- (void) signOut
{
    [[ObjectCTools shared] userDeletOneUserInfo:0];
    
    [[[ObjectCTools shared] getAppDelegate] signOut];
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

- (void) addSignOutButton
{
    CGRect signOutButtonFrame = CGRectMake(0, self.view.height - 28.0 - kButtonDefaultHeight - kIOS7OffHeight, self.view.width, kButtonDefaultHeight);
    _signOutButton = [[ObjectCTools shared] getACustomButtonNoBackgroundImage:signOutButtonFrame
                                                                     backgroudColor:kButtonBackgroundColor titleNormalColor:kPageTitleColor titleHighlightedColor:[UIColor colorWithRed:153.0/255.0 green:109.0/255.0 blue:20.0/255.0 alpha:1.0]  title:@"退出登录" font:kButtonFontSize cornerRadius:0 borderWidth:0 borderColor:nil accessibilityLabel:@"signOutButton"];
    [_signOutButton addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signOutButton];
}

/**
 *  刷新界面
 */
- (void) refreshMainPage
{
    _userInfoValueArray = nil;
    _userInfoKeyArray = nil;
    
    _userInfoKeyArray = [[ObjectCTools shared] userGetAllUserInfoKey];
    _userInfoValueArray = [[ObjectCTools shared] userGetAllUserInfo];
    
    if ((_userInfoValueArray.count == 0) && (!_isEditing))
    {
        //帐号全部删除了，跳转至登录页面
        [[[ObjectCTools shared] getAppDelegate] addLoginView:YES];
    }
    
    [_listTableView reloadData];
}

#pragma mark ---------------- UIAlertView delegate -----------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark ---------------- TableView delegate -----------------

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isEditing)
    {
        return [_userInfoKeyArray count];
    }
    return [_userInfoKeyArray count] + 1;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //不使用复用机制
    UITableViewCell *oneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    
    //昵称
    NSString *leftText;
    //头像
    FlatRoundedButton *userImageButton;
    if (indexPath.row != _userInfoValueArray.count)
    {
        leftText = [[_userInfoValueArray objectAtIndex:indexPath.row] objectForKey:kUserInfoOfNickNameKey];
        
        //头像
        userImageButton = [[ObjectCTools shared] getARoundedButtonWithSize:vOneCellHeight - 13 withImageUrl:[[_userInfoValueArray objectAtIndex:indexPath.row] objectForKey:kUserInfoOfHeadPhotoKey]];
        
        [userImageButton setCenter:CGPointMake(vTableViewMoveLeftX + 28.0, vOneCellHeight / 2.0)];
        
        userImageButton.userInteractionEnabled = NO;
        [oneCell.contentView addSubview:userImageButton];
    }
    
    // left label
    CGRect titleFrame = CGRectMake(0, 0, 140, vOneCellHeight);
    UILabel *title = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                 backgroundColor:[UIColor clearColor]
                                                            text:leftText
                                                       textColor:kLabelTitleDefaultColor
                                                            font:[UIFont systemFontOfSize:14]
                                                   textAlignment:NSTextAlignmentLeft
                                                   lineBreakMode:0
                                                   numberOfLines:0];
    title.center = CGPointMake(vTableViewMoveLeftX + userImageButton.width + title.width / 2.0 + 15+ 12, vOneCellHeight / 2.0);
    [oneCell.contentView addSubview:title];
    
    //右侧箭头
    UIImageView *rightImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vOneCellWidth - vOneCellHeight / 2.0 + 2, vOneCellHeight / 2.0) withImageName:@"右箭头" withImageZoomSize:1.0];
    [oneCell.contentView addSubview:rightImageView];
    [rightImageView setHidden:NO];
    
    if (indexPath.row == 0)
        {
            [rightImageView setImage:[UIImage imageNamed:@"选择按钮"]];
        }
    if (indexPath.row == _userInfoValueArray.count)
    {
        [userImageButton removeFromSuperview];
        
        //图标
        UIImageView *actionImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vTableViewMoveLeftX + 28.0, vOneCellHeight / 2.0) withImageName:@"加号" withImageZoomSize:2.0];

        [oneCell.contentView addSubview:actionImageView];
      
        [title setText:@"添加账号"];
        title.center = CGPointMake(vTableViewMoveLeftX + vOneCellHeight - 13 + title.width / 2.0 + 15+ 12, vOneCellHeight / 2.0);
        [rightImageView removeFromSuperview];
    }
    
    if (_isEditing)
    {
        rightImageView.hidden = YES;
    }
    else
    {
        rightImageView.hidden = NO;
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
    
    if (indexPath.row != _userInfoValueArray.count)
    {
        if (indexPath.row == 0)
        {
            NSLog(@"还是此账户");
            return;
        }
        [[ObjectCTools shared] userChoiceOneUserInfo:indexPath.row];
        [self refreshMainPage];
    }
    else
    {
        [self addAccount];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [cell setBackgroundColor:backGroundColor];
    
    //解决分割线左侧短-2
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


// 删除功能----------------------------------
//能否修改cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _userInfoKeyArray.count)
    {
        return YES;
    }
    return NO;
}

//首先激活编辑功能，即左滑出按钮。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if (indexPath.row != _userInfoKeyArray.count)
    {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}
// 删除事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除cell
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
            //删除帐号
            [[ObjectCTools shared] userDeletOneUserInfo:indexPath.row];
            [self refreshMainPage];
        
    }
}

// 后面的是删除按钮文案为中文。 默认是英文的delete
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


@end
