//
//  UILabel+Custom.m
//  MultiMedia
//
//  Created by zorro on 14-12-2.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

+ (UILabel *)customLabelWithRect:(CGRect)rect;
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    return label;
}

+ (UILabel *)customLabelWithRect:(CGRect)rect
                       withColor:(UIColor *)color
                   withAlignment:(NSTextAlignment)alignment
                    withFontSize:(CGFloat)size
                        withText:(NSString *)text
                   withTextColor:(UIColor *)textColor

{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.backgroundColor = color;
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:size];
    label.text = text;
    label.textColor = textColor;
    
    return label;
}

#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
    if (nil == self.text || 0 == self.text.length)
        return CGSizeMake( width, 0.0f );
    
    if (self.numberOfLines)
    {
        return MB_MULTILINE_TEXTSIZE(self.text, self.font, CGSizeMake(width, self.font.lineHeight * self.numberOfLines + 1), self.lineBreakMode);
    }
    else
    {
        return MB_MULTILINE_TEXTSIZE(self.text, self.font, CGSizeMake(width, 999999.0f), self.lineBreakMode);
    }
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
    if (nil == self.text || 0 == self.text.length)
        return CGSizeMake(0.0f, height);
    
    return MB_MULTILINE_TEXTSIZE(self.text, self.font, CGSizeMake(999999.0f, height), self.lineBreakMode);
}

@end
