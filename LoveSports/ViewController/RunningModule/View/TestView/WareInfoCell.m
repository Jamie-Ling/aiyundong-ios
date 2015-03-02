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
    _baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _baseView.layer.borderWidth = 2.0;
    [self addSubview:_baseView];
    
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
    [_baseView addSubview:_rssiLabel];
    
    _lockView = [[UIView alloc] init];
    _lockView.backgroundColor = [UIColor redColor];
    [_baseView addSubview:_lockView];
    
    _bltView = [[UIView alloc] init];
    _bltView.backgroundColor = [UIColor redColor];
    [_baseView addSubview:_bltView];
    
    _infoView = [[UIView alloc] init];
    _infoView.backgroundColor = [UIColor redColor];
    [_baseView addSubview:_infoView];
}

- (void)updateContentForWareInfoCell:(BLTModel *)model withHeight:(CGFloat)height
{
    _baseView.frame = CGRectMake(0, (height - 88.0)/2, self.width, 88.0);
    _nameLabel.frame = CGRectMake(10, 0, self.width * 0.6, 44);
    _rssiLabel.frame = CGRectMake(10, 44, self.width * 0.6, 44);

    _lockView.frame = CGRectMake(self.width * 0.75, (_baseView.height - 15)/2, 15, 15);
    _bltView.frame = CGRectMake(self.width * 0.75 + 20 , (_baseView.height - 15)/2, 15, 15);
    _infoView.frame = CGRectMake(self.width * 0.75 + 40, (_baseView.height - 15)/2, 15, 15);
    
    if (model.isBinding)
    {
        _lockView.backgroundColor = [UIColor greenColor];
    }
    else
    {
        _lockView.backgroundColor = [UIColor redColor];
    }
    
    _nameLabel.text = model.bltName;
    _rssiLabel.text = [NSString stringWithFormat:@"信号强度RSSI: %@", model.bltRSSI];
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
