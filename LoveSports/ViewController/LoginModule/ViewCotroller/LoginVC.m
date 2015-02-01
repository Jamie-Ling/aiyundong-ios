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
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, assign) CGFloat intervalY;

@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    // [self loadShowWareView];
   
    _intervalY = self.view.height * 0.02;
    NSLog(@"%f", _intervalY);
    [self loadTextFileds];
    [self loadButtons];
    [self loadLinkLoginButtton];
}

- (void)loadTextFileds
{
    _groundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _groundView.backgroundColor = [UIColor clearColor];
    _groundView.layer.contents = (id)[UIImage image:@"login_background@2x.jpg"].CGImage;
    [self.view addSubview:_groundView];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - 120)/2, self.view.height * 0.07, 120, 120)];
    _headImage.backgroundColor = [UIColor redColor];
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = _headImage.width / 2;
    [_groundView addSubview:_headImage];

    NSArray *viewImages = @[@"username_1_07@2x.png", @"password_1_10@2x.png"];
    NSArray *placeholder = @[@"请输入账号, 测试阶段", @"直接登录进入"];
    NSArray *textArray = @[@"fly_it@qq.com", @"123456"];
    for (int i = 0; i < 2; i++)
    {
        CGRect viewRect = CGRectMake(20.0, _groundView.frame.size.height * 0.12 + 120 + i * (41 + _intervalY), self.view.width - 40, 41);
        CGRect textRect = CGRectMake(60, _groundView.frame.size.height * 0.12 + 120 + i * (41 + _intervalY), _groundView.frame.size.width - 80.0, 41);
        
        UIView *view = [[UIView alloc] initWithFrame:viewRect];
        view.backgroundColor = [UIColor clearColor];
        view.layer.contents = (id)[UIImage imageNamed:viewImages[i]].CGImage;
        [_groundView addSubview:view];
        
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
    UITextField *textFiled = (UITextField *)[_groundView viewWithTag:LoginVC_TextField_Tag + 1];
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, textFiled.totalHeight + _intervalY, self.view.frame.size.width - 40.0, 44)];
    loginButton.backgroundColor = UIColorRGB(253, 180, 30);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:loginButton];
    
    UIButton *visitorButton = [[UIButton alloc] initWithFrame:CGRectMake(20, loginButton.totalHeight, 100, 40)];
    visitorButton.backgroundColor = [UIColor clearColor];
    [visitorButton setTitle:@"访客模式" forState:UIControlStateNormal];
    [visitorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [visitorButton addTarget:self action:@selector(clickVisitorButton) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:visitorButton];
    
    UIButton *regiButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 120, loginButton.totalHeight, 100, 40)];
    regiButton.backgroundColor = [UIColor clearColor];
    [regiButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [regiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regiButton addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:regiButton];
}

// 加载关联账号登录...
- (void)loadLinkLoginButtton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.width * 0.15, self.view.height * 0.75 + 15, 40, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(self.view.width * 0.85 - 40, self.view.height * 0.75 + 15, 40, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:view];
    
    UILabel *label = [UILabel customLabelWithRect:CGRectMake(0, self.view.height * 0.75, self.view.width, 30)
                                        withColor:[UIColor clearColor]
                                    withAlignment:NSTextAlignmentCenter
                                     withFontSize:20.0
                                         withText:@"关联账号登录"
                                    withTextColor:[UIColor whiteColor]];
    [_groundView addSubview:label];
    
    CGFloat interval = ((self.view.width - 44 * 3) - 80) / 2;
    
    UIButton *weiChatButton = [[UIButton alloc] initWithFrame:CGRectMake(40, self.view.height * 0.75 + 40, 44, 44)];
    weiChatButton.backgroundColor = [UIColor clearColor];
    [weiChatButton setImage:[UIImage image:@"微信.png"] forState:UIControlStateNormal];
    [weiChatButton addTarget:self action:@selector(clickWeiChatButton) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:weiChatButton];
    
    UIButton *qqButton = [[UIButton alloc] initWithFrame:CGRectMake(40 + 44 +interval, self.view.height * 0.75 + 40, 44, 44)];
    qqButton.backgroundColor = [UIColor clearColor];
    qqButton.backgroundColor = [UIColor clearColor];
    [qqButton setImage:[UIImage image:@"QQ.png"] forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(clickQQButton) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:qqButton];
    
    UIButton *sinaButton = [[UIButton alloc] initWithFrame:CGRectMake(40 + (44 +interval) * 2, self.view.height * 0.75 + 40, 44, 44)];
    sinaButton.backgroundColor = [UIColor clearColor];
    sinaButton.backgroundColor = [UIColor clearColor];
    [sinaButton setImage:[UIImage image:@"微博@2x.png"] forState:UIControlStateNormal];
    [sinaButton addTarget:self action:@selector(clickSinaButton) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:sinaButton];
    
    UIButton *forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 120, self.view.height - 40, 100, 40)];
    forgotButton.backgroundColor = [UIColor clearColor];
    [forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgotButton addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:forgotButton];
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

- (void)clickVisitorButton
{
   
}

// 模态推出注册界面。可以自行改为push根据业务需求
- (void)registerAccount
{
    RegisterVC *regiVc = [[RegisterVC alloc] init];
    
    [self presentViewController:regiVc animated:YES completion:nil];
}

- (void)clickWeiChatButton
{
    
}

- (void)clickQQButton
{
    
}

- (void)clickSinaButton
{
    
}

- (void)forgotPassword
{
    // 忘记密码这里暂时没有界面
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
