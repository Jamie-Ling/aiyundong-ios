//
//  AlarmRepeatView.m
//  LoveSports
//
//  Created by zorro on 15/5/3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AlarmRepeatView.h"

@implementation AlarmRepeatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        [self loadLabelAndSwitch];
    }
    
    return self;
}

- (void)loadLabelAndSwitch
{
    _textLabel = [UILabel simpleLabelWithRect:CGRectMake(6, 0, self.width * 0.3, self.height)
                                withAlignment:NSTextAlignmentLeft
                                 withFontSize:16
                                     withText:LS_Text(@"Repeat")
                                withTextColor:UIColorFromHEX(0x169ad8)
                                      withTag:0];
    [self addSubview:_textLabel];
    
    _repeat = [[UISwitch alloc] initWithFrame:CGRectMake(self.width - 90, 7, 75, self.height)];
    [_repeat addTarget:self action:@selector(clickRepeat:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_repeat];
}

- (void)clickRepeat:(UISwitch *)sender
{

}

@end
