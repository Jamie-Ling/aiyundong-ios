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

@implementation ShowWareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.contents = (id)[UIImage image:@"login_background@2x.jpg"].CGImage;
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellString = @"wareCell";
    WareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell)
    {
        cell = [[WareInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    BLTModel *model = [BLTManager sharedInstance].allWareArray[indexPath.row];
    [cell updateContentForWareInfoCell:model withHeight:60.0];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BLTManager sharedInstance].allWareArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLTModel *model = [BLTManager sharedInstance].allWareArray[indexPath.row];
    
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
