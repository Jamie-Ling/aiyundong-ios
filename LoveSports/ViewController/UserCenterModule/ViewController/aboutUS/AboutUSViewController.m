//
//  AboutUSViewController.m
//  LoveSports
//
//  Created by jamie on 15/2/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vVersionAlertTag    3993  //版本提示框tag
#define vCacheAlertTag      3994  //缓存提示框Tag

#define vTableViewMoveLeftX 0  //tableview向左移20,可快速弥补少了的分割线
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#import "AboutUSViewController.h"
#import "MSCustomWebViewController.h"

@interface AboutUSViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listTableView;
    NSMutableArray *_cellTitleArray;       //左侧标题文字数组
    UIImageView *_logoImageView;
}

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LS_Text(@"About Isport");
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back")
                                                                                    target:self
                                                                                  selector:@selector(goBackPrePage)
                                                                                 ImageName:@""];
    
    //
    [self addAllControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateVersion
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8"]];
}


#pragma mark ---------------- 页面布局 -----------------
- (void) addAllControl
{
    _logoImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(kScreenWidth / 2.0,  64.0 + LS_NavBarOffset) withImageName:@"isport_5@2x.png" withImageZoomSize:1.0];
    _logoImageView.frame = CGRectMake(0, LS_NavBarOffset, self.view.width, 150);
    [_logoImageView imageFitForView];
    [self.view addSubview:_logoImageView];
    
    [self.view addSubViewWithRect:CGRectMake(0, _logoImageView.totalHeight + 20, self.width, 0.5)
                        withColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]
                        withImage:nil];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appVersion = [NSString stringWithFormat:@"%@:  %@", LS_Text(@"APP Version"), [infoDictionary objectForKey:@"CFBundleVersion"]];

    _cellTitleArray = [NSMutableArray arrayWithObjects: LS_Text(@"Feedback"), LS_Text(@"Help"), appVersion, nil];

    [self addTableView];
}


- (void) addTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _logoImageView.totalHeight + 21, vOneCellWidth, kScreenHeight - _logoImageView.bottom - kIOS7OffHeight) style:UITableViewStylePlain];
    
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
//        [self clearAllCache];
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
    title.center = CGPointMake(vTableViewMoveLeftX + 16.0 + title.width / 2.0, vOneCellHeight / 2.0);
    [oneCell.contentView addSubview:title];
    
    //右侧箭头
    UIImageView *rightImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vOneCellWidth - vOneCellHeight / 2.0 + 2, vOneCellHeight / 2.0) withImageName:@"右箭头" withImageZoomSize:1.0];
    [oneCell.contentView addSubview:rightImageView];
    [rightImageView setHidden:NO];
    
    [oneCell.contentView addSubview:rightImageView];
    
    if (indexPath.row != 2)
    {
        rightImageView.hidden = NO;
    }
    else
    {
        rightImageView.hidden = YES;
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
    //去除点击的选中色
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    switch (indexPath.row )
    {
        case 2:
        {
           // [self updateVersion];
        }
            break;
        case 0:
        {
            
            MSCustomWebViewController *oneWebVC = [[MSCustomWebViewController alloc] init];
            [oneWebVC setNavTitle:LS_Text(@"Feedback")];
            oneWebVC.hidesBottomBarWhenPushed = YES;
            oneWebVC.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back") target:self selector:@selector(goBackPrePage) ImageName:@""];
            [oneWebVC loadURL:[NSURL URLWithString:kOpinionUrl]];
            [oneWebVC.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:oneWebVC animated:YES];
        }
            break;
        case 1:
        {
            MSCustomWebViewController *oneWebVC = [[MSCustomWebViewController alloc] init];
            [oneWebVC setNavTitle:LS_Text(@"Help")];
            oneWebVC.hidesBottomBarWhenPushed = YES;
            oneWebVC.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back") target:self selector:@selector(goBackPrePage) ImageName:@""];
            [oneWebVC loadURL:[NSURL URLWithString:kHelpUrl]];
            [oneWebVC.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:oneWebVC animated:YES];
            
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
