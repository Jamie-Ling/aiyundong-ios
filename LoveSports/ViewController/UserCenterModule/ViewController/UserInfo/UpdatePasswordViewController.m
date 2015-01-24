//
//  UpdatePasswordViewController.m
//  Woyoli
//
//  Created by jamie on 14-11-17.
//  Copyright (c) 2014年 Jamie.ling. All rights reserved.
//
#define vKeyBoardUpHeight 72.0
#define vPhoneTextFieldTag 100
#define vSMSTextFieldTag 200

#define vPasswordTextFieldTag 400
#define vNewPasswordTextField_2Tag 500

#define vSMSAlertTag  10011

#import "UpdatePasswordViewController.h"
//#import "ResetPasswordViewController.h"
#import "NoPasteTextField.h"
#import "AppDelegate.h"
//#import "RetrievePassWordViewController.h"
#import "UITextField+_extra.h"

@interface UpdatePasswordViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField *_oldPasswordTextField;
    UIView *_upView;
    UITextField *_passwordTextField;
    UITextField *_newPasswordTextField_2;
}

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    
    [self addAllControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_oldPasswordTextField becomeFirstResponder];
}

#pragma mark ---------------- 页面布局 -----------------
//添加所有控件
- (void) addAllControl
{
    _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kIOS7OffHeight)];
    _upView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_upView];
    
    //验证码->改成旧密码
    CGRect smsTextfieldFrame = CGRectMake(26.0 + 2.0, 30.0 + (kIPhone4s ? -15 : 0), kButtonDefaultWidth - 2.0, kButtonDefaultHeight);
    _oldPasswordTextField = [[ObjectCTools shared] getACustomTextFiledWithFrame:smsTextfieldFrame
                                                        withPlaceholder:kUpdatePasswordPlaceHoldText
                                                                withTag:vSMSTextFieldTag
                                                      withLeftImaegName:@""
                                                               withZoom:0
                                                        withBorderStyle:UITextBorderStyleRoundedRect
                                                       withKeyboardType:UIKeyboardTypeAlphabet
                                                             toDelegate:self
                                                         withIsPassword:YES
                                                    withPaddingViewText:@""
                                                      withReturnKeyType:UIReturnKeyNext];
    [_upView addSubview:_oldPasswordTextField];
    
    //密码
    CGRect passwordTextfieldFrame = CGRectMake(_oldPasswordTextField.x, _oldPasswordTextField.bottom + 8, kButtonDefaultWidth, kButtonDefaultHeight);
    _passwordTextField = [[ObjectCTools shared] getACustomTextFiledWithFrame:passwordTextfieldFrame
                                                             withPlaceholder:kNewPasswordPlaceHoldText
                                                                     withTag:vPasswordTextFieldTag
                                                           withLeftImaegName:@""
                                                                    withZoom:0
                                                             withBorderStyle:UITextBorderStyleRoundedRect
                                                            withKeyboardType:UIKeyboardTypeAlphabet
                                                                  toDelegate:self
                                                              withIsPassword:YES
                                                         withPaddingViewText:@""
                                                           withReturnKeyType: UIReturnKeyNext];
    [_upView addSubview:_passwordTextField];
    
    //重复新密码
    CGRect newPassword2TextfieldFrame = CGRectMake(_oldPasswordTextField.x, _passwordTextField.bottom + 8, kButtonDefaultWidth, kButtonDefaultHeight);
    _newPasswordTextField_2 = [[ObjectCTools shared] getACustomTextFiledWithFrame:newPassword2TextfieldFrame
                                                                  withPlaceholder:kNewPassword2PlaceHoldText
                                                                          withTag:vNewPasswordTextField_2Tag
                                                                withLeftImaegName:@""
                                                                         withZoom:0
                                                                  withBorderStyle:UITextBorderStyleRoundedRect
                                                                 withKeyboardType:UIKeyboardTypeAlphabet
                                                                       toDelegate:self
                                                                   withIsPassword:YES
                                                              withPaddingViewText:@""
                                                                withReturnKeyType:UIReturnKeyDone];
    [_upView addSubview:_newPasswordTextField_2];
    
    
    //验证按钮 -》后修改为完成按钮
    CGRect checkButtonFrame = CGRectMake(_oldPasswordTextField.x, _newPasswordTextField_2.bottom + (kIPhone4s ? 25 : 50), kButtonDefaultWidth, kButtonDefaultHeight);
    UIButton *checkButton = [[ObjectCTools shared] getACustomButtonWithBackgroundImage:checkButtonFrame
                                                                      titleNormalColor:kPageTitleColor
                                                                 titleHighlightedColor:nil
                                                                                 title:@"完 成"
                                                                                  font:kButtonFontSize
                                                             normalBackgroundImageName:@"loginButtonDefault.png"
                                                        highlightedBackgroundImageName:nil
                                                                    accessibilityLabel:@"checkButton"];
    kCenterTheView(checkButton);
    [checkButton addTarget:self action:@selector(overChangeThePassword) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:checkButton];
    
    //忘记密码
    CGRect forgetPasswordButtonFrame = CGRectMake(kScreenWidth - 130, _newPasswordTextField_2.bottom + (kIPhone4s ? 2 : 20), 120, 20);
    UIButton *forgetPasswordButton = [[ObjectCTools shared] getACustomButtonNoBackgroundImage:forgetPasswordButtonFrame
                                                                               backgroudColor:[UIColor clearColor]
                                                                             titleNormalColor:kLabelTitleDefaultColor
                                                                        titleHighlightedColor:kHoldPlacerColor
                                                                                        title:@"忘记密码"
                                                                                         font:kTextFeildFontSize
                                                                                 cornerRadius:0
                                                                                  borderWidth:0
                                                                                  borderColor:nil
                                                                           accessibilityLabel:@"registerButton"];
    [forgetPasswordButton sizeToFit];
    CGPoint forgetPasswordButtonCenter = CGPointMake(_newPasswordTextField_2.right - 10 - forgetPasswordButton.width / 2.0, forgetPasswordButton.centerY);
    //下划线2
    UIView *aLine2 = [[UIView alloc] initWithFrame:CGRectMake(forgetPasswordButtonCenter.x - forgetPasswordButton.width / 2.0 , forgetPasswordButtonCenter.y + forgetPasswordButton.height / 2.0  - 8, forgetPasswordButton.width, 1.0)];
    [aLine2 setBackgroundColor: kLabelTitleDefaultColor];
    [aLine2 setUserInteractionEnabled:NO];
    [_upView addSubview:aLine2];
    //恢复button宽度和位置
    [forgetPasswordButton setFrame:forgetPasswordButtonFrame];
    [forgetPasswordButton setCenter:forgetPasswordButtonCenter];
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:forgetPasswordButton];
    
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

