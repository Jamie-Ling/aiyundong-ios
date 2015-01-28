//
//  PAGameAnswerItem.m
//  PAChat
//
//  Created by Chen Jacky on 14-1-2.
//  Copyright (c) 2014年 FreeDo. All rights reserved.
//

#define vGameAnswerItemLabelFont [UIFont systemFontOfSize:14]

#import "PAGameAnswerItem.h"
#import <QuartzCore/QuartzCore.h>

@interface PAGameAnswerItem()

@end

@implementation PAGameAnswerItem

@synthesize delegate;
@synthesize answer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *pRoundView = [[UIImageView alloc] init];
        [pRoundView setFrame:CGRectMake(0, 0, 50 * 0.5, 50  * 0.5)];
        [pRoundView.layer setCornerRadius:pRoundView.frame.size.width  * 0.5];
//        [pRoundView.layer setBorderColor:[UIColor blackColor].CGColor];
//        [pRoundView.layer setBorderWidth:1];
        [pRoundView setCenter:CGPointMake(5, self.frame.size.height * 0.5f)];
        [pRoundView setTag:0x9];
        [pRoundView setImage:[UIImage imageNamed:@"game_button_select_Normal.png"]];
        [self addSubview:pRoundView];
        
        UILabel *pAnswerLabel = [[UILabel alloc] init];
        [pAnswerLabel setFrame:CGRectMake(pRoundView.frame.size.width + 5, 0, self.frame.size.width - pRoundView.frame.size.width - 10, self.frame.size.height)];
        [pAnswerLabel setBackgroundColor:[UIColor clearColor]];
        [pAnswerLabel setTextColor:kLabelTitleDefaultColor];
        [pAnswerLabel setFont:vGameAnswerItemLabelFont];
        [pAnswerLabel setNumberOfLines:0];
        [pAnswerLabel setTag:0x10];
        [self addSubview:pAnswerLabel];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [[self nextResponder] touchesBegan:touches withEvent:event];
//    [super touchesBegan:touches withEvent:event];
    
    if (delegate && [delegate respondsToSelector:@selector(PAGameAnswerItem:selectIndex:)])
    {
        [delegate PAGameAnswerItem:self selectIndex:self.tag];
    }
}

- (void)setSelectButtonImage:(NSString *)imageName
{
    UIImageView *pRoundView = (UIImageView *)[self viewWithTag:0x9];
    [pRoundView setImage:[UIImage imageNamed:imageName]];
}

@end
