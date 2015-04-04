//
//  LeftItem.m
//  ZKKWaterHeater
//
//  Created by zorro on 15-1-5.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "LeftItem.h"

@implementation LeftItem

- (instancetype)initWithFrame:(CGRect)frame withBackBlock:(UIViewSimpleBlock)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backBlock = block;
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadViews];
    }
    return self;
}

- (void)loadViews
{
    // 这里需要个向左的图标.
    _markImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height)];
    _markImage.backgroundColor = [UIColor clearColor];
    _markImage.image = [UIImage imageNamed:@""];
    [self addSubview:_markImage];
    _markImage.userInteractionEnabled = NO;
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height)];
    
    _title.backgroundColor = [UIColor clearColor];
    _title.font = [UIFont systemFontOfSize:15.0];
    _title.textColor = [UIColor whiteColor];
    [self addSubview:_title];
    _title.userInteractionEnabled = NO;
}

- (void)clickBack:(UIButton *)button
{
    if (_backBlock)
    {
        _backBlock(self, nil);
    }
}

@end
