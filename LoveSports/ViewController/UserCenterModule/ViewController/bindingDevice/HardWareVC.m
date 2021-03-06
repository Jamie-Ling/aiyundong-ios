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

@interface HardWareVC () <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) BLTModel *model;

@property (nonatomic, strong) UIButton *bindingButton;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UILabel *testLabel;

@property (nonatomic, strong) UILabel *wareUUID;
@property (nonatomic, strong) UILabel *wareName;
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) UIButton *brokenButton;
@property (nonatomic, strong) UIButton *connectButton;

@property (nonatomic, strong) TimeZoneView *timeView;

@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *textFiled;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak HardWareVC *safeSelf = self;
    [BLTManager sharedInstance].connectBlock = ^() {
        [safeSelf bltIsConnect];
    };
    [BLTManager sharedInstance].disConnectBlock = ^() {
        [safeSelf dismissLink];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTManager sharedInstance].connectBlock = nil;
    [BLTManager sharedInstance].disConnectBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = _model.bltName;
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back")
                                                                                    target:self
                                                                                  selector:@selector(goBackPrePage)
                                                                                 ImageName:@""];
    [self loadViewsForConnectState];
}

- (void)loadViewsForConnectState
{
    [self loadLabels];
    if (_model.isBinding && _model.peripheral.state == CBPeripheralStateConnected)
    {
        [self loadBindingAndConnectSetting];
    }
    else if (_model.isBinding && _model.peripheral.state != CBPeripheralStateConnected)
    {
        [self loaoNoConnectAndBindingSetting];
    }
    else
    {
        [self loadNoBindingAndNoConnectSetting];
    }
}

- (void)dismissLink
{
    [self.view removeAllSubviews];
    [self loadViewsForConnectState];
}

- (void)popCurrentVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadLabels
{
    NSArray *leftText = @[LS_Text(@"Device ID"), LS_Text(@"Device name")];
    NSArray *rightText = @[_model.bltID, _model.bltName];
    for (int i = 0; i < 2; i++)
    {
        CGFloat height = i ? 50 : 64;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 12 + i * (68) + LS_NavBarOffset, self.view.width, height)];
        view.backgroundColor = [UIColor whiteColor];
        [view addUpAndDownLine];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel customLabelWithRect:view.bounds
                                            withColor:[UIColor clearColor]
                                        withAlignment:NSTextAlignmentLeft
                                         withFontSize:18.0
                                             withText:leftText[i]
                                        withTextColor:[UIColor blackColor]];
        [view addSubview:label];
        CGFloat width = i ? 150 : self.view.width - 100;

        label = [UILabel customLabelWithRect:CGRectMake(i ? 150 : 100, 0, width, view.height)
                                   withColor:[UIColor clearColor]
                               withAlignment:NSTextAlignmentLeft
                                withFontSize:16.0
                                    withText:rightText[i]
                               withTextColor:UIColorFromHEX(0x169ad8)];
        label.numberOfLines = 3;
        [view addSubview:label];
        
        if (i == 1)
        {
            _nameLabel = label;
            UIButton *button = [UIButton simpleWithRect:CGRectMake(self.width - 60, 15 + i * (80) + (75 - 44)/2.0, 44, 44)
                                              withTitle:@"编辑"
                                        withSelectTitle:@"确认"
                                              withColor:[UIColor greenColor]];
            [button addTarget:self action:@selector(editDeviceName:) forControlEvents:UIControlEventTouchUpInside];
            // [self addSubview:button];
            
            _textFiled = [UITextField simpleInit:CGRectMake(100, 15 + i * (80) + (75 - 44)/2.0, width, 44)
                                       withImage:nil
                                 withPlaceholder:label.text
                                        withFont:18.0];
            [self addSubview:_textFiled];
            _textFiled.hidden = YES;
            _textFiled.keyboardType = UIKeyboardTypeNamePhonePad;
            _textFiled.borderStyle = UITextBorderStyleRoundedRect;
        }
    }
}

- (void)editDeviceName:(UIButton *)button
{
    if (!button.selected)
    {
        _nameLabel.hidden = YES;
        _textFiled.hidden = NO;
        button.selected = YES;
    }
    else
    {
        if (_textFiled.text.length == 0)
        {
            SHOWMBProgressHUD(@"名字不能为空", nil, nil, NO, 2);
            return;
        }
        
        [self.view endEditing:YES];
    
        if ([BLTManager sharedInstance].connectState == BLTManagerConnected)
        {
            DEF_WEAKSELF_(HardWareVC);
            [BLTSendData sendModifyDeviceNameDataWithName:_textFiled.text withUpdateBlock:^(id object, BLTAcceptDataType type) {
                if (type == BLTAcceptDataTypeChangeWareName)
                {
                    SHOWMBProgressHUD(@"修改成功", nil, nil, NO, 2);
                    weakSelf.nameLabel.text = weakSelf.textFiled.text;
                    weakSelf.nameLabel.hidden = NO;
                    weakSelf.textFiled.hidden = YES;
                    [BLTManager sharedInstance].model.bltName = weakSelf.textFiled.text;
                }
                else
                {
                    SHOWMBProgressHUD(@"修改失败", nil, nil, NO, 2);
                    weakSelf.nameLabel.hidden = NO;
                    weakSelf.textFiled.hidden = YES;
                }
            }];
        }
        else
        {
            SHOWMBProgressHUD(@"设备已断开连接", @"无法修改", nil, NO, 2);
        }
    }
}

