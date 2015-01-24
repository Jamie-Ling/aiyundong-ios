//
//  MSDatePicker.m
//  Woyoli
//
//  Created by jamie on 14-11-29.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//

//布局
#define vViewHeight 255.0

#define vButtonHeight 48.0
#define vButtonLeaveSide  0  //距离左右
#define vButtonLeaveEarchOther 3.0  //彼此距离
#define vButtonLeaveDatePicker 0  //距离上面datepick距离
#define vButtonWidth ((kScreenWidth - vButtonLeaveSide * 2 - vButtonLeaveEarchOther) / 2.0)

//外观
#define vBackgroundColor kBackgroundColor

#define vButtonTitleColor kPageTitleColor
#define vButtonBackgroundColor kButtonBackgroundColor
#define vButtonSize kButtonFontSize

#define vButtonCornerRadius   0
#define vButtonBorderWidth  0
#define vButtonBorderColor 0

//动画
#define vSemiModalAnimationDuration 0.3f            //时长

#import "MSDatePicker.h"
#import <QuartzCore/QuartzCore.h>

@interface MSDatePicker()<UIScrollViewDelegate>
{
}

@property (nonatomic, strong) UIButton *_canceButton;
@property (nonatomic, strong) UIButton *_sureButton;
@property (nonatomic, strong) UIDatePicker *_customDatePicker;
@property (nonatomic, weak) id<MSDatePickerDelegate> _delegate;

@end

@implementation MSDatePicker

@synthesize _canceButton;
@synthesize _sureButton;
@synthesize _customDatePicker;
@synthesize _delegate;


- (id) initwithYMDDatePickerDelegate:(id<MSDatePickerDelegate>)delegate withMinimumDate:(NSString *)minimumDate withMaximumDate: (NSDate *) maximumDate withNowDate: (NSDate *) nowDate
{
    if ([super initWithFrame:CGRectMake(0, kScreenHeight - vViewHeight, kScreenWidth, vViewHeight)])
    {
        _delegate = delegate;
        [self setBackgroundColor:kBackgroundColor];
        [self addDatePickerWithMinimumDate:minimumDate withMaximumDate:maximumDate withNowDate:nowDate];
        [self addButton];
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
    }
    return self;
}

- (void) addDatePickerWithMinimumDate:(NSString *)minimumDate withMaximumDate: (NSDate *) maximumDate withNowDate: (NSDate *) nowDate
{
    
    _customDatePicker = [[UIDatePicker alloc] init];
    [_customDatePicker setFrame:CGRectMake(0, 20, self.width, self.height - vButtonHeight - vButtonLeaveSide - vButtonLeaveDatePicker)];
    [_customDatePicker setCenterX:self.width / 2.0];
    [_customDatePicker setBounds:CGRectMake(0, 0, 420, 500)];
    _customDatePicker.datePickerMode=UIDatePickerModeDate;
    
    // 设置时区
//    [_customDatePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [_customDatePicker setTimeZone:timeZone];
    //设置为显示中文
    _customDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    //设置日期最大最小值
    _customDatePicker.minimumDate= [dateFormatter dateFromString:minimumDate];
    _customDatePicker.maximumDate= maximumDate;
    //
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    [_customDatePicker setDate:nowDate animated:YES];

    [self addSubview:_customDatePicker];
}

