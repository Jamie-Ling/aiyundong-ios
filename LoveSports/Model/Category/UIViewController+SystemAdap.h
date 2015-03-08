//
//  NSObject+SystemAdap.h
//  MultiMedia
//
//  Created by zorro on 14-12-6.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (SystemAdap)

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect bounds;

@property (nonatomic, strong) UIColor *backgroundColor;

- (CGRect)getProperSize;
- (CGFloat)getProperWidth;
- (CGFloat)getProperHeight;

- (void)addSubview:(UIView *)subView;

@end
