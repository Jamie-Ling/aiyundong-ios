//
//  MSIntroView.h
//  EAIntroView
//
//  Created by jamie on 14-10-27.
//  Copyright (c) 2014年 SampleCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>

@interface MSIntroView : UIView

typedef enum MSIntroViewType {
    showIntroWithCrossDissolve = 0,    //交叉溶解
    showIntroWithFixedTitleView = 1,   //固定标题视图
    showIntroWithCustomPages = 2,    //自定义页面
    showIntroWithCustomView = 3,    //自定义视图
    showIntroWithCustomViewFromNib = 4,         //自定义视图从Nib文件
    showIntroWithSeparatePagesInitAndPageCallback = 5,   //单独页面初始化和页面回调
    showCustomIntro = 6   //显示自定义简介
} MSIntroViewType;

+ (EAIntroView *) initWithType: (MSIntroViewType) type rootView:(UIView *)rootView  delegate:(id<EAIntroDelegate> ) delegate;

@end
