//
//  UIView+PopView.m
//  VPhone
//
//  Created by zorro on 14-11-4.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#define UIView_shadeTag 26601
#define UIView_animation_instant 0.15
#define UIView_key_tapBlock	"UIView.tapBlock"

#import "UIView+PopView.h"
#import "XYPopupViewHelper.h"
#import "UIImage+ZKK.h"
#import <objc/runtime.h>

@implementation UIView (PopView)

/////////////////////////////////////////////////////////////
-(void) addShadeWithTarget:(id)target action:(SEL)action color:(UIColor *)aColor alpha:(float)aAlpha{
    UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
    tmpView.tag = UIView_shadeTag;
    if (aColor) {
        tmpView.backgroundColor = aColor;
    } else {
        tmpView.backgroundColor = [UIColor blackColor];
    }
    tmpView.alpha = aAlpha;
    [self addSubview:tmpView];
    
    [tmpView addTapGestureWithTarget:target action:action];
}
-(void) addShadeWithBlock:(UIViewCategoryNormalBlock)aBlock color:(UIColor *)aColor alpha:(float)aAlpha{
    UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
    tmpView.tag = UIView_shadeTag;
    if (aColor) {
        tmpView.backgroundColor = aColor;
    } else {
        tmpView.backgroundColor = [UIColor blackColor];
    }
    tmpView.alpha = aAlpha;
    [self addSubview:tmpView];
    
    if (aBlock) {
        [tmpView addTapGestureWithBlock:aBlock];
    }
}
-(void) removeShade{
    UIView *view = [self viewWithTag:UIView_shadeTag];
    if (view)
    {
        for (int i = self.subviews.count - 1; i >= 0; i--)
        {
            UIView *shadowView = [self.subviews objectAtIndex:i];
            if (shadowView.tag == UIView_shadeTag)
            {
                [UIView animateWithDuration:UIView_animation_instant delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    shadowView.alpha = 0;
                } completion:^(BOOL finished) {
                    [shadowView removeFromSuperview];
                }];
                break;
            }
        }
    }
}

-(UIView *) shadeView{
    return [self viewWithTag:UIView_shadeTag];
}

// 增加毛玻璃背景
-(void) addBlurWithTarget:(id)target action:(SEL)action level:(int)lv{
    UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
    tmpView.tag = UIView_shadeTag;
    [self addSubview:tmpView];
    tmpView.alpha = 0;
    //  BACKGROUND_BEGIN
    UIImage *img = [[self snapshot] stackBlur:lv];
    //   FOREGROUND_BEGIN
    tmpView.layer.contents = (id)img.CGImage;
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tmpView.alpha = 1;
    } completion:nil];
    //   FOREGROUND_COMMIT
    //   BACKGROUND_COMMIT
    [tmpView addTapGestureWithTarget:target action:action];
}
-(void) addBlurWithTarget:(id)target action:(SEL)action{
    [self addBlurWithTarget:target action:action level:5];
}

-(void) addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock level:(int)lv{
    UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
    tmpView.tag = UIView_shadeTag;
    UIImage *img = [[self snapshot] stackBlur:lv];
    tmpView.layer.contents = (id)img.CGImage;
    [self addSubview:tmpView];
    
    if (aBlock) {
        [tmpView addTapGestureWithBlock:aBlock];
    }
}
-(void) addBlurWithBlock:(UIViewCategoryNormalBlock)aBlock{
    [self addBlurWithBlock:aBlock level:[XYPopupViewHelper sharedInstance].blurLevel];
}

-(void) addTapGestureWithTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
-(void) removeTapGesture{
    for (UIGestureRecognizer * gesture in self.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
        {
            [self removeGestureRecognizer:gesture];
        }
    }
}

-(void) addTapGestureWithBlock:(UIViewCategoryNormalBlock)aBlock{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, UIView_key_tapBlock, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)actionTap{
    UIViewCategoryNormalBlock block = objc_getAssociatedObject(self, UIView_key_tapBlock);
    
    if (block) block(self);
}

-(UIImage *) snapshot{
    UIGraphicsBeginImageContext(self.bounds.size);
    if (IOS7_OR_LATER) {
        // 这个方法比ios6下的快15倍
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
