//
//  FSLineChart.m
//  FSLineChart
//
//  Created by Arthur GUIBERT on 30/09/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <QuartzCore/QuartzCore.h>
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "NSDate+DateTools.h"

@interface FSLineChart ()

@property (nonatomic, strong) NSMutableArray* data;

@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGMutablePathRef initialPath;
@property (nonatomic, assign) CGMutablePathRef newPath;

@property (nonatomic, strong) CAShapeLayer *fillLayer;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, strong) CAShapeLayer *pointLayer;

@end

@implementation FSLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        _showType = FSLineChartShowNoType;
        [self setDefaultParameters];
    }
    
    return self;
}

- (void)setChartData:(NSArray *)chartData
{
    _data = [NSMutableArray arrayWithArray:chartData];
    
    [self computeBounds];
    
    // No data
    if(isnan(_max))
    {
        _max = 1;
    }
    
    // 画图
    [self strokeChart];
    // 画点
    // [self strokeDataPoints];
    
    if(_labelForIndex)
    {
        float scale = 1.0f;
        int q = (int)_data.count / _horizontalGridStep;
        scale = (CGFloat)(q * _horizontalGridStep) / (CGFloat)(_data.count - 1);
        
        for(int i = 0;i < _horizontalGridStep; i++)
        {
            NSInteger itemIndex = q * i;
            if(itemIndex >= _data.count)
            {
                itemIndex = _data.count - 1;
            }
            
            NSString *text = _labelForIndex(itemIndex);
            NSString *showText = _showType ? [text substringFromIndex:5] : text;
            
            CGPoint p = CGPointMake(_margin + i * (_axisWidth / _horizontalGridStep) * scale, _axisHeight + _margin);
            CGRect rect = CGRectMake(_margin, p.y + 2, self.frame.size.width - _margin * 2 - 4.0f, 14);
            
            float width =[showText boundingRectWithSize:rect.size
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:_indexLabelFont}
                                            context:nil].size.width;
            
            UILabel *label = (UILabel *)[self viewWithTag:666 + i];
            if (!label)
            {
                label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - width / 2, p.y + 8, width + 2, 28)];
                label.tag = 666 + i;
                label.font = _indexLabelFont;
                label.backgroundColor = [UIColor clearColor];
                [self addSubview:label];
            }
            
            label.textColor = [UIColor blackColor];
            label.text = showText;
            
            if (_showType == FSLineChartShowNoType)
            {
            }
            else if (_showType == FSLineChartShowDateType)
            {
                NSDate *date = [NSDate dateWithString:text];
                if (date.weekday == 1 || date.weekday == 7)
                {
                    label.textColor = [UIColor redColor];
                }
                if ([date isSameWithDate:[NSDate date]])
                {
                    label.textColor = [UIColor greenColor];
                }
            }
            else if (_showType == FSLineChartShowWeekType)
            {
                NSDate *date = [NSDate date];
                NSArray *array = [text componentsSeparatedByString:@"/"];
                NSInteger textYear = [array[0] integerValue];
                NSInteger textWeek = [array[1] integerValue];
                if (textYear == date.year && textWeek == date.weekOfYear)
                {
                    label.textColor = [UIColor greenColor];
                }
            }
            else if (_showType == FSLineChartShowMonthType)
            {
                NSDate *date = [NSDate date];
                NSArray *array = [text componentsSeparatedByString:@"/"];
                NSInteger textYear = [array[0] integerValue];
                NSInteger textMonth = [array[1] integerValue];
                if (textYear == date.year && textMonth == date.month)
                {
                    label.textColor = [UIColor greenColor];
                }
            }
            
            if (_hiddenBlock)
            {
                label.hidden = _hiddenBlock(i);
            }
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawGrid];
}

