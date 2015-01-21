//
//  ZKKTabBar.h
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZKKTabBarDelegate;

@interface ZKKTabBar : UIView

@property (nonatomic, retain) NSMutableArray *itemsArray;            // 选项
@property (nonatomic, retain) UIImageView *backgroundView;      // 背景
@property (nonatomic, retain) UIImageView *animatedView;        // 选中item时的图片

@property (nonatomic, assign) id <ZKKTabBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)setupItem:(UIButton *)item index:(NSInteger)index;
- (void)resetAnimatedView:(UIImageView *)animatedView index:(NSInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end

@protocol ZKKTabBarDelegate <NSObject>

@optional
- (BOOL)tabBar:(ZKKTabBar *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)tabBar:(ZKKTabBar *)tabBar didSelectIndex:(NSInteger)index;
- (void)tabBar:(ZKKTabBar *)tabBar animatedView:(UIImageView *)animatedView item:(UIButton *)item index:(NSInteger)index;

@end