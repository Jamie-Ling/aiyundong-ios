//
//  UILabel+Custom.h
//  MultiMedia
//
//  Created by zorro on 14-12-2.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

+ (UILabel *)customLabelWithRect:(CGRect)rect;

// 返回估计的尺寸
- (CGSize)estimateUISizeByHeight:(CGFloat)height;
- (CGSize)estimateUISizeByWidth:(CGFloat)width;

@end