- (void)drawGrid
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, 6);
    CGContextSetStrokeColorWithColor(ctx, UIColorRGBA(155, 40, 16, 0.5).CGColor);
    /*
    CGFloat height = [_data[0] floatValue] * _axisHeight;
    
    // draw coordinate axis
    CGContextMoveToPoint(ctx, 5, _axisHeight + 3);
    CGContextAddLineToPoint(ctx, 5, _axisHeight + 8 - height);
    CGContextStrokePath(ctx);

    height = [_data[_data.count - 1] floatValue] * _axisHeight;
    CGContextMoveToPoint(ctx, self.width - 5, _axisHeight + 3);
    CGContextAddLineToPoint(ctx, self.width - 5, _axisHeight + 8 - height);
    CGContextStrokePath(ctx);
    */
    
    // 画虚线
    //[self drawDashLine];

    float scale = 1.0f;
    int q = (int)_data.count / _horizontalGridStep;
    scale = (CGFloat)(q * _horizontalGridStep) / (CGFloat)(_data.count - 1);
    
    CGFloat minBound = MIN(_min, 0);
    CGFloat maxBound = MAX(_max, 0);
    
    // draw grid
    if(_drawInnerGrid)
    {
        for(int i = 0; i < _horizontalGridStep; i++)
        {
            if (_hiddenBlock && !_hiddenBlock(i))
            {
                CGContextSetStrokeColorWithColor(ctx, [_innerGridColor CGColor]);
                CGContextSetLineWidth(ctx, 1);
                
                CGPoint point = CGPointMake((i) * _axisWidth / _horizontalGridStep * scale + _margin, _margin);
                CGContextMoveToPoint(ctx, point.x, self.height - 5);
                CGContextAddLineToPoint(ctx, point.x, self.height);
                CGContextStrokePath(ctx);
            }
        }
        
        // If the value is zero then we display the horizontal axis
    
        CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
        CGContextSetLineWidth(ctx, 1);
        
        CGContextMoveToPoint(ctx, 0, self.height - 5);
        CGContextAddLineToPoint(ctx, self.width, self.height - 5);
        CGContextStrokePath(ctx);
    }
}

- (void)strokeChart
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *noPath = [UIBezierPath bezierPath];
    UIBezierPath* fill = [UIBezierPath bezierPath];
    UIBezierPath* noFill = [UIBezierPath bezierPath];
    
    CGFloat minBound = MIN(_min, 0);
    CGFloat maxBound = MAX(_max, 0);
    
    CGFloat scale = _axisHeight; // (maxBound - minBound);
    
    noPath = [self getLinePath:0 withSmoothing:_bezierSmoothing close:NO];
    path = [self getLinePath:scale withSmoothing:_bezierSmoothing close:NO];
    
    noFill = [self getLinePath:0 withSmoothing:_bezierSmoothing close:YES];
    fill = [self getLinePath:scale withSmoothing:_bezierSmoothing close:YES];
    
    if(_fillColor)
    {
        if (!_fillLayer)
        {
            _fillLayer = [CAShapeLayer layer];
            [self.layer addSublayer:_fillLayer];
        }
        
        _fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + minBound * scale, self.bounds.size.width, self.bounds.size.height);
        _fillLayer.bounds = self.bounds;
        _fillLayer.path = fill.CGPath;
        _fillLayer.strokeColor = UIColorRGB(213, 250, 187).CGColor;
        _fillLayer.fillColor = UIColorRGB(213, 250, 187).CGColor;
        _fillLayer.lineWidth = 1.0;
        _fillLayer.lineJoin = kCALineJoinRound;
    }
    
    /*
    if (!_pathLayer)
    {
        _pathLayer = [CAShapeLayer layer];
       // [self.layer addSublayer:_pathLayer];
    }
    
    _pathLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + minBound * scale, self.bounds.size.width, self.bounds.size.height);
    _pathLayer.bounds = self.bounds;
    _pathLayer.path = path.CGPath;
    _pathLayer.strokeColor = UIColorRGB(213, 250, 187).CGColor;
    _pathLayer.fillColor = nil;
    _pathLayer.lineWidth = 1.0;
    _pathLayer.lineJoin = kCALineJoinRound;
     */
}

