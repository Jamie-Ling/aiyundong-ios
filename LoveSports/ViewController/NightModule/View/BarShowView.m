//
//  BarShowView.m
//  ZKKUIViewExtension
//
//  Created by zorro on 15/2/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BarShowView.h"
#import "BarGraphView.h"

@interface BarShowView ()

@property (nonatomic, strong) BarGraphView *barView;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation BarShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadLabelsAndViews];
        [self loadBarGraphView];
    }
    
    return self;
}

- (void)loadLabelsAndViews
{
    _leftView = [self addSubViewWithRect:CGRectMake(2, -37.5, 37.5, 37.5)
                               withColor:[UIColor clearColor]
                               withImage:@"小图标1@2x.png"];
    _leftView.hidden = YES;
    
    _rightView = [self addSubViewWithRect:CGRectMake(self.width - 40, -37.5, 37.5, 37.5)
                                withColor:[UIColor clearColor]
                                withImage:@"小图标3@2x.png"];
    _rightView.hidden = YES;

    _startLabel = [self addSubLabelWithRect:CGRectMake(0, self.height - 14, 60, 14)
                              withAlignment:NSTextAlignmentCenter
                               withFontSize:14.0
                                   withText:@"23:34"
                              withTextColor:[UIColor lightGrayColor]
                                    withTag:999];
    _startLabel.hidden = YES;
    
    _endLabel = [self addSubLabelWithRect:CGRectMake(self.width - 60, self.height - 14, 60, 14)
                            withAlignment:NSTextAlignmentCenter
                             withFontSize:14.0
                                 withText:@"07:34"
                            withTextColor:[UIColor lightGrayColor]
                                  withTag:999];
    _endLabel.hidden = YES;
    
    /*
    for (int i = 24; i < 49; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 + self.frame.size.width/49*(i-24), self.frame.size.height - 14, self.frame.size.width/49, 14)];
        
        NSString *string = [NSString stringWithFormat:@"%02d:%@", i / 2, (((i % 2) == 0) ? @"00" : @"30")];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:11];
        label.text = string;
        [self addSubview:label];
    }
    
    for (int i = 1; i <= 24; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 + self.frame.size.width/49*(i+24), self.frame.size.height - 14, self.frame.size.width/49, 14)];
        
        NSString *string = [NSString stringWithFormat:@"%02d:%@", i / 2, (((i % 2) == 0) ? @"00" : @"30")];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:11];
        label.text = string;
        [self addSubview:label];
    }
     */
    
}

- (void)loadBarGraphView
{
    _barView = [[BarGraphView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 14)];
    
    [self addSubview:_barView];
}

- (void)updateContentForView:(NSArray *)array withStart:(NSInteger)start withEnd:(NSInteger)end
{
    if (array)
    {
        _barView.array = array;
    }
    
    /*
    NSString *startString = [NSString stringWithFormat:@"%02ld:%02ld", 12 + (start + 1) * 5 / 60, (start + 1) * 5 % 60];
    if (start == 143)
    {
        startString = @"00:00";
    }
    // NSString *endString = [NSString stringWithFormat:@"%02ld:%02ld", (end + 1) * 5 / 60 - 12, (end + 1) * 5 % 60];
    // _startLabel.text = startString;
    // _endLabel.text = endString;
    
    if (array.count >= end)
    {
        _barView.array = [array subarrayWithRange:NSMakeRange(start, end - start)];
    }
    else
    {
        _barView.array = nil;
    }
     */
}

@end
