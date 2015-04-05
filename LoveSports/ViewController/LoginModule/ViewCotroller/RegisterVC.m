//
//  RegisterVC.m
//  ZKKLogin
//
//  Created by zorro on 15-1-15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define RegisterVC_TextField_Tag 3000
#import "RegisterVC.h"
#import "UserModelEntity.h"

@interface RegisterVC () <UITextFieldDelegate, EntityModelDelegate>

@property (nonatomic, strong) UIView *groundView;

@end

@implementation RegisterVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UserModelEntity sharedInstance].delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     需要注意文件冲突
     上次热水器和本次相同的文件有
     /Model/Network/Header.h
     /ThirdClasses/MBProgressHUD/ZKKBaseObject.h
     */
    
    /*
     注册的时候出现问题.
     可能原因是字段不对, 注册时由移动端还是服务器进行md5。
     */
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[IQKeyboardManager sharedManager] setEnable:YES];

    [self loadTextFileds];
    [self loadButtons];
}

- (void)loadTextFileds
{
    _groundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _groundView.backgroundColor = [UIColor clearColor];
    _groundView.layer.contents = (id)[UIImage imageNamed:@"login_background@2x.jpg"].CGImage;
    [self.view addSubview:_groundView];
    
    UILabel *label = [UILabel customLabelWithRect:CGRectMake(0, self.view.height * 0.3 - 75, self.view.width, 30)
                                        withColor:[UIColor clearColor]
                                    withAlignment:NSTextAlignmentCenter
                                     withFontSize:20.0
                                         withText:@"注册"
                                    withTextColor:[UIColor whiteColor]];
    [_groundView addSubview:label];
    
    for (int i = 0; i < 5; i++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20.0, _groundView.frame.size.height * 0.3 + i * 50 , _groundView.frame.size.width - 40.0, 1)];
        line.backgroundColor = [UIColor colorWithRed:241.0 / 255 green:241.0 / 255 blue:241.0 / 255 alpha:1.0];
        [_groundView addSubview:line];
    }
    
    // 自行添加左边2个图片的名字.
    NSArray *leftViewImage = @[@"", @"", @"", @"", @""];
    NSArray *placeholder = @[@"用户名", @"请输入密码", @"请再次输入密码", @"请输入邮箱", @"请输入手机号码"];
    for (int i = 0; i < 5; i++)
    {
        CGRect viewRect = CGRectMake(20.0, _groundView.frame.size.height * 0.3 - 44 + i * 50, 0, 44);
        CGRect textRect = CGRectMake(viewRect.origin.x + viewRect.size.width + 3.0, _groundView.frame.size.height * 0.3 - 44 + i * 50, _groundView.frame.size.width - (viewRect.origin.x + viewRect.size.width + 23.0), 44);
        
        UIView *leftView = [[UIView alloc] initWithFrame:viewRect];
        leftView.backgroundColor = [UIColor redColor];
        leftView.layer.contents = (id)[UIImage imageNamed:leftViewImage[i]].CGImage;
        [_groundView addSubview:leftView];
        
        UITextField *textfield = [UITextField textFieldCustomWithFrame:textRect withPlaceholder:placeholder[i]];
        
        textfield.delegate = self;
        textfield.tag = RegisterVC_TextField_Tag + i;
        [_groundView addSubview:textfield];
        
        if (i == 1 || i == 2)
        {
            textfield.secureTextEntry = YES;
        }
    }
}

- (void)loadButtons
{
    UITextField *textFiled = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 4];
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, textFiled.totalHeight + 20.0, self.view.frame.size.width - 40, 44)];
    loginButton.backgroundColor = UIColorRGB(253, 180, 30);
    [loginButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(registerButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 1.0)];
    line.backgroundColor = [UIColor colorWithRed:127.0 / 255 green:180.0 / 255 blue:195.0 / 255 alpha:0.7];
    [self.view addSubview:line];
    
    UIButton *forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40.0, self.view.frame.size.width, 40.0)];
    forgotButton.backgroundColor = [UIColor clearColor];
    [forgotButton setTitle:@"返回登录" forState:UIControlStateNormal];
    [forgotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgotButton addTarget:self action:@selector(backLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotButton];
}

- (void)registerButton
{
    UITextField *textField1 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag];
    UITextField *textField2 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 1];
    UITextField *textField3 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 2];
    UITextField *textField4 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 3];
    UITextField *textField5 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 4];

    // 注册的昵称和密码如果有什么要求可自行另外添加。这里只判断不为空
    
    if ((!textField1 || textField1.text.length == 0)
        || (!textField2 || textField2.text.length == 0)
        || (!textField3 || textField2.text.length == 0)
        || (!textField4 || textField2.text.length == 0))
    {
        SHOWMBProgressHUD(@"请正确输入", nil, nil, NO, 2.0);
        return;
    }
    
    /*
    if (![textField2.text isEmail])
    {
        SHOWMBProgressHUD(@"邮箱格式不对", nil, nil, NO, 2.0);
        return;
    }
    */
    
    if (![textField2.text isEqualToString:textField3.text])
    {
        SHOWMBProgressHUD(@"密码不一致", nil, nil, NO, 2.0);
        return;
    }
    
    [UserModelEntity sharedInstance].delegate = self;
    [[UserModelEntity sharedInstance] userModelRequestWithRighArgus:@[textField1.text, textField2.text,
                                                                      textField4.text, textField5.text]
                                                    withRequestType:UserModelEntityRequestRegister];
    
    SHOWMBProgressHUDIndeterminate(nil, @"注册中...", NO);
}

// 模态推出注册界面。可以自行改为push根据业务需求
- (void)backLoginVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    UITextField *textField1 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag];
    UITextField *textField2 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 1];
    UITextField *textField3 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 2];
    UITextField *textField4 = (UITextField *)[_groundView viewWithTag:RegisterVC_TextField_Tag + 3];
    
    if (!CGRectContainsPoint(textField1.frame, point)
        && !CGRectContainsPoint(textField2.frame, point)
        && !CGRectContainsPoint(textField3.frame, point)
        && !CGRectContainsPoint(textField4.frame, point))
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
