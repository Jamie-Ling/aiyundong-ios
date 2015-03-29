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

@end

@implementation BarShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadLabels];
        [self loadBarGraphView];
    }
    
    return self;
}

- (void)loadLabels
{
    _startLabel = [self addSubLabelWithRect:CGRectMake(0, self.height - 14, 60, 14)
                              withAlignment:NSTextAlignmentCenter
                               withFontSize:14.0
                                   withText:@"23:34"
                              withTextColor:[UIColor lightGrayColor]
                                    withTag:999];
    
    _endLabel = [self addSubLabelWithRect:CGRectMake(self.width - 60, self.height - 14, 60, 14)
                            withAlignment:NSTextAlignmentCenter
                             withFontSize:14.0
                                 withText:@"07:34"
                            withTextColor:[UIColor lightGrayColor]
                                  withTag:999];
    
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
    NSString *startString = [NSString stringWithFormat:@"%02ld:%02ld", 12 + (start) * 5 / 60, (start) * 5 % 60];
    if (start == 144)
    {
        startString = @"00:00";
    }
    NSString *endString = [NSString stringWithFormat:@"%02ld:%02ld", (end) * 5 / 60 - 12, (end) * 5 % 60];
    _startLabel.text = startString;
    _endLabel.text = endString;

    if (array.count >= end)
    {
        _barView.array = array; //[array subarrayWithRange:NSMakeRange(start, end - start)];
    }
    else
    {
        _barView.array = nil;
    }
}

@end
