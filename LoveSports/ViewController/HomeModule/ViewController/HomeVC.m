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
    for (int i = 0; i < vcArray.count; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        button.backgroundColor = [UIColor redColor];
        button.exclusiveTouch = YES;
        NSString *title = [NSString stringWithFormat:@"%d", i + 1];
      
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.selected = NO;
        
        if (i == 0)
        {
            [button setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor clearColor]];
        }
        
        [itemsArray addObject:button];
    }
    
    HomeVC *tabBarController = [[HomeVC alloc] initWithViewControllers:vcArray items:itemsArray];
    
    return tabBarController;
}

//- (void) tabBar:(ZKKTabBar *)tabBar didSelectIndex:(NSInteger)index
//{
//    if (_firstComeUserCenterVC && index == 0)
//    {
//        [self.navigationController pushViewController:[self.viewControllers objectAtIndex:0] animated:YES];
//        return;
//    }
//    
//    if (index == 0)
//    {
//        _firstComeUserCenterVC = YES;
//    }
//    [super tabBar:tabBar didSelectIndex:index];
//}

@end
