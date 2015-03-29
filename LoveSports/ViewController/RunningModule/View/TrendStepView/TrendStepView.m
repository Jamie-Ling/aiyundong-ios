//
//  TrendStepView.m
//  LoveSports
//
//  Created by zorro on 15/3/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TrendStepView.h"

@implementation TrendStepView

- (instancetype)initWithFrame:(CGRect)frame withBlock:(UIViewSimpleBlock)backBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _selectIndex = 0;
        _backBlock = backBlock;
        
        [self loadButtonsAndLabel];
    }
    
    return self;
}

- (void)loadButtonsAndLabel
{
    _leftButton = [UIButton simpleWithRect:CGRectMake(0, 0, self.width / 3, self.height)
                                 withImage:@""
                           withSelectImage:@""];
    _leftButton.backgroundColor = [UIColor clearColor];
    [_leftButton addTouchUpTarget:self action:@selector(clickLeftButton:)];
    [self addSubview:_leftButton];
    _leftButton.backgroundColor = [UIColor redColor];
    
    _middleLabel = [UILabel simpleLabelWithRect:CGRectMake(self.width / 3, 0, self.width / 3, self.height)
                                  withAlignment:NSTextAlignmentCenter
                                   withFontSize:20
                                       withText:@"日"
                                  withTextColor:[UIColor blackColor]
                                        withTag:20000];
    [self addSubview:_middleLabel];
    _middleLabel.layer.masksToBounds = YES;
    _middleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _middleLabel.layer.cornerRadius = _middleLabel.width / 2;
    _middleLabel.layer.borderWidth = 1.0;
    
    _rightButton = [UIButton simpleWithRect:CGRectMake(self.width / 3 * 2, 0, self.width / 3, self.height)
                                  withImage:@""
                            withSelectImage:@""];
    _rightButton.backgroundColor = [UIColor clearColor];
    [_rightButton addTouchUpTarget:self action:@selector(clickRightButton:)];
    [self addSubview:_rightButton];
    _rightButton.backgroundColor = [UIColor redColor];
}

- (void)clickLeftButton:(UIButton *)button
{
    if (_selectIndex == 0)
    {
        return;
    }
    
    _selectIndex--;
    [self updateContentForSuperView];
}

- (void)clickRightButton:(UIButton *)button
{
    if (_selectIndex == 2)
    {
        return;
    }
    
    _selectIndex++;
    [self updateContentForSuperView];
}

- (void)updateContentForSuperView
{
    NSArray *array = @[@"日", @"周", @"月"];
    _middleLabel.text = array[_selectIndex];
    
    if (_backBlock)
    {
        _backBlock(self, @(_selectIndex));
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
