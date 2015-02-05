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
    
    [self drawDashLine];
    
    CGFloat width = 0;
    CGContextRef con = UIGraphicsGetCurrentContext();
    for (DataModel *model in _array)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rectAngle = CGRectMake(width, self.frame.size.height - model.height, model.width, model.height);
        CGPathAddRect(path, NULL, rectAngle);
        CGContextAddPath(con, path);
        [model.color setFill];
        CGContextSetLineWidth(con, 0.0);
        CGContextDrawPath(con, kCGPathFillStroke);
        CGPathRelease(path);
        width += model.width;
    }
}

- (void)drawDashLine
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    // 横线
    for (int i = 0; i < 10; i++)
    {
        CGContextSetLineWidth(con, 1.0);
        CGContextSetStrokeColorWithColor(con, [UIColor lightGrayColor].CGColor);
        CGFloat lengths[] = {3, 3};
        CGContextSetLineDash(con, 0, lengths, 2);
        CGContextMoveToPoint(con, 0, self.frame.size.height - i * 25);
        CGContextAddLineToPoint(con, self.frame.size.width, self.frame.size.height - i * 25);
        CGContextStrokePath(con);
    }
    
    // 竖线
    for (int i = 0; i < 9; i++)
    {
        CGContextSetLineWidth(con, 1.0);
        CGContextSetStrokeColorWithColor(con, [UIColor lightGrayColor].CGColor);
        CGFloat lengths[] = {3, 3};
        CGContextSetLineDash(con, 0, lengths, 2);
        CGContextMoveToPoint(con, 0 + (self.frame.size.width- 10)/8 * i, 0);
        CGContextAddLineToPoint(con, 0 + (self.frame.size.width - 10)/8 * i, self.frame.size.height);
        CGContextStrokePath(con);
    }
}

@end
