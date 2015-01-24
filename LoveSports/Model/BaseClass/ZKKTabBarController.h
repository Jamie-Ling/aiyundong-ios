//
//  ZKKTabBarController.h
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ZKKViewController.h"
#import "ZKKTabBar.h"
@protocol ZKKTabBarControllerDelegate;

@interface ZKKTabBarController : ZKKViewController <ZKKTabBarDelegate>

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) UIViewController *selectedViewController;
@property (nonatomic, retain, readonly) NSArray *viewControllers;

@property (nonatomic, assign) CGRect tabBarFrame;   // the default height is 49 at bottom.
@property (nonatomic, assign) CGRect contentFrame;  // the default frame is self.view.bounds without tabBarFrame

@property (nonatomic, retain) ZKKTabBar *tabBar;
@property (nonatomic, retain, readonly) UIView *contentView; // 自视图控制器显示的view

@property (nonatomic, assign) id <ZKKTabBarControllerDelegate> delegate;

- (id)initWithViewControllers:(NSArray *)vcs items:(NSArray *)items;

- (void)loadContentViews;

@end

#pragma mark-
#pragma mark- ZKKTabBarControllerDelegate
@protocol ZKKTabBarControllerDelegate <NSObject>

@optional
- (BOOL)tabBarController:(ZKKTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(ZKKTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

#pragma mark-
#pragma mark- XYTabBarController()

@interface UIViewController (ZKKTabBarVC)

@property(nonatomic, retain, readonly) ZKKTabBarController *tabBarController;

@end
