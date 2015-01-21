//
//  UIButton+Simple.h
//  MultiMedia
//
//  Created by zorro on 14-12-18.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Simple)

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage;

@end
