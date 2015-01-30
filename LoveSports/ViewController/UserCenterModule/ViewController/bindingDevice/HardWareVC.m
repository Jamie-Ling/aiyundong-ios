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

@interface HardWareVC ()

@property (nonatomic, strong) BLTModel *model;

@property (nonatomic, strong) UIButton *bindingButton;
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UILabel *testLabel;

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
    
    [self loadButtons];
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
    
    _removeButton = [UIButton
                      simpleWithRect:CGRectMake(20, 80, 160, 40)
                      withTitle:@"解除绑定"
                      withSelectTitle:@"解除绑定"
                      withColor:[UIColor redColor]];
    [_removeButton addTarget:self action:@selector(removeHardWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeButton];
    
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

- (void)testClick
{
    [BLTSendData sendCheckDateOfHardwareData];
    
    __weak HardWareVC *safeSelf = self;
    [BLTAcceptData sharedInstance].updateValue = ^(id object, BLTAcceptDataType type) {
        if (type == BLTAcceptDataTypeWareTime)
        {
            [safeSelf changeTestLabelText:object];
        }
    };
}

- (void)changeTestLabelText:(NSString *)text
{
    _testLabel.text = text;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTAcceptData sharedInstance].updateValue = nil;
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
