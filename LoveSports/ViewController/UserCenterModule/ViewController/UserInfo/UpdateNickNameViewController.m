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
    
    self.title = LS_Text(@"Nickname");
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back")
                                                                                    target:self
                                                                                  selector:@selector(goBackPrePage)
                                                                                 ImageName:@""];
      self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:LS_Text(@"Save")
                                                                                        target:self
                                                                                      selector:@selector(overChangeNickName)
                                                                                     ImageName:@""];
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
                                                                  withPlaceholder:LS_Text(@"Nickname")
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
        [_nickNameTextField becomeFirstResponder];
        
        return;
    }

    if ([_nickNameTextField.text isContainQuotationMark])
    {
        SHOWMBProgressHUD(LS_Text(@"Can't contain"), nil, nil, NO, 2);
        [_nickNameTextField becomeFirstResponder];

        return;
    }

    [self.view endEditing:YES];
    
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
