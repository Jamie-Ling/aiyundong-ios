//
//  UIImage+ZKK.h
//  VPhone
//
//  Created by zorro on 14-10-22.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZKK)

// 等比例缩放
- (UIImage*)scaleToSize:(CGSize)size;
+ (UIImage *)resizeImage:(NSString *)imageName;
+ (UIImage *)setImageFromFile:(NSString *)fileString;
// 高斯模糊
- (UIImage*)stackBlur:(NSUInteger)radius;
+ (BOOL)checkPngIsExist:(NSString *)filePath withIndex:(NSString *)imageName;
+ (UIImage *)image:(NSString *)resourceName;

@end
