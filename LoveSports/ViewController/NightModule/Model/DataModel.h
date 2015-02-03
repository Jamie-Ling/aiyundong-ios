//
//  DataModel.h
//  ZKK绘图测试橡皮擦
//
//  Created by zorro on 15-2-3.
//  Copyright (c) 2015年 deyiff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIColor *color;

@end
