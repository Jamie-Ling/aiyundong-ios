//
//  UIScrollView+Simple.h
//  LoveSports
//
//  Created by zorro on 15/2/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Simple)

+ (UIScrollView *)simpleInit:(CGRect)rect
                    withShow:(BOOL)show
                  withBounce:(BOOL)bounce;

@end
