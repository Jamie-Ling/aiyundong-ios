//
//  FlatRoundedImageView.h
//  Missionsky
//
//  Created by Jamie on 9/23/13.
//  Copyright (c) 2013 FreeDo. All rights reserved.
//  圆形图片，一般用于头像

#import <UIKit/UIKit.h>

@interface FlatRoundedImageView : UIImageView
@property(nonatomic,strong)UIColor* borderColor;
@property(nonatomic,assign)CGFloat borderWidth;

/**
 @brief 将图片转换成圆形图片
 @param image 传入的图片名称
 @result FlatRoundedImageView 得到的圆形图片对象
 */
+ (FlatRoundedImageView *)contactImageViewWithImage:(UIImage *)image;
@end
