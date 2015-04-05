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

@interface LoginBindingVC () <ShowWareViewDelegate>

@property (nonatomic, strong) ShowWareView *wareView;

@end

@implementation LoginBindingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"绑定硬件";

    // Do any additional setup after loading the view.
}

- (void)loadShowWareView
{
    _wareView = [[ShowWareView alloc] initWithFrame:CGRectMake(0, 0, self.view.width , self.view.height - 64)];
    
    _wareView.delegate = self;
    // _wareView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    // [_wareView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:nil dismissBlock:nil];
    [self.view addSubview:_wareView];
    
    [self loadSkipButton];
}

- (void)loadSkipButton
{
    UIButton *skipButton = [UIButton simpleWithRect:CGRectMake(60, self.height - 64, self.width - 120, 64)
                                          withTitle:@"跳过, 以后再绑定"
                                    withSelectTitle:@"跳过, 以后再绑定"
                                          withColor:[UIColor clearColor]];
    [self addSubview:skipButton];
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
