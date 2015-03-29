//
//  TrendTypeView.h
//  LoveSports
//
//  Created by zorro on 15/3/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendTypeView : UIView

@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIViewSimpleBlock backBlock;

@property (nonatomic, assign) CGFloat offset;

- (instancetype)initWithFrame:(CGRect)frame
                   withOffset:(CGFloat)offset
                    withBlock:(UIViewSimpleBlock)backBlock;

@end
