//
//  TrendTypeView.m
//  LoveSports
//
//  Created by zorro on 15/3/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TrendTypeView.h"

@implementation TrendTypeView

- (instancetype)initWithFrame:(CGRect)frame withOffset:(CGFloat)offset withBlock:(UIViewSimpleBlock)backBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backBlock = backBlock;
        [self loadButtons:offset withWidth:frame.size.width];
    }
    
    return self;
}

- (void)setOffset:(CGFloat)offset
{
    CGFloat offsetX = ((self.width - offset * 2) - 64 * 3) / 2;
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:2000 + i];
        button.frame = CGRectMake(offset + (64 + offsetX) * i, 0, 64, 64);
    }
}

- (void)loadButtons:(CGFloat)offset withWidth:(CGFloat)width
{
    CGFloat offsetX = ((width - offset * 2) - 64 * 3) / 2;

    NSArray *images = @[@"足迹@2x.png", @"能量_big@2x.png", @"路程_big@2x.png"];
    NSArray *selectImages = @[@"足迹-选中@2x.png", @"能量选中_big@2x.png", @"路程选中_big@2x.png"];
    
    for (int i = 0; i < images.count; i++)
    {
        UIButton *button = [UIButton simpleWithRect:CGRectMake(offset + (64 + offsetX) * i, 0, 64, 64)
                                          withImage:images[i]
                                    withSelectImage:selectImages[i]];
        
        button.tag = 2000 + i;
        [button addTarget:self action:@selector(clcikButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0)
        {
            button.selected = YES;
            _lastButton = button;
        }
    }
}

- (void)clcikButton:(UIButton *)button
{
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    
    if (_backBlock)
    {
        _backBlock(self, _lastButton);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
