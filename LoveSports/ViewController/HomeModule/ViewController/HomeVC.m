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

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"pop_up_box_frame_high224.png"]];
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
        
        [itemsArray addObject:button];
    }
    
    HomeVC *tabBarController = [[HomeVC alloc] initWithViewControllers:vcArray items:itemsArray];

    return tabBarController;
}

@end
