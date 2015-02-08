//
//  UIScrollView+Simple.m
//  LoveSports
//
//  Created by zorro on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIScrollView+Simple.h"

@implementation UIScrollView (Simple)

+ (UIScrollView *)simpleInit:(CGRect)rect
                    withShow:(BOOL)show
                  withBounce:(BOOL)bounce
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = show;
    scrollView.showsVerticalScrollIndicator = show;
    scrollView.bounces = bounce;
    
    return scrollView;
}


@end
