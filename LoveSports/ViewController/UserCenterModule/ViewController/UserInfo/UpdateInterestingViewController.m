//
//  UpdateInterestingViewController.M
//  PAChat
//
//  Created by Coson on 13-9-16.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#define vMaxLenth  30

#import "UpdateInterestingViewController.h"

@interface UpdateInterestingViewController ()
{
    UITextView *txtView;
    BOOL isFirst;
    UIScrollView *scroll;
    UILabel *textNumLabel;
    BOOL bIsThisView;
}

@end

@implementation UpdateInterestingViewController
@synthesize _lastInteresting;

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    bIsThisView = YES;
    
    if (![NSString isNilOrEmpty:_lastInteresting ])
    {
        [txtView setText:_lastInteresting];
    }
    
    [self performSelector:@selector(txtViewBecomeFirstResponder) withObject:nil afterDelay:0.8];
}

- (void) txtViewBecomeFirstResponder
{
    [txtView becomeFirstResponder];
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
    self.title = LS_Text(@"Hobby");
    bIsThisView = NO;
    
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:LS_Text(@"back") target:self selector:@selector(cancel) ImageName:@""];
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.rightBarButtonItem = [[ObjectCTools shared] createRightBarButtonItem:LS_Text(@"Save") target:self selector:@selector(backtohome) ImageName:@""];
    
    isFirst = YES;
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)];
    txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 140 - (kIPhone4s ? 30 : 0))];
    txtView.layer.cornerRadius = 8;
//    [txtView becomeFirstResponder];
    txtView.layer.borderWidth = 1;
    txtView.returnKeyType = UIReturnKeyDone;
    txtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtView.font = kTextFontSize;
    txtView.delegate = self;
    txtView.text=self._lastInteresting;
    txtView.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.8f];
    txtView.autocorrectionType = UITextAutocorrectionTypeNo;
    [scroll addSubview:txtView];
    
    textNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 130, 100, 15)];
    textNumLabel.backgroundColor = [UIColor clearColor];
    textNumLabel.font = [UIFont systemFontOfSize:14];
    textNumLabel.textColor = [UIColor blackColor];
    if (self._lastInteresting.length > vMaxLenth)
    {
        textNumLabel.text = [NSString stringWithFormat:@"%d/%d",vMaxLenth, vMaxLenth];
    }
    else
    {
        textNumLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)txtView.text.length, vMaxLenth];
    }
    [scroll addSubview:textNumLabel];
    [self.view addSubview:scroll];
//    self.view.backgroundColor=kBackgroundColor;
    
}

-(void)backtohome
{
    if ([txtView.text length] > vMaxLenth)
    {
        // SHOWMBProgressHUD(@"输入内容长度过长，请重新设置", nil, nil, NO, 2.0);
        return;
    }
    
    if ([txtView.text isContainQuotationMark])
    {
        SHOWMBProgressHUD(LS_Text(@"Can't contain"), nil, nil, NO, 2);

        return;
    }
    
    [UserInfoHelp sharedInstance].userModel.interest = txtView.text;
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-
#pragma mark UITextViewDelegte

- (void)textViewDidChange:(UITextView *)textView {
    
    if (bIsThisView)
    {
        int length = (int)textView.text.length;
        if (length > vMaxLenth)
        {
            textNumLabel.text = [NSString stringWithFormat:@"%d/%d",vMaxLenth, vMaxLenth];
        }
        else
        {
            textNumLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length, vMaxLenth];
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if (textView.text.length > vMaxLenth) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, vMaxLenth)];
        }
        return NO;
    }
    if ([text isEqualToString:@""]) {
        return YES;
    }
    int MAX_CHARS = vMaxLenth;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textView.text];
    
    //    [newtxt replaceCharactersInRange:range withString:text];
    if (textView.text.length > vMaxLenth) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, vMaxLenth)];
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
    if (textField.text.length >= vMaxLenth) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, vMaxLenth)];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
