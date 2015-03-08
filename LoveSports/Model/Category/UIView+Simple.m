//
//  UIView+Simple.m
//  ZKKUIViewExtension
//
//  Created by zorro on 15/2/10.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIView+Simple.h"

@implementation UIView (Simple)

- (void)setImage:(UIImage *)image
{
    self.layer.contents = (id)image.CGImage;
}

- (UIImage *)image
{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)(self.layer.contents)];
}

- (void)setImageNamed:(NSString *)imageNamed
{
    self.layer.contents = (id)[UIImage image:imageNamed].CGImage;
}

- (NSString *)imageNamed
{
    return @"";
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)totalWidth
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTotalWidth:(CGFloat)totalWidth
{
    CGRect frame = self.frame;
    frame.origin.x = totalWidth - frame.size.width;
    self.frame = frame;
}

- (CGFloat)totalHeight
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTotalHeight:(CGFloat)totalHeight
{
    CGRect frame = self.frame;
    frame.origin.y = totalHeight - frame.size.height;
    self.frame = frame;
}

- (CGFloat)halfWidth
{
    return self.width / 2.0;
}

- (void)setHalfWidth:(CGFloat)width
{}

- (CGFloat)halfHeight
{
    return self.height / 2.0;
}

- (void)setHalfHeight:(CGFloat)height
{}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)removeAllGestureRecognizers
{
    for (UIGestureRecognizer *ges in self.gestureRecognizers)
    {
        [self removeGestureRecognizer:ges];
    }
}

- (UIButton *)addSubButtonWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage
                     withSel:(SEL)aSelector
                        withTarget:(id)target
{
    UIButton *button = [UIButton simpleWithRect:rect withImage:image withSelectImage:selImage];
    if (aSelector)
    {
        [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:button];
    
    return button;
}

- (UIButton *)addSubButtonWithRect:(CGRect)rect
                   withTitle:(NSString *)title
             withSelectTitle:(NSString *)selTitle
                   withColor:(UIColor *)color
                     withSel:(SEL)aSelector
                        withTarget:(id)target
{
    UIButton *button = [UIButton simpleWithRect:rect withTitle:title withSelectTitle:selTitle withColor:color];
    if (aSelector)
    {
        [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:button];
    
    return button;
}

- (UILabel *)addSubLabelWithRect:(CGRect)rect
                       withColor:(UIColor *)color
                   withAlignment:(NSTextAlignment)alignment
                    withFontSize:(CGFloat)size
                        withText:(NSString *)text
                   withTextColor:(UIColor *)textColor
          withLineBreakMode:(NSLineBreakMode)lineBreakMode
         withLnumberOfLines:(int)numberOfLines
{
    UILabel *label = [UILabel simpleLabelWithRect:rect
                                        withColor:color
                                    withAlignment:alignment
                                     withFontSize:size
                                         withText:text
                                    withTextColor:textColor
                                withLineBreakMode:lineBreakMode
                               withLnumberOfLines:numberOfLines];
    [self addSubview:label];
    
    return label;
}

- (UILabel *)addSubLabelWithRect:(CGRect)rect
              withAlignment:(NSTextAlignment)alignment
               withFontSize:(CGFloat)size
                   withText:(NSString *)text
              withTextColor:(UIColor *)textColor
                    withTag:(NSInteger)tag

{
    UILabel *label = [UILabel simpleLabelWithRect:rect
                                    withAlignment:alignment
                                     withFontSize:size
                                         withText:text
                                    withTextColor:textColor
                                          withTag:tag];
    [self addSubview:label];
    
    return label;
}

- (UIView *)addSubViewWithRect:(CGRect)rect
                 withColor:(UIColor *)color
                 withImage:(NSString *)imageString
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    if (color)
    {
        view.backgroundColor = color;
    }
    else
    {
        view.backgroundColor = [UIColor clearColor];
    }
    if (imageString)
    {
        view.layer.contents = (id)[UIImage image:imageString].CGImage;
    }
    [self addSubview:view];
    
    return view;
}

- (UITableView *)addSubTableView:(CGRect)rect withDelegate:(id)object
{
    UITableView *tableView = [UITableView simpleInit:rect withDelegate:object];
    [self addSubview:tableView];
    
    return tableView;
}

- (UIScrollView *)addSubScrollView:(CGRect)rect
                    withShow:(BOOL)show
                  withBounce:(BOOL)bounce
{
    UIScrollView *scrollView = [UIScrollView simpleInit:rect withShow:show withBounce:bounce];
    [self addSubview:scrollView];
    
    return scrollView;
}

- (UISegmentedControl *)addSubSegmentWithRect:(CGRect)rect
                            withTitlsArray:(NSArray *)array
                             withTintColor:(UIColor *)color
                                  withFont:(CGFloat)font
                                   withSel:(SEL)aSelector
                                   withTarget:(id)target
{
    UISegmentedControl *seg = [UISegmentedControl simpleInitWithRect:rect withTitlsArray:array withTintColor:color withFont:font];
    if (target && aSelector)
    {
        [seg addTarget:target action:aSelector forControlEvents:UIControlEventValueChanged];
    }
    [self addSubview:seg];
    
    return seg;
}

@end

void UIButtonAddTouchup(UIButton *button, id object, SEL aSelector)
{
    [button addTarget:object action:aSelector forControlEvents:UIControlEventTouchUpInside];
}

@implementation UIButton (Simple)

@dynamic imageNormal;
@dynamic imageSelecte;
@dynamic titleNormal;
@dynamic titleSelecte;
@dynamic titleColorNormal;
@dynamic titleColorSelecte;

- (void)setImageNormal:(NSString *)imageNormal
{
    [self setImage:[UIImage image:imageNormal] forState:UIControlStateNormal];
}

- (void)setImageSelecte:(NSString *)imageSelecte
{
    [self setImage:[UIImage image:imageSelecte] forState:UIControlStateSelected];
}

- (void)setTitleNormal:(NSString *)titleNormal
{
    [self setTitle:titleNormal forState:UIControlStateNormal];
}

- (void)setTitleSelecte:(NSString *)titleSelecte
{
    [self setTitle:titleSelecte forState:UIControlStateSelected];
}

- (void)setTitleColorNormal:(UIColor *)titleColorNormal
{
    [self setTitleColor:titleColorNormal forState:UIControlStateNormal];
}

- (void)setTitleColorSelecte:(UIColor *)titleColorSelecte
{
    [self setTitleColor:titleColorSelecte forState:UIControlStateSelected];
}

- (void)addTouchUpTarget:(id)object action:(SEL)aSelector
{
    [self addTarget:object action:aSelector forControlEvents:UIControlEventTouchUpInside];
}

+ (UIButton *)simpleWithRect:(CGRect)rect
                   withImage:(NSString *)image
             withSelectImage:(NSString *)selImage
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if (selImage)
    {
        [button setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    }
    else
    {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateSelected];
    }
    
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
    if (selTitle)
    {
        [button setTitle:selTitle forState:UIControlStateSelected];
    }
    else
    {
        [button setTitle:title forState:UIControlStateSelected];
    }
    
    button.selected = NO;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

    return button;
}

