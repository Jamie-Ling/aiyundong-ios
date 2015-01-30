//
//  UIButton+Simple.m
//  MultiMedia
//
//  Created by zorro on 14-12-18.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "UIButton+Simple.h"

@implementation UIButton (Simple)

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    
    return button;
}

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withTitle:(NSString *)title
             withSelectTitle:(NSString *)selTitle
                   withColor:(UIColor *)color
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:selTitle forState:UIControlStateSelected];
    
    return button;
}

@end
