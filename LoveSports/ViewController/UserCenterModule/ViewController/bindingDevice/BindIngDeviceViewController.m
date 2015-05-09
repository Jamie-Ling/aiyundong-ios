//
//  BindIngDeviceViewController.m
//  LoveSports
//
//  Created by jamie on 15/1/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BindIngDeviceViewController.h"
#import "ShowWareView.h"
#import "BLTManager.h"
#import "HardWareVC.h"

@interface BindIngDeviceViewController () <ShowWareViewDelegate>

@property (nonatomic, strong) ShowWareView *wareView;

@end

@implementation BindIngDeviceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BLTManager sharedInstance] checkOtherDevices];
    
    __weak BindIngDeviceViewController *safeSelf = self;
    [BLTManager sharedInstance].updateModelBlock = ^(BLTModel *model)
    {
        if (safeSelf.wareView)
        {
            [safeSelf.wareView reFreshDevice];
        }
    };
    
    [_wareView reFreshDevice];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [BLTManager sharedInstance].updateModelBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LS_Text(@"Paired with hardware");
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back")
                                                                                    target:self
                                                                                  selector:@selector(goBackPrePage)
                                                                                 ImageName:@""];
    [self loadShowWareView];
}

- (void)loadShowWareView
{
    _wareView = [[ShowWareView alloc] initWithFrame:CGRectMake(0, 0, self.view.width , self.view.height - 64)];
    
    _wareView.delegate = self;
    //_wareView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    //[_wareView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:YES succeedBlock:nil dismissBlock:nil];
    [self.view addSubview:_wareView];
}

- (void)didReceiveMemoryWarning
{
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

// ShowWareViewDelegate;
- (void)showWareViewSelectHardware:(ShowWareView *)wareView withModel:(BLTModel *)model
{
    HardWareVC *wareVC = [[HardWareVC alloc] initWithModel:model];
    
    [self.navigationController pushViewController:wareVC animated:YES];
}

@end