//   画点。
- (void)strokeDataPoints
{
    CGFloat minBound = MIN(_min, 0);
    CGFloat maxBound = MAX(_max, 0);
    
    CGFloat scale = _axisHeight; // (maxBound - minBound);
    
    // CAShapeLayer *dataPointsLayer = [CAShapeLayer layer];
    
    for(int i = 0; i < _data.count; i++)
    {
        CGPoint p = [self getPointForIndex:i withScale:scale];
        
        /*
        UILabel *label  = [UILabel customLabelWithRect:CGRectMake(0, 0, 40, 20)
                                              withColor:[UIColor clearColor]
                                          withAlignment:NSTextAlignmentCenter
                                           withFontSize:12.0
                                               withText:@""
                                         withTextColor:[UIColor clearColor]];
        [self addSubview:label];
        label.center = CGPointMake(p.x, p.y);
        label.text = [NSString stringWithFormat:@"%ld", (long)[_data[i] integerValue]];
         */
        
        p.y +=  minBound * scale;

        UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(p.x - _dataPointRadius * 3, p.y - _dataPointRadius * 3, _dataPointRadius * 6, _dataPointRadius * 6)];
        
        if (!_pointLayer)
        {
            _pointLayer = [CAShapeLayer layer];
            // [self.layer addSublayer:_pointLayer];
        }
        
        _pointLayer.frame = CGRectMake(p.x, p.y, _dataPointRadius, _dataPointRadius);
        _pointLayer.bounds = CGRectMake(p.x, p.y, _dataPointRadius, _dataPointRadius);
        _pointLayer.path = circle.CGPath;
        _pointLayer.strokeColor = UIColorRGB(165, 24, 16).CGColor;
        _pointLayer.fillColor = UIColorRGB(165, 24, 16).CGColor;
        _pointLayer.lineWidth = 3;
        _pointLayer.lineJoin = kCALineJoinRound;
    }
}

- (void)setDefaultParameters
{
    _color = [UIColor fsLightBlue];
    _fillColor = [_color colorWithAlphaComponent:0.25];
    _verticalGridStep = 3;
    _horizontalGridStep = 3;
    _margin = 7.0;
    _axisWidth = self.frame.size.width - 2 * _margin;
    _axisHeight = self.frame.size.height - 2 * _margin;
    _axisColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    _innerGridColor = [UIColor lightGrayColor];
    _drawInnerGrid = YES;
    _bezierSmoothing = YES;
    _bezierSmoothingTension = 0.0;
    _lineWidth = 1;
    _innerGridLineWidth = 0.5;
    _axisLineWidth = 1;
    _animationDuration = 0.5;
    _displayDataPoint = NO;
    _dataPointRadius = 1;
    _dataPointColor = _color;
    _dataPointBackgroundColor = _color;
    
    // Labels attributes
    _indexLabelBackgroundColor = [UIColor clearColor];
    _indexLabelTextColor = [UIColor grayColor];
    _indexLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    
    _valueLabelBackgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _valueLabelTextColor = [UIColor grayColor];
    _valueLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    _valueLabelPosition = ValueLabelRight;
    _levelNumber = 100;
}

- (void)computeBounds
{
    _min = MAXFLOAT;
    _max = -MAXFLOAT;
    
    for(int i=0;i<_data.count;i++) {
        NSNumber* number = _data[i];
        if([number floatValue] < _min)
            _min = [number floatValue];
        
        if([number floatValue] > _max)
            _max = [number floatValue];
    }
    
    _levelNumber = (NSInteger)_max / 10;
    
    // The idea is to adjust the minimun and the maximum value to display the whole chart in the view, and if possible with nice "round" steps.
    _max = [self getUpperRoundNumber:_max forGridStep:_verticalGridStep];
    
    if(_min < 0) {
        // If the minimum is negative then we want to have one of the step to be zero so that the chart is displayed nicely and more comprehensively
        float step;
        
        if(_verticalGridStep > 3) {
            step = fabs(_max - _min) / (float)(_verticalGridStep - 1);
        } else {
            step = MAX(fabs(_max - _min) / 2, MAX(fabs(_min), fabs(_max)));
        }
        
        step = [self getUpperRoundNumber:step forGridStep:_verticalGridStep];
        
        float newMin,newMax;
        
        if(fabs(_min) > fabs(_max)) {
            int m = ceilf(fabs(_min) / step);
            
            newMin = step * m * (_min > 0 ? 1 : -1);
            newMax = step * (_verticalGridStep - m) * (_max > 0 ? 1 : -1);
            
        } else {
            int m = ceilf(fabs(_max) / step);
            
            newMax = step * m * (_max > 0 ? 1 : -1);
            newMin = step * (_verticalGridStep - m) * (_min > 0 ? 1 : -1);
        }
        
        if(_min < newMin) {
            newMin -= step;
            newMax -=  step;
        }
        
        if(_max > newMax + step) {
            newMin += step;
            newMax +=  step;
        }
        
        _min = newMin;
        _max = newMax;
        
        if(_max < _min) {
            float tmp = _max;
            _max = _min;
            _min = tmp;
        }
    }
}

