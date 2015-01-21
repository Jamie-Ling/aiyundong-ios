//
//  UIColor+RGB.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor *)colorWithRGB:(NSString *)colorString
{
    if (colorString)
    {
        NSArray *array = [colorString componentsSeparatedByString:@"/"];
        if (array.count == 3)
        {
            CGFloat red = [array[0] floatValue];
            CGFloat green = [array[1] floatValue];
            CGFloat blue = [array[2] floatValue];
            
            UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
            
            return color;
        }
    }
    
    return [UIColor clearColor];
}

+ (UIColor *)colorWithRGB:(NSString *)colorString withAlpha:(CGFloat)alpha
{
    if (colorString)
    {
        NSArray *array = [colorString componentsSeparatedByString:@"/"];
        if (array.count == 3)
        {
            CGFloat red = [array[0] floatValue];
            CGFloat green = [array[1] floatValue];
            CGFloat blue = [array[2] floatValue];
            
            UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
            
            return color;
        }
    }
    
    return [UIColor clearColor];
}

+ (UIColor *)colorFromHex:(int)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

@end
