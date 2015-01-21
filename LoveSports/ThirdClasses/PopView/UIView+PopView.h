//
//  UIView+PopView.h
//  VPhone
//
//  Created by zorro on 14-11-4.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIViewCategoryNormalBlock)(UIView *view);
typedef void(^UIViewCategoryAnimationBlock)(void);

@interface UIView (PopView)

// 增加背景阴影
-(void) addShadeWithTarget:(id)target action:(SEL)action color:(UIColor *)aColor alpha:(float)aAlpha;
-(void) addShadeWithBlock:(UIViewCategoryNormalBlock)aBlock color:(UIColor *)aColor alpha:(float)aAlpha;
// 增加毛玻璃背景
-(void) addBlurWithTarget:(id)target action:(SEL)action;
-(void) addBlurWithTarget:(id)target action:(SEL)action level:(int)lv;
-(void) addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock;
-(void) addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock level:(int)lv;

-(void) removeShade;

@end
