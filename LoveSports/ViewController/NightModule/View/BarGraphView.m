//
//  BarGraphView.m
//  LoveSports
//
//  Created by zorro on 15-2-3.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BarGraphView.h"

@implementation BarGraphView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _hori = 10;
        _vert = 30;
    }
    
    return self;
}

- (void)setArray:(NSArray *)array
{
    if (array)
    {
        _array = array;
        
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self drawDashLineWithhori:_hori withVert:_vert];
    
    CGFloat width = 0;
    CGContextRef con = UIGraphicsGetCurrentContext();
    for (NSNumber *number in _array)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rectAngle = CGRectMake(width, self.frame.size.height * (1 - [self getHeightWithIndex:[number integerValue]]), self.frame.size.width / 49, self.frame.size.height * [self getHeightWithIndex:[number integerValue]]);
        CGPathAddRect(path, NULL, rectAngle);
        CGContextAddPath(con, path);
        [[self getColorWithIndex:[number integerValue]] setFill];
        CGContextSetLineWidth(con, 0.0);
        CGContextDrawPath(con, kCGPathFillStroke);
        CGPathRelease(path);
        width += self.frame.size.width / 49;
    }
}

- (UIColor *)getColorWithIndex:(NSInteger)index
{
    if (index < 4)
    {
        return [UIColor blackColor];
    }
    else if (index < 8)
    {
        return [UIColor brownColor];
    }
    else if (index < 12)
    {
        return [UIColor purpleColor];
    }
    else if (index < 16)
    {
        return [UIColor greenColor];
    }
    else if (index <= 18)
    {
        return [UIColor redColor];
    }
    
    return [UIColor blackColor];
}

- (CGFloat)getHeightWithIndex:(NSInteger)index
{
    if (index < 4)
    {
        return 0.3;
    }
    else if (index < 8)
    {
        return 0.4;
    }
    else if (index < 12)
    {
        return 0.6;
    }
    else if (index < 16)
    {
        return 0.8;
    }
    else if (index <= 18)
    {
        return 10;
    }
    
    return 0;
}

@end
