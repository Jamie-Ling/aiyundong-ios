//
//  LoginVC.m
//  LoveSports
//
//  Created by zorro on 15-1-28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define LoginVC_TextField_Tag 2000

#import "LoginVC.h"
#import "UserModelEntity.h"
#import "RegisterVC.h"
#import "AppDelegate.h"

@interface LoginVC () <UITextFieldDelegate, EntityModelDelegate>

@property (nonatomic, strong) UIView *groundView;

@end

@implementation LoginVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    // [self loadShowWareView];
   
    [self loadTextFileds];
    [self loadButtons];
}

- (void)loadTextFileds
{
    _groundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.27, self.view.frame.size.width, 88)];
    _groundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_groundView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20.0, _groundView.frame.size.height / 2 + 1, _groundView.frame.size.width - 40.0, 2)];
    line.backgroundColor = [UIColor colorWithRed:241.0 / 255 green:241.0 / 255 blue:241.0 / 255 alpha:1.0];
    [_groundView addSubview:line];
    
    // 自行添加左边2个图片的名字.
    NSArray *leftViewImage = @[@"", @""];
    NSArray *placeholder = @[@"请输入账号, 测试阶段", @"直接登录进入"];
    NSArray *textArray = @[@"fly_it@qq.com", @"123456"];
    for (int i = 0; i < 2; i++)
    {
        CGRect viewRect = CGRectMake(20.0, (_groundView.frame.size.height * (i / 2.0 + 1 / 4.0) - 18), 36, 36);
        CGRect textRect = CGRectMake(72, _groundView.frame.size.height * (i / 2.0), _groundView.frame.size.width - 100.0, _groundView.frame.size.height / 2);
        
        UIView *leftView = [[UIView alloc] initWithFrame:viewRect];
        leftView.backgroundColor = [UIColor redColor];
        leftView.layer.contents = (id)[UIImage imageNamed:leftViewImage[i]].CGImage;
        [_groundView addSubview:leftView];
        
        UITextField *textfield = [UITextField textFieldCustomWithFrame:textRect withPlaceholder:placeholder[i]];
        
        textfield.delegate = self;
        textfield.tag = LoginVC_TextField_Tag + i;
        // textfield.text = textArray[i];
        [_groundView addSubview:textfield];
        
        if (i == 1)
        {
            textfield.secureTextEntry = YES;
        }
    }
}

- (void)loadButtons
{
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, _groundView.frame.size.height + _groundView.frame.origin.y + 60.0, self.view.frame.size.width * 0.8, 44)];
    loginButton.backgroundColor = [UIColor colorWithRed:17.0 / 255 green:141.0 / 255 blue:223.0 / 255 alpha:1.0];
    loginButton.layer.cornerRadius = 20.0;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 1.0)];
    line.backgroundColor = [UIColor colorWithRed:127.0 / 255 green:180.0 / 255 blue:195.0 / 255 alpha:0.7];
    [self.view addSubview:line];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 1, self.view.frame.size.height - 41, 1, 40)];
    line.backgroundColor = [UIColor colorWithRed:127.0 / 255 green:180.0 / 255 blue:195.0 / 255 alpha:0.7];
    [self.view addSubview:line];
    
    UIButton *forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width / 2, 40)];
    forgotButton.backgroundColor = [UIColor clearColor];
    [forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgotButton addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotButton];
    
    UIButton *regiButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 40, self.view.frame.size.width / 2, 40)];
    regiButton.backgroundColor = [UIColor clearColor];
    [regiButton setTitle:@"注册" forState:UIControlStateNormal];
    [regiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [regiButton addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regiButton];
}

- (void)clickLoginButton
{
    [self pushToHomeVC];
    return;
    
    UITextField *textField1 = (UITextField *)[_groundView viewWithTag:LoginVC_TextField_Tag];
    UITextField *textField2 = (UITextField *)[_groundView viewWithTag:LoginVC_TextField_Tag + 1];
    
    if ((!textField1 || textField1.text.length == 0)
        || (!textField2 || textField2.text.length == 0))
    {
        SHOWMBProgressHUD(@"请正确输入", nil, nil, NO, 2.0);
        return;
    }
    
    /*
    if (![textField1.text isEmail])
    {
        SHOWMBProgressHUD(@"请正确输入邮箱", nil, nil, NO, 2.0);
        return;
    }
     */
    
    [UserModelEntity sharedInstance].delegate = self;
    [[UserModelEntity sharedInstance] userModelRequestWithRighArgus:@[textField1.text, textField2.text] withRequestType:UserModelEntityRequestLogin];
    
    SHOWMBProgressHUDIndeterminate(nil, @"登录中...", NO);
    
    [self pushToHomeVC];
}

- (void)pushToHomeVC
{
    HIDDENMBProgressHUD;
 
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [app pushToContentVC];
}

- (void)forgotPassword
{
    // 忘记密码这里暂时没有界面
}

// 模态推出注册界面。可以自行改为push根据业务需求
- (void)registerAccount
{
    RegisterVC *regiVc = [[RegisterVC alloc] init];
    
    [self presentViewController:regiVc animated:YES completion:nil];
}

#pragma mark --- 键盘消失 ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    UITextField *textField1 = (UITextField *)[_groundView viewWithTag:LoginVC_TextField_Tag];
    UITextField *textField2 = (UITextField *)[_groundView viewWithTag:LoginVC_TextField_Tag + 1];
    
    if (!CGRectContainsPoint(textField1.frame, point) && !CGRectContainsPoint(textField2.frame, point))
    {
        [self.view endEditing:YES];
    }
}

#pragma mark --- EntityModelDelegate ---
// 请求成功
- (void)entityModelRefreshFromServerSucceed:(BaseModelEntity *)em withTag:(NSInteger)tag
{
    if (tag == 0)
    {
        // 登录成功。看需要推到哪个界面。自行操作..
   
    }
}

// 请求失败
- (void)entityModelRefreshFromServerFailed:(BaseModelEntity *)em error:(NSError *)err withTag:(NSInteger)tag
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UserModelEntity sharedInstance].delegate = nil;
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
