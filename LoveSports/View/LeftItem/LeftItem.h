//
//  LeftItem.h
//  ZKKWaterHeater
//
//  Created by zorro on 15-1-5.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftItem : UIButton

@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIViewSimpleBlock backBlock;

- (instancetype)initWithFrame:(CGRect)frame withBackBlock:(UIViewSimpleBlock)block;

@end
