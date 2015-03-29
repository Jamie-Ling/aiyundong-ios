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
        
        _hori = 9;
        _vert = 10;
    }
    
    return self;
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self drawDashLineWithhori:_hori withVert:_vert];
    
    CGFloat width = 0;
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGFloat interval = (self.frame.size.width - 40) / _array.count;
    for (NSNumber *number in _array)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rectAngle = CGRectMake(width + 20, self.height * (1 - [self getHeightWithIndex:[number integerValue]]), interval, self.height * [self getHeightWithIndex:[number integerValue]]);
        CGPathAddRect(path, NULL, rectAngle);
        CGContextAddPath(con, path);
        [[self getColorWithIndex:[number integerValue]] setFill];
        CGContextSetLineWidth(con, 0.0);
        CGContextDrawPath(con, kCGPathFillStroke);
        CGPathRelease(path);
        width += interval;
    }
    
    /*
    NSArray *array = @[[NSValue valueWithCGRect:CGRectMake(0, self.height * 0.5, 20, self.height * 0.5)],
                       [NSValue valueWithCGRect:CGRectMake(self.width - 20, self.height * 0.5, 20, self.height * 0.5)]];
    for (int i = 0; i < array.count; i++)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        
        NSValue *value = array[i];
        CGRect rectAngle = [value CGRectValue];
        CGPathAddRect(path, NULL, rectAngle);
        CGContextAddPath(con, path);
        [UIColor blackColor];
        CGContextSetLineWidth(con, 0.0);
        CGContextDrawPath(con, kCGPathFillStroke);
        CGPathRelease(path);
    }
     */
}

- (UIColor *)getColorWithIndex:(NSInteger)index
{
    if (index < 4)
    {
        return [UIColor lightGrayColor];
    }
    else if (index < 8)
    {
        return [UIColor greenColor];
    }
    else if (index < 12)
    {
        return [UIColor purpleColor];
    }
    else if (index < 16)
    {
        return [UIColor blueColor];
    }
    else if (index <= 18)
    {
        return [UIColor redColor];
    }
    
    return [UIColor lightGrayColor];
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
    
    return 5;
}

@end
