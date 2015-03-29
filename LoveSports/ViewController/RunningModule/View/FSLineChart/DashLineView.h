//
//  DashLineView.h
//  LoveSports
//
//  Created by zorro on 15/3/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashLineView : UIView

@property (nonatomic, assign) NSInteger hori;
@property (nonatomic, assign) NSInteger vert;

- (void)setHoriAndVert:(NSInteger)hori vert:(NSInteger)vert;

@end
