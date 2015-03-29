//
//  TrendStepView.h
//  LoveSports
//
//  Created by zorro on 15/3/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendStepView : UIView

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIViewSimpleBlock backBlock;

- (instancetype)initWithFrame:(CGRect)frame withBlock:(UIViewSimpleBlock)backBlock;

@end
