//
//  TimeZoneChoiceViewController.m
//  LoveSports
//
//  Created by jamie on 15/4/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//


#define vTableViewLeaveTop   0   //tableView距离顶部的距离
#define vTableViewMoveLeftX 0  //tableview向左移20
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#import "TimeZoneChoiceViewController.h"
#import "ShowTimeZone.h"

@interface TimeZoneChoiceViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listTableView;

    NSMutableArray *_timeZoneArray;
}

@end

@implementation TimeZoneChoiceViewController
@synthesize _choiceIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS_Text(@"Select Time Zone");
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back")
                                                                                    target:self
                                                                                  selector:@selector(goBackPrePage)
                                                                                 ImageName:@""];
        //tableview
    
    //获取所有的时区名字
    NSArray *getTimeZoneArray = [NSTimeZone knownTimeZoneNames];
    _timeZoneArray  = [[NSMutableArray alloc] initWithCapacity:32];
    
    NSString *string = [UserInfoHelp sharedInstance].userModel.activePlace;
    _choiceIndex = 0;

    for (int i = 0; i < getTimeZoneArray.count; i++)
    {
        NSString *tempTimeZoneString = getTimeZoneArray[i];
        ShowTimeZone *model = [ShowTimeZone simpleWithString:tempTimeZoneString];
        [_timeZoneArray addObject:model];
        
        if ([string isEqualToString:model.showPlace])
        {
            _choiceIndex = i;
        }
    }
    
    [_timeZoneArray insertObject:_timeZoneArray[_choiceIndex] atIndex:0];
    _choiceIndex = 0;

    [self addTableView];
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

#pragma mark ---------------- 页面布局 -----------------
- (void) addTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, vTableViewLeaveTop, vOneCellWidth, kScreenHeight - vTableViewLeaveTop - 64 + LS_NavBarOffset) style:UITableViewStylePlain];
    
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


#pragma mark ---------------- TableView delegate -----------------

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_timeZoneArray count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ShowTimeZone *model = [_timeZoneArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:model.showString];
    
    if (indexPath.row == _choiceIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
        //设置点选颜色
    //    [oneCell setSelectedBackgroundView:[[UIView alloc] initWithFrame:oneCell.frame]];
    //    //kHexRGB(0x0e822f)
    //    oneCell.selectedBackgroundView.backgroundColor = kHexRGBAlpha(0x0e822f, 0.6);
    //
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击第%ld行",  (long)indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //去除点击的选中色
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    _choiceIndex = indexPath.row;
    
    if (self.choiceOverBlock)
    {
        self.choiceOverBlock(indexPath.row, cell.textLabel.text);
    }
    
    [[UserInfoHelp sharedInstance].userModel updateTimeZone:_timeZoneArray[indexPath.row]];
    
    [_listTableView reloadData];
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


@end
