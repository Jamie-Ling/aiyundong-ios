//
//  LoginBindingVC.m
//  LoveSports
//
//  Created by zorro on 15/3/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "LoginBindingVC.h"
#import "ShowWareView.h"
#import "BLTManager.h"
#import "HardWareVC.h"
#import "AppDelegate.h"

@interface LoginBindingVC () <ShowWareViewDelegate>

@property (nonatomic, strong) ShowWareView *wareView;
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation LoginBindingVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BLTManager sharedInstance] checkOtherDevices];
    
    __weak LoginBindingVC *safeSelf = self;
    [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model)
    {
        if (safeSelf.wareView)
        {
            [safeSelf.wareView reFreshDevice];
        }
    };
    
    [BLTManager sharedInstance].connectBlock = ^() {
        [safeSelf bltIsConnect];
    };
    
    [_wareView reFreshDevice];
}

- (void)bltIsConnect
{
    _skipButton.titleNormal = LS_Text(@"Next");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [BLTManager sharedInstance].updateModelBlock = nil;
    [BLTManager sharedInstance].connectBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LS_Text(@"Pair with device");
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    // Do any additional setup after loading the view.
    
    [self loadShowWareView];
}

- (void)loadShowWareView
{
    _wareView = [[ShowWareView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 128) withOpenHead:YES];
    
    [self.view addSubview:_wareView];
    
    [self loadSkipButton];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    __weak LoginBindingVC *safeSelf = self;
    app.enterForegroundBlock = ^ (id object) {
        [safeSelf.wareView resetAnimationForHeadImage];
    };
}

- (void)loadSkipButton
{
    _skipButton = [UIButton simpleWithRect:CGRectMake(60, self.height - 128, self.width - 120, 64)
                                 withTitle:LS_Text(@"Skip, binding later")
                           withSelectTitle:LS_Text(@"Skip, binding later")
                                 withColor:[UIColor clearColor]];
    _skipButton.titleColorNormal = UIColorFromHEX(0x169ad8);
    [_skipButton addTouchUpTarget:self action:@selector(clickSkipButton:)];
    [self addSubview:_skipButton];
}

- (void)clickSkipButton:(UIButton *)button
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    app.enterForegroundBlock = nil;
    [app pushToContentVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
