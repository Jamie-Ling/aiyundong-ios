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
#import "ShowWareView.h"

@interface HomeVC()
{
    BOOL _firstComeUserCenterVC;  //第一次进入用户中心
}

@property (nonatomic, strong) ShowWareView *deviceView;

@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@""]];
    
    [self setSelectedIndex:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self updateImageForTabBar];
    
    __weak HomeVC *safeSelf = self;
    [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model)
    {
        if (safeSelf.deviceView)
        {
            [safeSelf.deviceView reFreshDevice];
        }
    };
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [BLTManager sharedInstance].updateModelBlock = nil;
}

- (void)updateImageForTabBar
{
    UIButton *button = [self.tabBar.itemsArray lastObject];
    UIView *view = [button viewWithTag:5555];
    view.image = [[DataShare sharedInstance] getHeadImage];
}

+ (id)custom
{
    UserCenterVC *vc1 = [[UserCenterVC alloc] init];
    RunningVC *vc2 = [[RunningVC alloc] init];
    NightVC *vc3 = [[NightVC alloc] init];
    MapVC *vc4 = [[MapVC alloc] init];
    CoffeeVC *vc5 = [[CoffeeVC alloc] init];
    MoreVC *vc6 = [[MoreVC alloc] init];
    
    NSArray *vcArray = @[vc2, vc3, vc4, vc5, vc6, vc1];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *imagesArray = @[@"顶部四格-1@2x.png", @"顶部四格-2@2x.png", @"", @"", @"", @"默认头像@2x.png"];
    NSArray *selImagesArray = @[@"顶部四格-1选中@2x.png", @"顶部四格-2-选中@2x.png", @"", @"", @"", @"默认头像@2x.png"];

    for (int i = 0; i < vcArray.count; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, vc2.width / 6, 44)];
        
        button.backgroundColor = [UIColor clearColor];
        button.exclusiveTouch = YES;
        button.selected = NO;
        [button setImage:[UIImage imageNamed:imagesArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selImagesArray[i]] forState:UIControlStateSelected];
       
        //注意，头像按钮是用户设置的（来自服务器或本地设置）  --- jamie
        if (i == 5)
        {
            /*
            button = [[ObjectCTools shared] getARoundedButtonWithSize:40 withImageUrl:[[[NSUserDefaults standardUserDefaults] objectForKey:kLastLoginUserInfoDictionaryKey] objectForKey:kUserInfoOfHeadPhotoKey]];
             */
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(button.halfWidth - 20, 2, 40, 40)];
            view.backgroundColor = [UIColor clearColor];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 44.0 / 2;
            view.tag = 5555;
            view.userInteractionEnabled = NO;
            view.image = [[DataShare sharedInstance] getHeadImage];
            [button addSubview:view];
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
    if (index == 5)
    {
        //动画显示推出用户中心
        [self pushTheUserCenterVCByAnimation];
        [self.navigationController setNavigationBarHidden:NO];
        
        return;
    }
    
    if (index == 2 || index == 3 || index == 4)
    {
        /*
        if (index == 4)
        {
            [self popDeviceView];
        }
         */
        
        return;
    }
    
    if (index == 5)
    {
        // _firstComeUserCenterVC = YES;
    }
    
    [super tabBar:tabBar didSelectIndex:index];
}

- (void)popDeviceView
{
    if (!_deviceView)
    {
        _deviceView = [[ShowWareView alloc] initWithFrame:CGRectMake(0, 0, self.width * 0.8, self.height * 0.6) withPop:YES];
        _deviceView.center = CGPointMake(self.width / 2, self.height / 2);
    }
    
    _deviceView.backgroundColor = [UIColor whiteColor];
    [_deviceView popupWithtype:PopupViewOption_colorLump succeedBlock:^(UIView *view) {
    } dismissBlock:^(UIView *view) {
        [_deviceView removeFromSuperview];
        _deviceView = nil;
    }];
}

//动画显示用户中心
- (void) pushTheUserCenterVCByAnimation
{
    /*
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.35];
        [animation setType:kCATransitionFade]; //淡入淡出
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];

        [self.navigationController pushViewController:[self.viewControllers lastObject] animated:NO];
     */
    
    [UIView transitionWithView:self.navigationController.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.navigationController pushViewController:[self.viewControllers lastObject] animated:NO];
                    } completion:nil];
}

//重用父类方法，实现用户中心的导航条推出方式-2
- (void)loadContentViews
{
    [super loadContentViews];  //父类方法中屏蔽了导航条设置  -3
    [self.navigationController setNavigationBarHidden:YES];
}

@end
