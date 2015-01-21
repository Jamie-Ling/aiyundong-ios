//
//  UIColor+RGB.h
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//


#import <UIKit/UIKit.h>

#define UIColorRGB(RGB) [UIColor colorWithRGB:RGB];
#define UIColorRGBAlpha(RGB, alpha) [UIColor colorWithRGB:RGB withAlpha:alpha];
#define UIColorFromHEX(hexValue) [UIColor colorFromHex:hexValue];
#define kRGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UIColor (RGB)

// 传入 @"111/111/111"
+ (UIColor *)colorWithRGB:(NSString *)colorString;
+ (UIColor *)colorWithRGB:(NSString *)colorString withAlpha:(CGFloat)alpha;

// 返回一个十六进制表示的颜色: 0xFF0000
+ (UIColor *)colorFromHex:(int)hex;

@end
