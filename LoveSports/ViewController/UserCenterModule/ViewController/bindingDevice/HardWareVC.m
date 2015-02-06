//
//  HardWareVC.m
//  LoveSports
//
//  Created by zorro on 15-1-29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "HardWareVC.h"
#import "BLTManager.h"
#import "BLTSendData.h"
#import "BLTAcceptData.h"
#import "TimeZoneView.h"

@interface HardWareVC () <UIAlertViewDelegate>

@property (nonatomic, strong) BLTModel *model;

@property (nonatomic, strong) UIButton *bindingButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UILabel *testLabel;

@property (nonatomic, strong) UILabel *wareUUID;
@property (nonatomic, strong) UILabel *wareName;
@property (nonatomic, strong) UIButton *removeButton;

@property (nonatomic, strong) TimeZoneView *timeView;

@end

@implementation HardWareVC

- (instancetype)initWithModel:(BLTModel *)model
{
    self = [super init];
    if (self)
    {
        _model = model;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = _model.bltName;
    self.view.layer.contents = (id)[UIImage image:@"login_background@2x.jpg"].CGImage;
    
    [self loadLabels];
    NSString *curUUID = [BLTManager sharedInstance].model.bltID;
    if ([_model.bltID isEqualToString:curUUID])
    {
        [self loadBindingSetting];
        [self bltIsConnect];
    }
    else
    {
        [self loadNoBindingSetting];
        
        __weak HardWareVC *safeSelf = self;
        [BLTManager sharedInstance].connectBlock = ^() {
            [safeSelf bltIsConnect];
        };
    }
}

- (void)loadLabels
{
    NSArray *leftText = @[@"设备ID", @"设备名称"];
    NSArray *rightText = @[_model.bltID, _model.bltName];
    for (int i = 0; i < 2; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + i * (80), self.view.width, 75)];
        view.backgroundColor = UIColorRGB(253, 180, 30);
        [self.view addSubview:view];
        
        UILabel *label = [UILabel customLabelWithRect:CGRectMake(20, 15 + i * (80), 100, 75)
                                            withColor:[UIColor clearColor]
                                        withAlignment:NSTextAlignmentLeft
                                         withFontSize:18.0
                                             withText:leftText[i]
                                        withTextColor:[UIColor blackColor]];
        [self.view addSubview:label];
        
        label = [UILabel customLabelWithRect:CGRectMake(self.view.width * 0.4, 15 + i * (80), self.view.width * 0.6, 75)
                                   withColor:[UIColor clearColor]
                               withAlignment:NSTextAlignmentLeft
                                withFontSize:18.0
                                    withText:rightText[i]
                               withTextColor:[UIColor blackColor]];
        label.numberOfLines = 3;
        [self.view addSubview:label];
    }
}

- (void)loadBindingSetting
{
    _removeButton = [UIButton
                     simpleWithRect:CGRectMake(20, 200, self.view.width - 40, 44)
                     withTitle:@"解除绑定"
                     withSelectTitle:@"解除绑定"
                     withColor:UIColorRGB(253, 180, 30)];
    [_removeButton addTarget:self action:@selector(removeHardWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeButton];
}

- (void)loadNoBindingSetting
{
    UIButton *ignoreButton = [UIButton
                              simpleWithRect:CGRectMake(20, 200, self.view.width - 40, 44)
                              withTitle:@"忽略此设备"
                              withSelectTitle:@"忽略此设备"
                              withColor:UIColorRGB(253, 180, 30)];
    [ignoreButton addTarget:self action:@selector(clickIgnoreButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ignoreButton];
    
    _bindingButton = [UIButton
                      simpleWithRect:CGRectMake(20, 264, self.view.width - 40, 44)
                      withTitle:@"绑定连接"
                      withSelectTitle:@"绑定连接"
                      withColor:UIColorRGB(253, 180, 30)];
    [_bindingButton addTarget:self action:@selector(bindingHardWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindingButton];
}

- (void)loadButtons
{
    _bindingButton = [UIButton
                      simpleWithRect:CGRectMake(20, 20, 160, 40)
                      withTitle:@"绑定连接"
                      withSelectTitle:@"绑定连接"
                      withColor:[UIColor redColor]];
    [_bindingButton addTarget:self action:@selector(bindingHardWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindingButton];
 
    /*
    _testButton = [UIButton
                     simpleWithRect:CGRectMake(20, 160, 200, 40)
                     withTitle:@"测试点击获取固件时间"
                     withSelectTitle:@"测试点击获取固件时间"
                     withColor:[UIColor redColor]];
    [_testButton addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_testButton];
    
    _testLabel = [UILabel customLabelWithRect:CGRectMake(20, 220, 200, 100)
                                    withColor:[UIColor whiteColor]
                                withAlignment:NSTextAlignmentLeft
                                 withFontSize:20 withText:@""
                                withTextColor:[UIColor blackColor]];
    _testLabel.numberOfLines = 4;
    [self.view addSubview:_testLabel];
     */
}

- (void)bindingHardWare
{
    _model.isBinding = YES;
    [LS_BindingID setObjectValue:_model.bltID];
    
     [[BLTManager sharedInstance] repareConnectedDevice:_model];
     SHOWMBProgressHUD(@"连接设备中...", nil, nil, NO, 5);
}

- (void)removeHardWare
{
    _model.isBinding = NO;
    [LS_BindingID setObjectValue:@""];
}

// 忽略该设备
- (void)clickIgnoreButton
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重要提示" message:@"忽略此设备以后将无法搜到该设备." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    alertView.delegate = self;
    [alertView show];
}

- (void)testClick
{
    DEF_WEAKSELF_(HardWareVC)
    [BLTSendData sendCheckDateOfHardwareDataWithUpdateBlock:^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeCheckWareTime)
        {
            [weakSelf changeTestLabelText:object];
        }
    }];
}

- (void)changeTestLabelText:(NSString *)text
{
    _testLabel.text = text;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        _model.isIgnore = YES;
        [[BLTManager sharedInstance].allWareArray removeObject:_model];
        [_model saveToDB];
    }
}

- (void)bltIsConnect
{
    HIDDENMBProgressHUD;
    
    if (![LS_SettingBaseInfo getBOOLValue] || 1)
    {
        _timeView = [[TimeZoneView alloc] initWithFrame:CGRectMake(0, 0, 180, 200)];
        
        _timeView.backgroundColor = [UIColor whiteColor];
        _timeView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
        [_timeView popupWithtype:PopupViewOption_colorLump touchOutsideHidden:NO succeedBlock:nil dismissBlock:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [BLTManager sharedInstance].connectBlock = nil;
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