- (void)loadBindingAndConnectSetting
{
    _removeButton = [UIButton
                     simpleWithRect:CGRectMake(0, 156 + LS_NavBarOffset, self.view.width, 44)
                     withTitle:LS_Text(@"Unpair")
                     withSelectTitle:LS_Text(@"Unpair")
                     withColor:[UIColor whiteColor]];
    [_removeButton addUpAndDownLine];
    _removeButton.titleColorNormal = UIColorFromHEX(0xfc7d18);
    [_removeButton addTarget:self action:@selector(removeHardWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeButton];
}

- (void)loaoNoConnectAndBindingSetting
{
    _connectButton = [UIButton
                               simpleWithRect:CGRectMake(0, 156 + LS_NavBarOffset, self.view.width, 44)
                               withTitle:LS_Text(@"Connect")
                               withSelectTitle:LS_Text(@"Connect")
                               withColor:[UIColor whiteColor]];
    [_connectButton addUpAndDownLine];
    _connectButton.titleColorNormal = UIColorFromHEX(0x169ad8);
    [_connectButton addTarget:self action:@selector(connectDeviceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectButton];

    _removeButton = [UIButton
                     simpleWithRect:CGRectMake(0, 196 + LS_NavBarOffset, self.view.width, 44)
                     withTitle:LS_Text(@"Unpair")
                     withSelectTitle:LS_Text(@"Unpair")
                     withColor:[UIColor whiteColor]];
    [_removeButton addUpAndDownLine];
    _removeButton.titleColorNormal = UIColorFromHEX(0xfc7d18);
    [_removeButton addTarget:self action:@selector(removeHardWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeButton];
}

- (void)loadNoBindingAndNoConnectSetting
{
    UIButton *ignoreButton = [UIButton
                              simpleWithRect:CGRectMake(20, 200 + LS_NavBarOffset, self.view.width - 40, 44)
                              withTitle:@"忽略此设备"
                              withSelectTitle:@"忽略此设备"
                              withColor:UIColorRGB(253, 180, 30)];
    [ignoreButton addTarget:self action:@selector(clickIgnoreButton) forControlEvents:UIControlEventTouchUpInside];
    // [self.view addSubview:ignoreButton];
    
    _bindingButton = [UIButton
                      simpleWithRect:CGRectMake(0, 156 + LS_NavBarOffset, self.view.width, 44)
                      withTitle:LS_Text(@"Paired")
                      withSelectTitle:LS_Text(@"Paired")
                      withColor:[UIColor whiteColor]];
    [_bindingButton addUpAndDownLine];
    _bindingButton.titleColorNormal = UIColorFromHEX(0x169ad8);
    [_bindingButton addTarget:self action:@selector(bindingHardWare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindingButton];
}

- (void)bindingHardWare
{
    _model.isBinding = YES;
    _model.isClickBindSetting = YES;
    
    [[BLTManager sharedInstance] repareConnectedDevice:_model];
    SHOWMBProgressHUD(LS_Text(@"Connecting..."), nil, nil, NO, 5);
}

- (void)brokenLinkButton:(UIButton *)button
{
    button.selected = !button.selected;
    [[BLTManager sharedInstance] dismissLink];
}

- (void)removeHardWare
{
    _model.isBinding = NO;
    [[BLTManager sharedInstance] dismissLinkWithModel:_model];
    
    [self.view removeAllSubviews];
    [self loadLabels];
    [self loadNoBindingAndNoConnectSetting];
}

// 连接设备
- (void)connectDeviceButton:(UIButton *)button
{
    button.selected = !button.selected;
    [[BLTManager sharedInstance] repareConnectedDevice:_model];
    
    SHOWMBProgressHUD(LS_Text(@"Connecting..."), nil, nil, NO, 2);
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
    [self.view removeAllSubviews];
    [self loadViewsForConnectState];
}

#pragma mark --- UITextField Delegate ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange range1 = [string rangeOfString:@"'"];
    NSRange range2 = [string rangeOfString:@"\""];
    
    if (range1.location != NSNotFound || range2.location != NSNotFound)
    {
        SHOWMBProgressHUD(@"包含无效的字符", nil, nil, NO, 2);
        
        return NO;
    }
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [textField.text dataUsingEncoding:gbkEncoding];
    
    NSInteger length = 0;
    if (data.length > textField.text.length)
    {
        NSString *curString = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSInteger count = 0;
        
        for(int i=0; i< [curString length];i++)
        {
            int a = [curString characterAtIndex:i];
            
            if( a > 0x4e00 && a < 0x9fff)
            {
                count++;
            }
        }
        
        length = curString.length + count;
        range.location = length;
    }
    else
    {
        length = data.length;
    }
    
    if ((range.location >= 6 || length >= 6))
    {
        if ([string isEqualToString:@""])
        {
            
            return  YES;
        }
        
        return NO;
    }
    
    return YES;
}

// 检查字符串是否是中文
- (BOOL)checkWhetherAllisChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++)
    {
        int a = [string characterAtIndex:i];
        
        if( a > 0x4e00 && a < 0x9fff)
        {
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self changeTextLengthForTextField:textField];
    
    return YES;
}

// 如果输入栏字符超过6那么把多的减去
- (void)changeTextLengthForTextField:(UITextField *)textField
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [textField.text dataUsingEncoding:gbkEncoding];
    
    if (data.length > 6)
    {
        NSData *newData = [data subdataWithRange:NSMakeRange(0, 6)];
        NSString *newString = [[NSString alloc] initWithData:newData encoding:gbkEncoding];
        
        textField.text = newString;
    }
}

//返回上一页
- (void) goBackPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{

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
