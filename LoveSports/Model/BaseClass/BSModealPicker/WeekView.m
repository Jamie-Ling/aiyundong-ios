//
//  WeekView.m
//  ZKKWaterHeater
//
//  Created by zorro on 15-1-5.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define WeekView_Button_Tag 3333
#import "WeekView.h"

@implementation WeekView
- (instancetype)initWithFrame:(CGRect)frame withWeekBlock:(WeekViewBlock)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kRGB(108, 108, 108);
        _weekBlock = block;
        _selArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self loadButtons];
    }
    return self;
}

- (void)loadButtons
{
    NSArray *titleArray = @[@"周日", @"周一", @"周二",
                            @"周三" ,@"周四", @"周五", @"周六"];
    NSArray *norImageArray = @[@"", @"", @"",
                               @"", @"", @"", @""];
//    NSArray *selImageArray = @[@"周日选中.png", @"周一选中.png", @"周一选中.png",
//                               @"周一选中.png", @"周一选中.png", @"周一选中.png", @"周一选中.png"];
//    CGFloat buttonWidth = (self.frame.size.width - 6) / 7;
    CGFloat buttonWidth = (self.frame.size.width - 0) / 7;
    
    for (int i = 0; i < 7; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (buttonWidth) , 0, buttonWidth, self.frame.size.height)];
        
        button.selected = NO;
        button.tag = WeekView_Button_Tag + i;
        button.backgroundColor = kRGB(108, 108, 108);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setBackgroundImage:[UIImage imageNamed:norImageArray[i]] forState:UIControlStateNormal];
        
//        [button setBackgroundImage:[UIImage imageNamed:selImageArray[i]] forState:UIControlStateSelected];
        
        if (i == 0 || i == 6)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"休选中"] forState:UIControlStateSelected];
        }
        else
        {
             [button setBackgroundImage:[UIImage imageNamed:@"周选中1"] forState:UIControlStateSelected];
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)clickButton:(UIButton *)button
{
    if (button.selected)
    {
        button.selected = NO;
        [_selArray removeObject:[NSString stringWithFormat:@"%ld",(button.tag - WeekView_Button_Tag)]];
    }
    else
    {
        button.selected = YES;
        [_selArray addObject:[NSString stringWithFormat:@"%ld",(button.tag - WeekView_Button_Tag)]];
    }
    
    if (_weekBlock)
    {
        _weekBlock(self);
    }
}

- (void)updateSelButtonForWeekView:(NSArray *)array
{
    [_selArray addObjectsFromArray:array];

    for (int i = 0; i < 7; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:WeekView_Button_Tag + i];
        
        if ([array containsObject:[NSString stringWithFormat:@"%ld",(button.tag - WeekView_Button_Tag)]])
        {
            button.selected = YES;
        }
    }
}

@end
