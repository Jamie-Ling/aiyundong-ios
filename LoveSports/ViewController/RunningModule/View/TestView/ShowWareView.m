//
//  ShowWareView.m
//  LoveSports
//
//  Created by zorro on 15-1-28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShowWareView.h"
#import "BLTManager.h"

@implementation ShowWareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadLabel];
        [self loadTableView];
        
        __weak ShowWareView *safeSelf = self;
        [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model)
        {
            if (safeSelf.tableView)
            {
                [safeSelf.tableView reloadData];
            }
        };
    }
    
    return self;
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height - 20)];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellString = @"wareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    
    BLTModel *model = [BLTManager sharedInstance].allWareArray[indexPath.row];
    cell.textLabel.text = model.bltName;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BLTManager sharedInstance].allWareArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLTModel *model = [BLTManager sharedInstance].allWareArray[indexPath.row];
    [[BLTManager sharedInstance] repareConnectedDevice:model];
    [self dismissPopup];
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
