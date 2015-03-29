//
//  DashLineView.m
//  LoveSports
//
//  Created by zorro on 15/3/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DashLineView.h"

@implementation DashLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setHoriAndVert:(NSInteger)hori vert:(NSInteger)vert
{
    _hori = hori;
    _vert = vert;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self drawDashLineWithhori:_hori withVert:_vert];
}

@end
