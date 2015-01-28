//
//  BindIngDeviceViewController.m
//  LoveSports
//
//  Created by jamie on 15/1/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BindIngDeviceViewController.h"

@interface BindIngDeviceViewController ()

@end

@implementation BindIngDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绑定硬件";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------- 页面布局 -----------------




#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
