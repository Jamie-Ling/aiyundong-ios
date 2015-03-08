//
//  UIView+Simple.h
//  ZKKUIViewExtension
//
//  Created by zorro on 15/2/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define UIColorFromHEX(hexValue) [UIColor colorFromHex:hexValue];
#define UIColorRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define UIFontSize(size) [UIFont systemFontOfSize:size];

#import <UIKit/UIKit.h>
typedef void(^UIViewSimpleBlock)(UIView *aView, id object);

@interface UIView (Simple)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) CGFloat halfWidth;
@property (nonatomic, assign) CGFloat halfHeight;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageNamed;

- (void)removeAllSubviews;
- (void)removeAllGestureRecognizers;

// UIButton
- (UIButton *)addSubButtonWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage
                     withSel:(SEL)aSelector
                        withTarget:(UIView *)target;

- (UIButton *)addSubButtonWithRect:(CGRect)rect
                   withTitle:(NSString *)title
             withSelectTitle:(NSString *)selTitle
                   withColor:(UIColor *)color
                     withSel:(SEL)aSelector
                        withTarget:(UIView *)target;

// UILabel
- (UILabel *)addSubLabelWithRect:(CGRect)rect
                  withColor:(UIColor *)color
              withAlignment:(NSTextAlignment)alignment
               withFontSize:(CGFloat)size
                   withText:(NSString *)text
              withTextColor:(UIColor *)textColor
          withLineBreakMode:(NSLineBreakMode)lineBreakMode
         withLnumberOfLines:(int)numberOfLines;

- (UILabel *)addSubLabelWithRect:(CGRect)rect
              withAlignment:(NSTextAlignment)alignment
               withFontSize:(CGFloat)size
                   withText:(NSString *)text
              withTextColor:(UIColor *)textColor
                    withTag:(NSInteger)tag;

// line
- (UIView *)addSubViewWithRect:(CGRect)rect
                 withColor:(UIColor *)color
                 withImage:(NSString *)imageString;

- (UITableView *)addSubTableView:(CGRect)rect withDelegate:(id)object;

- (UIScrollView *)addSubScrollView:(CGRect)rect
                withShow:(BOOL)show
              withBounce:(BOOL)bounce;

- (UISegmentedControl *)addSubSegmentWithRect:(CGRect)rect
                               withTitlsArray:(NSArray *)array
                                withTintColor:(UIColor *)color
                                     withFont:(CGFloat)font
                                      withSel:(SEL)aSelector
                                   withTarget:(id)target;

@end

void UIButtonAddTouchup(UIButton *button, id object, SEL aSelector);

@interface UIButton (Simple)

@property (nonatomic, strong) NSString *imageNormal;
@property (nonatomic, strong) NSString *imageSelecte;
@property (nonatomic, strong) NSString *titleNormal;
@property (nonatomic, strong) NSString *titleSelecte;
@property (nonatomic, strong) UIColor *titleColorNormal;
@property (nonatomic, strong) UIColor *titleColorSelecte;

- (void)addTouchUpTarget:(id)object action:(SEL)aSelector;

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage;

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withTitle:(NSString *)title
             withSelectTitle:(NSString *)selTitle
                   withColor:(UIColor *)color;

@end

@interface UILabel (Simple)

+ (UILabel *)simpleLabelWithRect:(CGRect)rect;

+ (UILabel *)simpleLabelWithRect:(CGRect)rect
                       withColor:(UIColor *)color
                   withAlignment:(NSTextAlignment)alignment
                    withFontSize:(CGFloat)size
                        withText:(NSString *)text
                   withTextColor:(UIColor *)textColor
               withLineBreakMode:(NSLineBreakMode)lineBreakMode
              withLnumberOfLines:(int)numberOfLines;

+ (UILabel *)simpleLabelWithRect:(CGRect)rect
                   withAlignment:(NSTextAlignment)alignment
                    withFontSize:(CGFloat)size
                        withText:(NSString *)text
                   withTextColor:(UIColor *)textColor
                         withTag:(NSInteger)tag;

- (CGSize)estimateUISizeByHeight:(CGFloat)height;

@end

@interface UITableView (Simple)

+ (UITableView *)simpleInit:(CGRect)rect
               withDelegate:(id)object;

@end

@interface UIScrollView (Simple)

+ (UIScrollView *)simpleInit:(CGRect)rect
                    withShow:(BOOL)show
                  withBounce:(BOOL)bounce;

@end

@interface UITextField (Simple)

+ (UITextField *)textFieldCustomWithFrame:(CGRect)rect
                          withPlaceholder:(NSString *)placeholder;

+ (UITextField *)simpleInit:(CGRect)rect
                  withImage:(NSString *)imageString
            withPlaceholder:(NSString *)placeholder
                   withFont:(CGFloat)font;

@end

@interface UIProgressView (Simple)

@end

@interface UIColor (Simple)

// 返回一个十六进制表示的颜色: 0xFF0000
+ (UIColor *)colorFromHex:(int)hex;

@end

@interface UIImage (Simple)

+ (UIImage *)image:(NSString *)resourceName;
+ (UIImage *)imageWithBundle:(NSString *)fileString;
+ (UIImage *)imageWithFile:(NSString *)path;

@end

@interface UISegmentedControl (Simple)

+ (UISegmentedControl *)simpleInitWithRect:(CGRect)rect
                            withTitlsArray:(NSArray *)array
                             withTintColor:(UIColor *)color
                                  withFont:(CGFloat)font;

@end







