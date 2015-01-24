//
//  FlatRoundedImageView.m
//  Missionsky
//
//  Created by Jamie on 9/23/13.
//  Copyright (c) 2013 FreeDo. All rights reserved.
//

#import "FlatRoundedImageView.h"
@implementation FlatRoundedImageView
@synthesize borderColor,borderWidth;
- (void)awakeFromNib {
    [super awakeFromNib];
    borderColor = [UIColor whiteColor];
    borderWidth = 3.f;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2.0f;


    self.layer.masksToBounds = YES;
}
-(void)setBorderColor:(UIColor *)aborderColor{

    borderColor = aborderColor;
    self.layer.borderColor = borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)aborderWidth{
    borderWidth = aborderWidth;
    self.layer.borderWidth = borderWidth;

}

/**
 @brief 将图片转换成圆形图片
 @param image 传入的图片名称
 @result FlatRoundedImageView 得到的圆形图片对象
 */
+ (FlatRoundedImageView *)contactImageViewWithImage:(UIImage *)image {
    FlatRoundedImageView *imageView = [[FlatRoundedImageView alloc] initWithImage:image];
    imageView.borderColor = [UIColor whiteColor];
    imageView.borderWidth = 3.f;
    imageView.layer.masksToBounds = YES;
    return imageView;
}


@end
