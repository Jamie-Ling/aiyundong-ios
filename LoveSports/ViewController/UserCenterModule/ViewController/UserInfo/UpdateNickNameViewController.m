//
//  UpdateNickNameViewController.m
//  Woyoli
//
//  Created by jamie on 14/12/15.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//  更新昵称

#import "UpdateNickNameViewController.h"

@interface UpdateNickNameViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    UIView *_upView;
    UITextField *_nickNameTextField;
}

@end

@implementation UpdateNickNameViewController
@synthesize _lastNickName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"昵称";
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    
    [self addAllControl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_nickNameTextField becomeFirstResponder];
    if (![NSString isNilOrEmpty:_lastNickName ])
    {
        [_nickNameTextField setText:_lastNickName];
    }
}

#pragma mark ---------------- 页面布局 -----------------
//添加所有控件
- (void) addAllControl
{
    _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kIOS7OffHeight)];
    _upView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_upView];
    
    //昵称
    CGRect newPasswordTextfieldFrame = CGRectMake(26.0, 30.0, kButtonDefaultWidth, kButtonDefaultHeight);
    _nickNameTextField = [[ObjectCTools shared] getACustomTextFiledWithFrame:newPasswordTextfieldFrame
                                                                  withPlaceholder:kUpdateNickNamePlaceHoldText
                                                                          withTag:0
                                                                withLeftImaegName:@""
                                                                         withZoom:0
                                                                  withBorderStyle:UITextBorderStyleRoundedRect
                                                                 withKeyboardType:UIKeyboardTypeDefault
                                                                       toDelegate:self
                                                                   withIsPassword:NO
                                                              withPaddingViewText:@""
                                                                withReturnKeyType:UIReturnKeyDone];
    [_upView addSubview:_nickNameTextField];
    
    //完成按钮
    CGRect overButtonFrame = CGRectMake(_nickNameTextField.x, _nickNameTextField.bottom + 32, kButtonDefaultWidth, kButtonDefaultHeight);
    UIButton *overButton = [[ObjectCTools shared] getACustomButtonWithBackgroundImage:overButtonFrame
                                                                     titleNormalColor:kPageTitleColor
                                                                titleHighlightedColor:nil
                                                                                title:@"保 存"
                                                                                 font:kButtonFontSize
                                                            normalBackgroundImageName:kButtonBackGroundImage
                                                       highlightedBackgroundImageName:nil
                                                                   accessibilityLabel:@"overButton"];
    kCenterTheView(overButton);
    [overButton addTarget:self action:@selector(overChangeNickName) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:overButton];
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) overChangeNickName
{
    if (_nickNameTextField.text.length == 0)
    {
        [_nickNameTextField shake];
        [_nickNameTextField becomeFirstResponder];
        return;
    }
    if ([_nickNameTextField.text isEqualToString:_lastNickName])
    {
        SHOWMBProgressHUD(@"昵称无修改哦~", nil, nil, NO, 2.0);

        [_nickNameTextField becomeFirstResponder];
        return;
    }

    if ([_nickNameTextField.text isContainQuotationMark])
    {
        SHOWMBProgressHUD(@"不能带有'或者\"符号", nil, nil, NO, 2);
        [_nickNameTextField becomeFirstResponder];

        return;
    }

    [self.view endEditing:YES];
    NSLog(@"发送新的昵称请求吧，同时成功后存储至NSUserDefaults");
    
    //[[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfNickNameKey withValue:_nickNameTextField.text];
    
    [UserInfoHelp sharedInstance].userModel.nickName = _nickNameTextField.text;
    [self goBackPrePage];
    
    
}


#pragma mark ---------------- UITextFieldDelegate -----------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nickNameTextField)
    {
        [self overChangeNickName];
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark ---------------- 键盘控制 -----------------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
