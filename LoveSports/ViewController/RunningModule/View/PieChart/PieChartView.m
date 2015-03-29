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
    _signView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * 0.35, self.height / 10, self.width * 0.3, self.height / 3.6)];
    _signView.backgroundColor = [UIColor clearColor];
    [self addSubview:_signView];
    
    _timeLabel = [UILabel customLabelWithRect:CGRectMake(self.width / 6, self.height / 3, self.width / 6 * 4, self.height / 3) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:42.0 withText:@"" withTextColor:[UIColor blackColor]];
    [self addSubview:_timeLabel];
    
    _minLabel = [UILabel customLabelWithRect:CGRectMake(self.width / 6 * 4.34, self.height / 2.15, self.width / 4.8, self.height / 6) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:14.0 withText:@"" withTextColor:[UIColor blackColor]];
    [self addSubview:_minLabel];
    
    _targetLabel = [UILabel customLabelWithRect:CGRectMake(0, self.height / 3 * 1.9, self.width, self.height / 12) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:20 withText:@"" withTextColor:[UIColor blackColor]];
    [self addSubview:_targetLabel];
    
    _durationLabel = [UILabel customLabelWithRect:CGRectMake(0, self.height / 3 * 2 + self.height / 12, self.width, self.height / 12) withColor:[UIColor clearColor] withAlignment:NSTextAlignmentCenter withFontSize:20 withText:@"" withTextColor:[UIColor blackColor]];
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
   
   int slicesCount = [self.datasource numberOfSlicesInPieChartView:self];
   
    double sum = 288 * 10;

    /*
   for (int i = 0; i < slicesCount; i++)
   {
      sum += [self.datasource pieChartView:self valueForSliceAtIndex:i];
   }*/
   
   float startAngle = - M_PI_2;
   float endAngle = 0.0f;
    
   double value = 10; //[self.datasource pieChartView:self valueForSliceAtIndex:i];

   for (int i = 0; i < slicesCount; i++)
   {
      endAngle = startAngle + M_PI*2*value/sum;
      CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, false);
   
      UIColor *drawColor = [self.datasource pieChartView:self colorForSliceAtIndex:i];
   
      CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
      CGContextSetLineWidth(context, 16);
      CGContextStrokePath(context);
      startAngle += M_PI*2*value/sum;
   }
}

- (void)nightSetting
{
    _minLabel.text = @"MIN";
    self.signView.image = [UIImage image:@"睡觉@2x.png"];
    _timeLabel.text = @"07:00";
    _targetLabel.text = @"目标";
    _durationLabel.text = @"8小时";
}

- (void)daySetting
{
    _minLabel.hidden = YES;
    _targetLabel.hidden = YES;
    self.signView.image = [UIImage image:@"脚印1.png"];
    self.signView.frame = CGRectMake(self.signView.x + 9, self.signView.y + 10, 70 / 2.0, 90 / 2.0);
    _durationLabel.frame = CGRectMake(0, self.height / 3 * 2, self.width, self.height / 12);
    _timeLabel.text = @"步数";
   // _targetLabel.text = @"卡路里";
    _durationLabel.text = @"百分比";
}

- (void)updateContentForViewWithModel:(PedometerModel *)model withState:(PieChartViewShowState)state  withReloadBlock:(PieChartViewReload)block;
{
    CGFloat percent = -1.0;
    switch (state)
    {
        case PieChartViewShowSteps:
        {
            _timeLabel.text = [NSString stringWithFormat:@"%ld", (long)model.totalSteps];
            _durationLabel.text = [NSString stringWithFormat:@"%.0f%%", model.totalSteps * 1.0 / (model.targetStep > 1 ? model.targetStep : 10000)];
            percent = model.totalSteps / (model.targetStep > 1 ? model.targetStep : 10000);
        }
            break;
            
        case PieChartViewShowCalories:
        {
            _timeLabel.text = [NSString stringWithFormat:@"%ld", (long)model.totalCalories];
            _durationLabel.text = [NSString stringWithFormat:@"%.0f%%", model.totalCalories * 1.0 / (model.targetCalories > 1 ? model.targetCalories : 1000)];
            percent = model.totalCalories / (model.targetCalories > 1 ? model.targetCalories : 1000);
        }
            break;
            
        case PieChartViewShowDistance:
        {
            _timeLabel.text = [NSString stringWithFormat:@"%.02f", (long)model.totalDistance * 0.01];
            _durationLabel.text = [NSString stringWithFormat:@"%.0f%%", model.totalDistance * 1.0 / (model.targetDistance > 1 ? model.targetDistance : 1000)];
            percent = model.totalDistance / (model.targetDistance > 1 ? model.targetDistance : 1000);
        }
            break;
            
        case PieChartViewShowSleep:
        {
            _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", model.totalSleepTime / 60, model.totalSleepTime % 60];
            _durationLabel.text = [NSString stringWithFormat:@"%ld小时", (long)model.targetSleep / 60];
            percent = model.totalSleepTime / (model.targetSleep > 1 ? model.targetSleep : 8 * 60);

        }
            break;
            
        default:
            break;
    }
    
    if (percent > 1.0)
    {
        percent = 1.0;
    }
    else if (percent < 0.0)
    {
        percent = 0.0;
    }
    
    if (block)
    {
        block(percent);
    }
}

@end
