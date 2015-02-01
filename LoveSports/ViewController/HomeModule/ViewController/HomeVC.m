//
//  HomeVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HomeVC.h"

#import "UserCenterVC.h"
#import "RunningVC.h"
#import "NightVC.h"
#import "MapVC.h"
#import "CoffeeVC.h"
#import "MoreVC.h"

@interface HomeVC()
{
    BOOL _firstComeUserCenterVC;  //第一次进入用户中心
}

@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"1_01"]];
    
    [self setSelectedIndex:1];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

+ (id)custom
{
    UserCenterVC *vc1 = [[UserCenterVC alloc] init];
    RunningVC *vc2 = [[RunningVC alloc] init];
    NightVC *vc3 = [[NightVC alloc] init];
    MapVC *vc4 = [[MapVC alloc] init];
    CoffeeVC *vc5 = [[CoffeeVC alloc] init];
    MoreVC *vc6 = [[MoreVC alloc] init];
    
    NSArray *vcArray = @[vc1, vc2, vc3, vc4, vc5, vc6];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *imagesArray = @[@"头像", @"顶部四格1", @"顶部四格2", @"顶部四格3", @"顶部四格4", @"更多"];
    for (int i = 0; i < vcArray.count; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 35)];
        
        button.backgroundColor = [UIColor clearColor];
        button.exclusiveTouch = YES;
        button.selected = NO;
        [button setImage:[UIImage imageNamed:imagesArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imagesArray[i]] forState:UIControlStateSelected];
       
        //注意，头像按钮是用户设置的（来自服务器或本地设置）  --- jamie
        if (i == 0)
        {
            button = [[ObjectCTools shared] getARoundedButtonWithSize:40 withImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey] objectForKey:kUserInfoOfHeadPhotoKey]];
        }
        //--------------------------------------------------------
        
        
        [itemsArray addObject:button];
    }
    
    HomeVC *tabBarController = [[HomeVC alloc] initWithViewControllers:vcArray items:itemsArray];
    
    return tabBarController;
}


#pragma mark ---------------- 用户中心导航条推出管控 -----------------
//重用父类方法，实现用户中心的导航条推出方式-1
- (void) tabBar:(ZKKTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    if (_firstComeUserCenterVC && index == 0)
    {
        //动画显示推出用户中心
        [self pushTheUserCenterVCByAnimation];
        [self.navigationController setNavigationBarHidden:NO];
        
        return;
    }
    if (index == 0)
    {
        _firstComeUserCenterVC = YES;
    }
    [super tabBar:tabBar didSelectIndex:index];
}

//动画显示用户中心
- (void) pushTheUserCenterVCByAnimation
{
        CATransition *animation = [CATransition animation];
        [animation setDuration:1.0];
        [animation setType:kCATransitionFade]; //淡入淡出
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];

        [self.navigationController pushViewController:[self.viewControllers objectAtIndex:0] animated:NO];
}

//重用父类方法，实现用户中心的导航条推出方式-2
- (void)loadContentViews
{
    [super loadContentViews];  //父类方法中屏蔽了导航条设置  -3
    [self.navigationController setNavigationBarHidden:YES];
}

@end