@end

@implementation UILabel (Simple)

+ (UILabel *)simpleLabelWithRect:(CGRect)rect;
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    return label;
}

+ (UILabel *)simpleLabelWithRect:(CGRect)rect
                       withColor:(UIColor *)color
                   withAlignment:(NSTextAlignment)alignment
                    withFontSize:(CGFloat)size
                        withText:(NSString *)text
                   withTextColor:(UIColor *)textColor
                   withLineBreakMode:(NSLineBreakMode)lineBreakMode
                   withLnumberOfLines:(int)numberOfLines

{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.backgroundColor = color;
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:size];
    label.text = text ? text : @"";
    label.textColor = textColor;
    label.lineBreakMode = lineBreakMode;
    label.numberOfLines = numberOfLines;
    
    return label;
}

+ (UILabel *)simpleLabelWithRect:(CGRect)rect
                   withAlignment:(NSTextAlignment)alignment
                    withFontSize:(CGFloat)size
                        withText:(NSString *)text
                   withTextColor:(UIColor *)textColor
                         withTag:(NSInteger)tag
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:size];
    label.text = text ? text : @"";
    label.textColor = textColor;
    label.tag = tag;
    
    return label;
}

#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
    if ( nil == self.text || 0 == self.text.length )
        return CGSizeMake( 0.0f, height );
    
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(10000, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
    // return MB_MULTILINE_TEXTSIZE(self.text, self.font, CGSizeMake(999999.0f, height), self.lineBreakMode);
}

@end

@implementation UITableView (Simple)

+ (UITableView *)simpleInit:(CGRect)rect withDelegate:(id)object
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    
    tableView.dataSource = object;
    tableView.delegate = object;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    
    return tableView;
}

@end

@implementation UIScrollView (Simple)

+ (UIScrollView *)simpleInit:(CGRect)rect
                    withShow:(BOOL)show
                  withBounce:(BOOL)bounce
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = show;
    scrollView.showsVerticalScrollIndicator = show;
    scrollView.bounces = bounce;
    
    return scrollView;
}

@end

@implementation UITextField (Simple)

+ (UITextField *)textFieldCustomWithFrame:(CGRect)rect
                          withPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.backgroundColor = [UIColor clearColor];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:18.0];
    
    return textField;
}

+ (UITextField *)simpleInit:(CGRect)rect
                  withImage:(NSString *)imageString
            withPlaceholder:(NSString *)placeholder
                   withFont:(CGFloat)font
{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.backgroundColor = [UIColor clearColor];
    //_textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.background = [UIImage imageNamed:imageString];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:font];
    UIColor *color = UIColorRGB(172, 151, 179);
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                      attributes:@{NSForegroundColorAttributeName : color}];
    
    return textField;
}

@end

@implementation UIProgressView (Simple)

@end

@implementation UIColor (Simple)

+ (UIColor *)colorFromHex:(int)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

@end

@implementation UIImage (Simple)

+ (UIImage *)image:(NSString *)resourceName
{
    UIImage *img = nil;
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)])
    {
        img = [[UIImage imageNamed:resourceName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        img = [UIImage imageNamed:resourceName];
    }
    
    return img;
}

+ (UIImage *)imageWithBundle:(NSString *)fileString
{
    return  [UIImage imageWithFile:[[NSBundle mainBundle]pathForResource:fileString ofType:nil]];
}

+ (UIImage *)imageWithFile:(NSString *)path
{
    UIImage *img = nil;
    
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)])
    {
        img = [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        img = [UIImage imageWithContentsOfFile:path];
    }
    
    return img;
}

@end

@implementation UISegmentedControl (Simple)

+ (UISegmentedControl *)simpleInitWithRect:(CGRect)rect
                            withTitlsArray:(NSArray *)array
                             withTintColor:(UIColor *)color
                                  withFont:(CGFloat)font
{
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:array];
    
    seg.frame = rect;
    seg.tintColor = color;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:font],
                           NSForegroundColorAttributeName: [UIColor whiteColor]};
    [seg setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} forState:UIControlStateNormal];
    [seg setTitleTextAttributes:dict forState:UIControlStateSelected];
    seg.selectedSegmentIndex = 0;
    
    return seg;
}

@end