- (CGFloat)getUpperRoundNumber:(CGFloat)value forGridStep:(int)gridStep
{
    if(value <= 0)
        return 0;
    
    // We consider a round number the following by 0.5 step instead of true round number (with step of 1)
    CGFloat logValue = log10f(value);
    CGFloat scale = powf(10, floorf(logValue));
    CGFloat n = ceilf(value / scale * 4);
    
    int tmp = (int)(n) % gridStep;
    
    if(tmp != 0) {
        n += gridStep - tmp;
    }
    
    return n * scale / 4.0f;
}

- (void)setGridStep:(int)gridStep
{
    _verticalGridStep = gridStep;
    _horizontalGridStep = gridStep;
}

- (CGPoint)getPointForIndex:(NSInteger)idx withScale:(CGFloat)scale
{
    if(idx < 0 || idx >= _data.count)
        return CGPointZero;
    
    // Compute the point in the view from the data with a set scale
    CGFloat number = [_data[idx] floatValue] / (_levelNumber + 0.0001) * 0.1;
    return CGPointMake(_margin + idx * (_axisWidth / (_data.count - 1)), _axisHeight + _margin - ((number > 1.0) ? 1.0 : number) * scale);
}

- (UIBezierPath*)getLinePath:(float)scale withSmoothing:(BOOL)smoothed close:(BOOL)closed
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    if(smoothed)
    {
        for(int i = 0;i < _data.count - 1; i++) {
            CGPoint controlPoint[2];
            CGPoint p = [self getPointForIndex:i withScale:scale];
            
            // Start the path drawing
            if(i == 0)
                [path moveToPoint:p];
            
            CGPoint nextPoint, previousPoint, m;
            
            // First control point
            nextPoint = [self getPointForIndex:i + 1 withScale:scale];
            previousPoint = [self getPointForIndex:i - 1 withScale:scale];
            m = CGPointZero;
            
            if(i > 0) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (nextPoint.x - p.x) / 2;
                m.y = (nextPoint.y - p.y) / 2;
            }
            
            controlPoint[0].x = p.x + m.x * _bezierSmoothingTension;
            controlPoint[0].y = p.y + m.y * _bezierSmoothingTension;
            
            // Second control point
            nextPoint = [self getPointForIndex:i + 2 withScale:scale];
            previousPoint = [self getPointForIndex:i withScale:scale];
            p = [self getPointForIndex:i + 1 withScale:scale];
            m = CGPointZero;
            
            if(i < _data.count - 2) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (p.x - previousPoint.x) / 2;
                m.y = (p.y - previousPoint.y) / 2;
            }
            
            controlPoint[1].x = p.x - m.x * _bezierSmoothingTension;
            controlPoint[1].y = p.y - m.y * _bezierSmoothingTension;
            
            [path addCurveToPoint:p controlPoint1:controlPoint[0] controlPoint2:controlPoint[1]];
        }
        
    } else {
        for(int i=0;i<_data.count;i++) {
            if(i > 0) {
                [path addLineToPoint:[self getPointForIndex:i withScale:scale]];
            } else {
                [path moveToPoint:[self getPointForIndex:i withScale:scale]];
            }
        }
    }
    
    if(closed) {
        // Closing the path for the fill drawing
        [path addLineToPoint:[self getPointForIndex:_data.count - 1 withScale:scale]];
        [path addLineToPoint:[self getPointForIndex:_data.count - 1 withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 withScale:scale]];
    }
    
    return path;
}

@end