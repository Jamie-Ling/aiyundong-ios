//
//  FlatRoundedButton.m
//  Missionsky
//
//  Created by Jamie on 9/23/13.
//  Copyright (c) 2013 FreeDo. All rights reserved.
//

#import "FlatRoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation FlatRoundedButton
@synthesize borderColor,borderWidth;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 5.f;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    borderColor = [UIColor whiteColor];
    borderWidth = 3.f;;
    
}
-(void)setBorderColor:(UIColor *)aborderColor{
    
    borderColor = aborderColor;
    [self setNeedsDisplay];
}
-(void)setBorderWidth:(CGFloat)aborderWidth{
    borderWidth = aborderWidth;
    [self setNeedsDisplay];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2.0f;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
}


@end
