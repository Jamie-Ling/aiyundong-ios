//
//  SignatureViewController.m
//  PAChat
//
//  Created by Coson on 13-9-16.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()
{
    UITextView *txtView;
    BOOL isFirst;
    UIScrollView *scroll;
    UILabel *textNumLabel;
    BOOL bIsThisView;
}

@end

@implementation SignatureViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    bIsThisView = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bIsThisView = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"个性签名";
    bIsThisView = NO;
    
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(cancel) ImageName:@""];
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:@"保存" target:self selector:@selector(backtohome) ImageName:@""];
    
    isFirst = YES;
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 140)];
    txtView.layer.cornerRadius = 8;
    [txtView becomeFirstResponder];
    txtView.layer.borderWidth = 1;
    txtView.returnKeyType = UIReturnKeyDone;
    txtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtView.font = kTextFontSize;
    txtView.delegate = self;
    txtView.text=self.signatureString;
    txtView.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.8f];
    txtView.autocorrectionType = UITextAutocorrectionTypeNo;
    [scroll addSubview:txtView];
    
    textNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 130, 100, 15)];
    textNumLabel.backgroundColor = [UIColor clearColor];
    textNumLabel.font = [UIFont systemFontOfSize:14];
    textNumLabel.textColor = [UIColor blackColor];
    if (self.signatureString.length > 30)
    {
        textNumLabel.text = @"30/30";
    }
    else
    {
        textNumLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)txtView.text.length];
    }
    [scroll addSubview:textNumLabel];
    [self.view addSubview:scroll];
    self.view.backgroundColor=kBackgroundColor;
    
}
-(void)backtohome
{
    if ([txtView.text length] > 30)
    {
        [UIView showAlertView:@"个性签名长度过长，请重新设置" andMessage:nil];
        return;
    }
    [[ObjectCTools shared] refreshTheUserInfoDictionaryWithKey:kUserInfoOfDeclarationKey withValue:txtView.text];
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)cancel {
//    [self.navigationController popViewControllerAnimated:YES];
//}
#pragma mark-
#pragma mark UITextViewDelegte

- (void)textViewDidChange:(UITextView *)textView {
    
    if (bIsThisView)
    {
        int length = (int)textView.text.length;
        if (length > 30)
        {
            textNumLabel.text = @"30/30";
        }
        else
        {
            textNumLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)textView.text.length];
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if (textView.text.length > 30) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 30)];
        }
        return NO;
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    int MAX_CHARS = 30;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textView.text];
    
//    [newtxt replaceCharactersInRange:range withString:text];
    if (textView.text.length > 30) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 30)];
    }
    
    int length = (int)newtxt.length;
    
    return (length < MAX_CHARS);
}

#pragma mark --
#pragma mark UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
   
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    self.view.center =CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    if (textField.text.length >= 30) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 30)];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