//返回登录页
- (void) goToLoginPage
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[[ObjectCTools shared] getAppDelegate] signOut];
}


- (void) overChangeThePassword
{
    if (_oldPasswordTextField.text.length == 0)
    {
        [_oldPasswordTextField shake];
        [_oldPasswordTextField becomeFirstResponder];
        return;
    }
    if (![[ObjectCTools shared] checkPassword:_oldPasswordTextField.text])
    {
        [UIView showAlertView:@"旧密码不正确" andMessage:@""];
        [_oldPasswordTextField becomeFirstResponder];
        return;
    }
    if (_passwordTextField.text.length == 0)
    {
        [_passwordTextField shake];
        [_passwordTextField becomeFirstResponder];
        return;
    }
    if (_newPasswordTextField_2.text.length == 0)
    {
        [_newPasswordTextField_2 shake];
        [_newPasswordTextField_2 becomeFirstResponder];
        return;
    }
    
    if ([[ObjectCTools shared] checkPassword:_passwordTextField.text] && [[ObjectCTools shared] checkPassword:_newPasswordTextField_2.text])
    {
        if ( ![_passwordTextField.text isEqualToString:_newPasswordTextField_2.text])
        {
            [UIView showAlertView:@"密码不一致" andMessage:@"请重新输入密码"];
            _newPasswordTextField_2.text = @"";
            _passwordTextField.text = @"";
            [_passwordTextField becomeFirstResponder];
            return;
        }
        
        NSLog(@"开始请求更新密码吧，更新成功后提示弹框后调用goToLoginPage方法");
        
        
    }
    else
    {
        [UIView showAlertView:@"密码格式不对" andMessage:kPasswordErrorMessage];
        _newPasswordTextField_2.text = @"";
        _passwordTextField.text = @"";
        [_passwordTextField becomeFirstResponder];
        return;
    }
    [self.view endEditing:YES];
}

#pragma mark ---------------- UITextFieldDelegate -----------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _newPasswordTextField_2)
    {
        [self overChangeThePassword];
        [self.view endEditing:YES];
    }
    else if (textField == _oldPasswordTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        [_newPasswordTextField_2 becomeFirstResponder];
    }
    return YES;
}

//忘记密码
- (void) forgetPasswordButton
{
    NSLog(@"----忘记密码, 跳转至忘记密码页面");
//    RetrievePassWordViewController *retrievePassWordVC = [[RetrievePassWordViewController alloc] init];
//    retrievePassWordVC._haveLogin = YES;
//    [self.navigationController pushViewController:retrievePassWordVC animated:YES];
 
}

#pragma mark ---------------- 键盘控制 -----------------

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
