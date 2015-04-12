//
//  AlarmClockCell.m
//  LoveSports
//
//  Created by zorro on 15/4/4.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AlarmClockCell.h"

@implementation AlarmClockCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self loadViews];
    }
    return self;
}

- (void)loadViews
{
    _baseView = [[UIView alloc] init];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseView];
    
    _upLine = [[UIView alloc] init];
    _upLine.backgroundColor = UIColorFromHEX(0xcfcdce);
    [_baseView addSubview:_upLine];
    
    _downLine = [[UIView alloc] init];
    _downLine.backgroundColor = UIColorFromHEX(0xcfcdce);
    [_baseView addSubview:_downLine];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:18.0];
    _timeLabel.textColor = [UIColor blackColor];
    [self addSubview:_timeLabel];

    _weekLabel = [[UILabel alloc] init];
    _weekLabel.backgroundColor = [UIColor clearColor];
    _weekLabel.font = [UIFont systemFontOfSize:ACM_WeekFont];
    _weekLabel.textColor = [UIColor blackColor];
    _weekLabel.numberOfLines = 2;
    [self addSubview:_weekLabel];
    
    _cellSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _cellSwitch.onImage = [UIImage imageNamed:@"开启按钮.png"];
    _cellSwitch.offImage = [UIImage imageNamed:@"关闭按钮.png"];
    [_cellSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_cellSwitch];
}

- (void)clickSwitch:(UISwitch *)sender
{
    [sender setOn:sender.on animated:YES];
    _model.isOpen = sender.on;
}

- (void)updateContentForCellFromAlarmModel:(AlarmClockModel *)model WithHeight:(CGFloat)height withIndex:(NSInteger)index
{
    _model = model;
    
    _baseView.frame = CGRectMake(0, 4, self.width, height - 8);
    _upLine.frame = CGRectMake(0, 0, _baseView.width, 0.5);
    _downLine.frame = CGRectMake(0, _baseView.height - 0.5, _baseView.width, 0.5);
    
    _timeLabel.text = model.alarmTime;
    CGSize size = [_timeLabel.text sizeWithFont:_timeLabel.font maxSize:CGSizeMake(120, 99999)];
    _timeLabel.frame = CGRectMake(15, 4, size.width, _baseView.height);
    
    _weekLabel.text = [model showStringForWeekDay];
    // size = [_weekLabel.text sizeWithFont:_weekLabel.font maxSize:CGSizeMake(180, 99999)];
    _weekLabel.frame = CGRectMake(_timeLabel.totalWidth + 18, 4, size.width, _baseView.height);
    
    _cellSwitch.frame = CGRectMake(self.width - (_baseView.height + 10), 4, _baseView.height, _baseView.height);
    _cellSwitch.center = CGPointMake(_cellSwitch.center.x, _baseView.center.y);
    _cellSwitch.on = model.isOpen;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