- (void) addButton
{
    //canceButton
    CGRect canceButtonRect = CGRectMake(vButtonLeaveSide, self.height - vButtonLeaveSide - vButtonHeight, vButtonWidth, vButtonHeight);
    _canceButton = [[ObjectCTools shared] getACustomButtonNoBackgroundImage:canceButtonRect
                                                                  backgroudColor:vButtonBackgroundColor
                                                                titleNormalColor:vButtonTitleColor
                                                           titleHighlightedColor:[UIColor grayColor]
                                                                           title:@"取 消"
                                                                            font:kButtonFontSize
                                                                    cornerRadius:vButtonCornerRadius
                                                                     borderWidth:0
                                                                     borderColor:0
                                                              accessibilityLabel:@"canceButton"];
    [_canceButton addTarget:self action:@selector(dismissModalView) forControlEvents:UIControlEventTouchUpInside];
//    kCenterTheView(self._canceButton);
    [self addSubview:_canceButton];
    
    //makesu
    CGRect sureButtonRect = CGRectMake(kScreenWidth - vButtonLeaveSide - vButtonWidth, self.height - vButtonLeaveSide - vButtonHeight, vButtonWidth, vButtonHeight);
    _sureButton = [[ObjectCTools shared] getACustomButtonNoBackgroundImage:sureButtonRect
                                                             backgroudColor:vButtonBackgroundColor
                                                           titleNormalColor:vButtonTitleColor
                                                      titleHighlightedColor:[UIColor grayColor]
                                                                      title:@"确 定"
                                                                       font:kButtonFontSize
                                                               cornerRadius:vButtonCornerRadius
                                                                borderWidth:0
                                                                borderColor:0
                                                         accessibilityLabel:@"sureButton"];
    [_sureButton addTarget:self action:@selector(sureTheDate) forControlEvents:UIControlEventTouchUpInside];
    //    kCenterTheView(self._canceButton);
    [self addSubview:_sureButton];
}


- (void) sureTheDate
{
    NSLog(@"告诉代理日期");
    [_delegate checkOneDate:_customDatePicker.date];
    
    [self dismiss];
}


/**
 *  读取数据刷新界面
 */
- (void)reloadData
{
}





#pragma mark - 动作 & 遮盖
/**
 *  弹出模态视窗
 *
 *  @param view 展现的父view
 */
-(void)showInView:(UIView *)view
{
    [self presentModelView];
    [self reloadData];
}

- (void)dismiss
{
    [self dismissModalView];
}

- (void)presentModelView
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    //    NSLog(@"%@", keywindow);
    if (![keywindow.subviews containsObject:self]) {
        // Calulate all frames
        CGRect sf = self.frame;
        CGRect vf = keywindow.frame;
        CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
        CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
        
        // Add semi overlay
        UIView * overlay = [[UIView alloc] initWithFrame:keywindow.bounds];
        overlay.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
        
        UIView* ss = [[UIView alloc] initWithFrame:keywindow.bounds];
        [overlay addSubview:ss];
        [keywindow addSubview:overlay];
        
        //点击其它地方消失
        UIControl * dismissButton = [[UIControl alloc] initWithFrame:CGRectZero];
        [dismissButton addTarget:self action:@selector(dismissModalView) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = of;
        [overlay addSubview:dismissButton];
        
        // 遮盖动画
        [UIView animateWithDuration:vSemiModalAnimationDuration animations:^{
            ss.alpha = 0.5;
        }];
        
        // 自我动画
        self.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
        [keywindow addSubview:self];
        //去除阴影特效
        //        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        //        self.layer.shadowOffset = CGSizeMake(0, -2);
        //        self.layer.shadowRadius = 5.0;
        //        self.layer.shadowOpacity = 0.8;
        [UIView animateWithDuration:vSemiModalAnimationDuration animations:^{
            self.frame = f;
        }];
    }
}

- (void)dismissModalView
{
    UIWindow * keywindow = [[UIApplication sharedApplication] keyWindow];
    UIView * modal = [keywindow.subviews objectAtIndex:keywindow.subviews.count-1];
    UIView * overlay = [keywindow.subviews objectAtIndex:keywindow.subviews.count-2];
    [UIView animateWithDuration:vSemiModalAnimationDuration animations:^{
        modal.frame = CGRectMake(0, keywindow.frame.size.height, modal.frame.size.width, modal.frame.size.height);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
    }];
    
    // Begin overlay animation
    UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
    [UIView animateWithDuration:vSemiModalAnimationDuration animations:^{
        ss.alpha = 1;
    }];
}

@end
