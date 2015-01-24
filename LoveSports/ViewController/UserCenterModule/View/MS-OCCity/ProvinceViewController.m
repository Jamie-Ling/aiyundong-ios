//
//  ProvinceViewController.m
//  PAChat
//
//  Created by liu jacky on 13-11-8.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#define vGenderChoiceAciotnSheetTag  1234   //性别选择sheet  Tag
#define vPhotoGetAciotnSheetTag    1235  //相片选择sheet  tag

#define v_signOutButtonHeight (kIPhone4s ? 45 : 55.0 ) //退出按钮高度

#define vTableViewLeaveTop   0   //tableView距离顶部的距离

#define vTableViewMoveLeftX 0  //tableview向左移20
#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vOneCellWidth     (kScreenWidth + vTableViewMoveLeftX)

#import "ProvinceViewController.h"

@interface ProvinceViewController ()

@end

@implementation ProvinceViewController
@synthesize setUserInfoViewCtl = _setUserInfoViewCtl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _provinceArray = [[NSMutableArray alloc]init];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CitiesList.plist" ofType:nil]];
        NSArray *array = [dictionary objectForKey:@"states"];
        for (NSDictionary *dic in array) {
            ProvinceInfo *info = [[ProvinceInfo alloc] init];
            info.citys = [dic objectForKey:@"cities"];
            info.state = [dic objectForKey:@"state"];
            [_provinceArray addObject:info];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"中国";
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(cancel) ImageName:@""];
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    
    [self addTableView];
    
}

- (void) addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, vTableViewLeaveTop, vOneCellWidth, kScreenHeight - vTableViewLeaveTop - kIOS7OffHeight) style:UITableViewStylePlain];
    
    [_tableView setBackgroundColor:kBackgroundColor];
    [[ObjectCTools shared] setExtraCellLineHidden:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.center = CGPointMake(_tableView.centerX - vTableViewMoveLeftX, _tableView.centerY);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = kHoldPlacerColor;
    [self.view addSubview:_tableView];
    
    //解决分割线左侧短-1
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_provinceArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"provinceCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"provinceCell"];
        cell.textLabel.font = kTextFontSize;
        cell.textLabel.textColor = kLabelTitleDefaultColor;
        
        UIImageView * pAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 20, 46.0f / 2.0f - 13.0f / 2.0f, 7.0f, 13.0f)];
        if (kIOSVersions < 7.0) {
            [pAccessoryView setFrame:CGRectMake(kScreenWidth - 40, 46.0f / 2.0f - 13.0f / 2.0f, 7.0f, 13.0f)];
        }
        pAccessoryView.image = [UIImage imageNamed:@"right"];
        [cell.contentView addSubview:pAccessoryView];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    ProvinceInfo *info = [_provinceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = info.state;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProvinceInfo *info = [_provinceArray objectAtIndex:indexPath.row];
    CityViewController *cityCtl = [[CityViewController alloc]init];
    [cityCtl setCityArray:info.citys];
    cityCtl.setUserInfoViewCtl = _setUserInfoViewCtl;
    cityCtl.title = info.state;
    [self.navigationController pushViewController:cityCtl animated:YES];
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



- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
