//
//  UserCenterVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vVersionAlertTag    3993  //版本提示框tag
#define vCacheAlertTag      3994  //缓存提示框Tag

#define vTableViewMoveLeftX 20  //tableview向左移20,快速弥补少了的分割线
#define vOneCellHeight    (kIPhone4s ? 44 : 50.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#import "UserCenterVC.h"

@interface UserCenterVC()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_listTableView;
    NSArray *_cellTitleArray;
    UIWebView *_phoneCallWebView;
}

@end


@implementation UserCenterVC

- (void)viewDidLoad
{
    self.title = @"更多";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    //初始化
    _cellTitleArray = [NSArray arrayWithObjects:@"账号管理",@"", @"爱运动手环x", @"绑定硬件", @"", @"消息", @"朋友",@"", @"爱运动商城", @"用户信息", @"", @"求点赞", @"清除缓存", @"关与爱运动+", nil];
    
    //tableview
    [self addTableView];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshCacheCell];
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

- (void) accountManage
{
    NSLog(@"账号管理");
}

- (void) intelligentBracelet
{
    NSLog(@"爱运动手环");
}

- (void) bindingDevice
{
    NSLog(@"绑定硬件");
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
}

- (void) userInfo
{
    NSLog(@"用户信息");
}

- (void) praise
{
    NSLog(@"求点赞");
}

- (void) clearCache
{
    NSLog(@"清除缓存");
}

- (void) aboutUs
{
    NSLog(@"关与爱运动");
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
    
}

/**
 *  刷新界面
 */
- (void) refreshMainPage
{
    [_listTableView reloadData];
}


//刷成缓存Cell
- (void) refreshCacheCell
{

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
    CGRect titleFrame = CGRectMake(0, 0, 100, vOneCellHeight);
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
    UIImageView *rightImageView = [[ObjectCTools shared] getACustomImageViewWithCenter:CGPointMake(vOneCellWidth - vOneCellHeight / 2.0 + 5, vOneCellHeight / 2.0) withImageName:@"right.png" withImageZoomSize:1.0];
    [oneCell.contentView addSubview:rightImageView];
    
    
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
            
        }
            break;

        default:
            break;
    }
    
    [[ObjectCTools shared] setLableSizeToFit:rightTitle withMaxWidth:180.0 withminWidth:0 withMaxHeight:vOneCellHeight withminHeight:vOneCellHeight withFontToFitWidth:NO];
    //    [rightTitle sizeToFit]; // 文字如果变小，中心对不准确，因此再直接适配一次
    [rightTitle setCenter:CGPointMake(rightImageView.x - rightTitle.width / 2.0 - 12.0, vOneCellHeight / 2.0)];
    
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
        case 2:
        {
            [self intelligentBracelet];
        }
            break;
        case 3:
        {
            [self bindingDevice];
        }
            break;
        case 5:
        {
            [self message];
        }
            break;
        case 6:
        {
            [self friends];
        }
            break;
        case 8:
        {
            [self ourShop];
        }
            break;
        case 9:
        {
            [self userInfo];
        }
            break;
        case 11:
        {
            [self praise];
        }
            break;
        case 12:
        {
            [self clearCache];
        }
            break;
        case 13:
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
}





@end
