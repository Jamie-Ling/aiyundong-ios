//
//  NSObject+SystemAdap.m
//  MultiMedia
//
//  Created by zorro on 14-12-6.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "UIViewController+SystemAdap.h"

@implementation UIViewController (SystemAdap)


- (CGFloat)getProperWidth
{
    CGRect rect = Screen_Rect;
    return rect.size.width;
}

- (CGFloat)getProperHeight
{
    CGRect rect = Screen_Rect;
    return rect.size.height;
}

- (CGFloat)width
{
    return [self getProperWidth];
}

- (CGFloat)height
{
    return [self getProperHeight];
}

- (void)addSubview:(UIView *)subView
{
    [self.view addSubview:subView];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (CGRect)frame
{
    return self.view.frame;
}

- (CGRect)bounds
{
    return self.view.bounds;
}

@end
