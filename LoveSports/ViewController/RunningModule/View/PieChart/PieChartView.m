//
//  PieChartView.m
//  PieChartViewDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import "PieChartView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PieChartView

@synthesize delegate;
@synthesize datasource;

-(id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self)
   {
      //initialization
      self.backgroundColor = [UIColor clearColor];
      //    self.layer.shadowColor = [[UIColor blackColor] CGColor];
      //    self.layer.shadowOffset = CGSizeMake(0.0f, 2.5f);
      //    self.layer.shadowRadius = 1.9f;
      //    self.layer.shadowOpacity = 0.9f;
       
       [self loadLabels];
   }
    
   return self;
}

- (void)loadLabels
{
    _signView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * 0.35, self.height / 5, self.width * 0.3, self.height / 6.6)];
    _signView.backgroundColor = [UIColor clearColor];
    [self addSubview:_signView];
    
    _timeLabel = [UILabel customLabelWithRect:CGRectMake(self.width / 6, self.height / 3, self.width / 6 * 4, self.height / 3) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:42.0 withText:@"07:30" withTextColor:[UIColor whiteColor]];
    [self addSubview:_timeLabel];
    
    _minLabel = [UILabel customLabelWithRect:CGRectMake(self.width / 6 * 4.4, self.height / 2.15, self.width / 4.8, self.height / 6) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:14.0 withText:@"MIN" withTextColor:[UIColor whiteColor]];
    [self addSubview:_minLabel];
    
    _targetLabel = [UILabel customLabelWithRect:CGRectMake(0, self.height / 3 * 1.9, self.width, self.height / 12) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:20 withText:@"目标" withTextColor:[UIColor whiteColor]];
    [self addSubview:_targetLabel];
    
    _durationLabel = [UILabel customLabelWithRect:CGRectMake(0, self.height / 3 * 2 + self.height / 12, self.width, self.height / 12) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:20 withText:@"8小时" withTextColor:[UIColor whiteColor]];
    [self addSubview:_durationLabel];
}

-(void)reloadData
{
   [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

//prepare
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGFloat theHalf = rect.size.width/2;
   CGFloat lineWidth = theHalf;
   if ([self.delegate respondsToSelector:@selector(centerCircleRadius)])
   {
      lineWidth -= [self.delegate centerCircleRadius];
      NSAssert(lineWidth <= theHalf, @"wrong circle radius");
   }
   CGFloat radius = theHalf-lineWidth/2;
   
   CGFloat centerX = theHalf;
   CGFloat centerY = rect.size.height/2;
   
//drawing
   
   double sum = 0.0f;
   int slicesCount = [self.datasource numberOfSlicesInPieChartView:self];
   
   for (int i = 0; i < slicesCount; i++)
   {
      sum += [self.datasource pieChartView:self valueForSliceAtIndex:i];
   }
   
   float startAngle = - M_PI_2;
   float endAngle = 0.0f;
      
   for (int i = 0; i < slicesCount; i++)
   {
      double value = [self.datasource pieChartView:self valueForSliceAtIndex:i];

      endAngle = startAngle + M_PI*2*value/sum;
      CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, false);
   
      UIColor  *drawColor = [self.datasource pieChartView:self colorForSliceAtIndex:i];
   
      CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
      CGContextSetLineWidth(context, 16);
      CGContextStrokePath(context);
      startAngle += M_PI*2*value/sum;
   }
}

- (void)nightSetting
{
    _minLabel.hidden = YES;
}

- (void)daySetting
{
    _minLabel.hidden = YES;
   // _targetLabel.hidden = YES;
    self.signView.image = [UIImage image:@"睡觉@2x.png"];
   // _durationLabel.frame = CGRectMake(0, self.height / 3 * 2, self.width, self.height / 12);
}

- (void)updateContentForViewWithModel:(PedometerModel *)model
{
    _timeLabel.text = [NSString stringWithFormat:@"%d", model.totalSteps];
    _targetLabel.text = [NSString stringWithFormat:@"%d", model.totalCalories];
    _durationLabel.text = [NSString stringWithFormat:@"%d", model.totalDistance];
}

@end
