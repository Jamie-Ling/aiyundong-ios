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
    _leftButton = [UIButton simpleWithRect:CGRectMake(0, 0, 50, self.height)
                                 withImage:@""
                           withSelectImage:@""];
    _leftButton.backgroundColor = [UIColor clearColor];
    [_leftButton addTouchUpTarget:self action:@selector(clickLeftButton:)];
    [self addSubview:_leftButton];
    [self addLabelForButton:@"－" withButton:_leftButton];
    
    _middleLabel = [UILabel simpleLabelWithRect:CGRectMake((self.width - 50) / 2, 0, 50, self.height)
                                  withAlignment:NSTextAlignmentCenter
                                   withFontSize:[DataShare sharedInstance].isEnglish ? 16 : 20
                                       withText:LS_Text(@"Day")
                                  withTextColor:[UIColor blackColor]
                                        withTag:20000];
    [self addSubview:_middleLabel];
    _middleLabel.layer.masksToBounds = YES;
    _middleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _middleLabel.layer.cornerRadius = _middleLabel.width / 2;
    _middleLabel.layer.borderWidth = 1.0;
    
    _rightButton = [UIButton simpleWithRect:CGRectMake(self.width - 50, 0, 50, self.height)
                                  withImage:@""
                            withSelectImage:@""];
    _rightButton.backgroundColor = [UIColor clearColor];
    [_rightButton addTouchUpTarget:self action:@selector(clickRightButton:)];
    [self addSubview:_rightButton];
    [self addLabelForButton:@"＋" withButton:_rightButton];
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
    NSArray *array = @[LS_Text(@"Day"), LS_Text(@"Week"), LS_Text(@"Month")];
    _middleLabel.text = array[_selectIndex];
    
    if (_backBlock)
    {
        _backBlock(self, @(_selectIndex));
    }
}

- (void)addLabelForButton:(NSString *)text withButton:(UIButton *)button
{
    UILabel *label = [UILabel simpleLabelWithRect:CGRectMake(button.width * 0.2 / 2, button.height * 0.2 / 2,
                                                             button.width * 0.8, button.width * 0.8)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:30];
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.cornerRadius = label.width / 2;
    label.layer.borderWidth = 1.0;
    label.userInteractionEnabled = NO;
    [button addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
