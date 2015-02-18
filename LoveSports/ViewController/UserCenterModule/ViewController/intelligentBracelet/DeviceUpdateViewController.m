//
//  DeviceUpdateViewController.m
//  LoveSports
//
//  Created by jamie on 15/2/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceUpdateViewController.h"

@interface DeviceUpdateViewController ()
{
    UIButton *_updateButton;
}

@end

@implementation DeviceUpdateViewController
@synthesize _thisBraceletInfoModel, _thisVersionInfoModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"固件升级";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addAllControll];
    if ([_thisVersionInfoModel._versionID isEqualToString:_thisBraceletInfoModel._deviceVersion] && 0)
    {
        [_updateButton setHidden:YES];
    }
    else
    {
        [_updateButton setHidden:NO];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BraceletInfoModel getUsingLKDBHelper] insertToDB:_thisBraceletInfoModel];
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addAllControll
{
    [self.view removeAllSubviews];
    
    // left label
    NSString *titleString = [NSString stringWithFormat:@"%@       %@\n%@。", _thisVersionInfoModel._versionID, _thisVersionInfoModel._versionSize, _thisVersionInfoModel._versionUpdatInfo];
    CGRect titleFrame = CGRectMake(26, kStatusBarHeight, kButtonDefaultWidth, 24);
    UILabel *title = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                 backgroundColor:[UIColor clearColor]
                                                            text:titleString
                                                       textColor:kLabelTitleDefaultColor
                                                            font:[UIFont systemFontOfSize:14]
                                                   textAlignment:NSTextAlignmentLeft
                                                   lineBreakMode:0
                                                   numberOfLines:0];
    
    [[ObjectCTools shared] setLableLineSpacing:title withLableString:title.text withLineSpacing:6];
    [title sizeToFit];
    [title setX:26.0];

    [self.view addSubview:title];
   
    
    //升级按钮
    CGRect overButtonFrame = CGRectMake(26.0, title.bottom + kNavigationBarHeight, kButtonDefaultWidth, kButtonDefaultHeight);
    _updateButton = [[ObjectCTools shared] getACustomButtonWithBackgroundImage:overButtonFrame
                                                                     titleNormalColor:kPageTitleColor
                                                                titleHighlightedColor:nil
                                                                                title:@"马上升级"
                                                                                 font:kButtonFontSize
                                                            normalBackgroundImageName:kButtonBackGroundImage
                                                       highlightedBackgroundImageName:nil
                                                                   accessibilityLabel:@"updateButton"];
    kCenterTheView(_updateButton);
    [_updateButton addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_updateButton];

}

- (void) updateVersion
{
    NSLog(@"开始请求并升级");
    
    _thisBraceletInfoModel._deviceVersion = _thisVersionInfoModel._versionID;
    
   // [UIView showAlertView:@"升级成功" andMessage:nil];
   // [self goBackPrePage];
    
    [[BLTManager sharedInstance] prepareUpdateFirmWare];
}

@end
