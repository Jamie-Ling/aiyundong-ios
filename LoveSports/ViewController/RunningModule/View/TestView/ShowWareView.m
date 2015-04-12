//
//  ShowWareView.m
//  LoveSports
//
//  Created by zorro on 15-1-28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShowWareView.h"
#import "BLTManager.h"
#import "WareInfoCell.h"
#import "MJRefresh.h"

@interface ShowWareView ()

@property (nonatomic, assign) BOOL isOpenHead;
@property (nonatomic, strong) UIImageView *headImage;

@end

@implementation ShowWareView

- (instancetype)initWithFrame:(CGRect)frame withOpenHead:(BOOL)open
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _isShowAll = YES;
        _isOpenHead = open;
        [self loadShowModels];
        [self loadTableView];
        // [self loadButton];
        
        __weak ShowWareView *safeSelf = self;
        [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model)
        {
            if (safeSelf.tableView)
            {
                [safeSelf reFreshDevice];
            }
        };
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        _isShowAll = YES;
        _isOpenHead = YES;
        [self loadShowModels];
        [self loadTableView];
        // [self loadButton];
        
        __weak ShowWareView *safeSelf = self;
        [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model)
        {
            if (safeSelf.tableView)
            {
                [safeSelf reFreshDevice];
            }
        };
    }
    
    return self;
}

- (void)reFreshDevice
{
    if (_isShowAll)
    {
        _showArray = [BLTManager sharedInstance].allWareArray;
    }
    else
    {
        [self loadShowModels];
    }
    
    [_tableView reloadData];
}

- (void)loadShowModels
{
    NSArray *array = [LS_BindingID getObjectValue];

    if (array && array.count > 0)
    {
        _showArray = [self addBindingDevices:array];
    }
    else
    {
        _showArray = [BLTManager sharedInstance].allWareArray;
    }
}

- (NSArray *)addBindingDevices:(NSArray *)array
{
    NSMutableArray *showArray = [[NSMutableArray alloc] init];

    for (BLTModel *model in [BLTManager sharedInstance].allWareArray)
    {
        for (NSString  *uuid in array)
        {
            if ([model.bltID isEqualToString:uuid])
            {
                [showArray addObject:model];
            }
        }
    }
    
    return showArray;
}

- (void)loadLabel
{
    _label = [UILabel customLabelWithRect:CGRectMake(0, 0, self.width, 20)];
    
    _label.backgroundColor = [UIColor redColor];
    _label.text = @"扫描到的设备选中连接测试版";
    [self addSubview:_label];
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    //[self loadHeadImage];
    
    DEF_WEAKSELF_(ShowWareView);
    // 添加下拉刷新控件
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [[BLTManager sharedInstance] checkOtherDevices];

        // 模仿5秒后刷新成功
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [weakSelf.tableView.header endRefreshing];
            [weakSelf reFreshDevice];
        });
    }];
    
    [_tableView.header setTitle:@"更新设备." forState:MJRefreshHeaderStateIdle];
    [_tableView.header setTitle:@"正在扫描设备中..." forState:MJRefreshHeaderStatePulling];
    [_tableView.header setTitle:@"下拉刷新,重新搜索" forState:MJRefreshHeaderStateRefreshing];
}

- (void)loadHeadImage
{
    if (_isOpenHead)
    {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _headImage.animationImages = @[UIImageNamed(@"睡觉@2x.png"), UIImageNamed(@"起床.png")];
        _headImage.animationRepeatCount = 9999;
        _headImage.animationDuration = 0.5;
        [_headImage startAnimating];
        _tableView.tableHeaderView = _headImage;
    }
}

- (void)loadButton
{
    [self addSubButtonWithRect:CGRectMake((self.width - 180)/2, _tableView.totalHeight + 12.0, 180, 40)
                     withTitle:@"显示所有设备"
               withSelectTitle:@"只显示绑定的设备"
                     withColor:[UIColor yellowColor]
                       withSel:@selector(showAllDevices:) withTarget:self];
}

- (void)showAllDevices:(UIButton *)button
{
    _isShowAll = !_isShowAll;
    button.selected = !button.selected;
    
    [self reFreshDevice];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellString = @"wareCell";
    WareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell)
    {
        cell = [[WareInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    if (indexPath.row >= _showArray.count)
    {
        return cell;
    }
    
    BLTModel *model = _showArray[indexPath.row];
    [cell updateContentForWareInfoCell:model withHeight:64];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLTModel *model = _showArray[indexPath.row];
    
    if ([_delegate respondsToSelector:@selector(showWareViewSelectHardware:withModel:)])
    {
        [_delegate showWareViewSelectHardware:self withModel:model];
    }
}

- (void)dealloc
{
    [BLTManager sharedInstance].updateModelBlock = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
