//
//  WareInfoCell.m
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "WareInfoCell.h"

@implementation WareInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self loadAllViews];
    }
    
    return self;
}

- (void)loadAllViews
{
    _baseView = [[UIView alloc] init];
    _baseView.backgroundColor = [UIColor clearColor];
    [self addSubview:_baseView];
    
    _upLine = [[UIView alloc] init];
    _upLine.backgroundColor = UIColorFromHEX(0xcfcdce);
    [_baseView addSubview:_upLine];
    
    _downLine = [[UIView alloc] init];
    _downLine.backgroundColor = UIColorFromHEX(0xcfcdce);
    [_baseView addSubview:_downLine];
    
    _nameLabel = [UILabel customLabelWithRect:CGRectZero
                                        withColor:[UIColor clearColor]
                                    withAlignment:NSTextAlignmentLeft
                                     withFontSize:16.0
                                         withText:@""
                                    withTextColor:[UIColor blackColor]];
    [_baseView addSubview:_nameLabel];
    
    _rssiLabel = [UILabel customLabelWithRect:CGRectZero
                                    withColor:[UIColor clearColor]
                                withAlignment:NSTextAlignmentLeft
                                 withFontSize:16.0
                                     withText:@""
                                withTextColor:[UIColor blackColor]];
    // [_baseView addSubview:_rssiLabel];
    
    _connectLabel = [UILabel customLabelWithRect:CGRectZero
                                       withColor:[UIColor clearColor]
                                   withAlignment:NSTextAlignmentRight
                                    withFontSize:16.0
                                        withText:@""
                                   withTextColor:[UIColor greenColor]];
    [_baseView addSubview:_connectLabel];
    
    _lockView = [[UIView alloc] init];
    _lockView.imageNamed = @"2_bluetooth_lock1.png";
    [_baseView addSubview:_lockView];
    
    _bltView = [[UIView alloc] init];
    _bltView.backgroundColor = [UIColor redColor];
   // [_baseView addSubview:_bltView];
    
    _infoView = [[UIView alloc] init];
    _infoView.backgroundColor = [UIColor clearColor];
    [_baseView addSubview:_infoView];
}

- (void)updateContentForWareInfoCell:(BLTModel *)model withHeight:(CGFloat)height
{
    _model = model;
    
    _baseView.frame = CGRectMake(0, (height - 50)/2, self.width, 50);
    _upLine.frame = CGRectMake(0, 0, _baseView.width, 0.5);
    _downLine.frame = CGRectMake(0, _baseView.height - 0.5, _baseView.width, 0.5);
    
    _nameLabel.frame = CGRectMake(10, 0, self.width * 0.6, 50);
    
    // _rssiLabel.frame = CGRectMake(100, 0, self.width * 0.6, 44);
    // _rssiLabel.text = [NSString stringWithFormat:@"信号强度RSSI: %@", model.bltRSSI];

    _connectLabel.frame = CGRectMake(self.width - 160, 0, 100, 50);

    _lockView.frame = CGRectMake(self.width - 50, (_baseView.height - 39)/2, 15, 39);
    // _bltView.frame = CGRectMake(self.width * 0.75 + 20 , (_baseView.height - 15)/2, 15, 15);
    
    _infoView.frame = CGRectMake(self.width - 30, (_baseView.height - 39)/2, 15, 39);
    _infoView.imageNamed = [model imageForsignalStrength];
    
    if (model.isBinding)
    {
        _lockView.hidden = NO;
    }
    else
    {
        _lockView.hidden = YES;
    }
    
    if (model.peripheral.state == CBPeripheralStateConnected)
    {
        // _bltView.backgroundColor = [UIColor greenColor];
        _connectLabel.text = LS_Text(@"Connected");
    }
    else
    {
        // _bltView.backgroundColor = [UIColor redColor];
        _connectLabel.text = @"";
    }
    
    _nameLabel.text = model.bltName;
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
