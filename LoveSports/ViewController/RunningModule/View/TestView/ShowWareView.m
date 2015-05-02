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
@property (nonatomic, assign) BOOL isPop;
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
        [self loadTableView];
        [self reFreshDevice];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withPop:(BOOL)isPop
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _isShowAll = YES;
        _isPop = isPop;
        
        [self loadLabel];
        [self loadTableView];
        [self reFreshDevice];
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
        [self loadTableView];
        [self reFreshDevice];
    }
    
    return self;
}

- (void)reFreshDevice
{
    // 按连接排序.
    [[BLTManager sharedInstance].allWareArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         BLTModel *model1 = obj1;
         BLTModel *model2 = obj2;
         
         if (model1.peripheral.state > model2.peripheral.state)
         {
             return NSOrderedAscending;
         }
         else
         {
             return NSOrderedDescending;
         }
     }];
    
    if (_isPop)
    {
        NSMutableArray *popArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < [BLTManager sharedInstance].allWareArray.count; i++)
        {
            BLTModel *model = [BLTManager sharedInstance].allWareArray[i];
            
            if (model.isBinding)
            {
                [popArray addObject:model];
            }
        }
        
        _showArray = popArray;
    }
    else
    {
        _showArray = [BLTManager sharedInstance].allWareArray;
    }
    
    [_tableView reloadData];
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
    
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"没有发现绑定的设备.";
    _label.textColor = [UIColor blackColor];
    [self addSubview:_label];
    _label.hidden = YES;
    _label.center = CGPointMake(self.width / 2, self.height / 2);
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

        // 模仿3秒后刷新成功
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        cell.frame = CGRectMake(0, 0, self.width, 64);
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
    if (_showArray.count == 0)
    {
        _label.hidden = NO;
    }
    else
    {
        _label.hidden = YES;
    }
    
    return _showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLTModel *model = _showArray[indexPath.row];

    if (_isPop)
    {
        SHOWMBProgressHUD(@"连接设备中...", nil, nil, NO, 2);

        model.isBinding = YES;
        [[BLTManager sharedInstance] repareConnectedDevice:model];
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(showWareViewSelectHardware:withModel:)])
        {
            [_delegate showWareViewSelectHardware:self withModel:model];
        }
    }
}

- (void)dealloc
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
