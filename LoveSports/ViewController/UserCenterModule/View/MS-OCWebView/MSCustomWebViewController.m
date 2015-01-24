//
//  MSCustomWebViewController.m
//  CivicHero
//
//  Created by jamie on 14-11-10.
//  Copyright (c) 2014年 Missionsky-Mobile. All rights reserved.
//

#import "MSCustomWebViewController.h"
#import "ObjectCTools.h"
#import "MBProgressHUD.h"

@interface MSCustomWebViewController ()

@end

@implementation MSCustomWebViewController

@synthesize loadURL;
@synthesize jidString;
@synthesize serviceName;


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
        //        serviceName = name;
        goBack = NO;
        oldUrl = nil;
        newUrl = nil;
        
        if (kIOSVersions >= 7.0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            webView = [[MSCustomWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kIOS7OffHeight)];
        }else{
            webView = [[MSCustomWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 - 44)];
        }
        webView.delegate = self;
        webView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.view addSubview:webView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = kNavigationBarColor;
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.hidesBackButton = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setNavTitle:(NSString*)title
{
    self.title = title;
}


-(void)networkNotConnected
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接失败，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


- (void)loadURL:(NSURL *)URLString
{
    firstComing = true;
    if (webView.loading)
    {
        [webView stopLoading];
    }
    [webView clearContent];
    webView.loadFailed = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:URLString]];
}

-(void)timeOut
{
    NSLog(@"timeOut");
    [self removeTimerAndProgress];
    //    if (webView.loading)
    //    {
    //        [webView stopLoading];
    //    }
    //    [webView clearContent];
}

-(void)backToPrePage {
    if (webView.loadFailed) {
        NSLog(@"backToPrePage loadFailed");
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (goBack) {
            NSLog(@"backToPrePage  goback");
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:oldUrl]]];
            goBack = NO;
        } else {
            NSLog(@"backToPrePage !goback");
            NSLog(@"返回层次太多或者为第一页，直接返回原生页面,或者调用网页已经实现的js");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)removeTimerAndProgress{
    if ([timeOut isValid])
    {
        [timeOut invalidate];
        timeOut = nil;
    }
    UIWindow *pWindow = [(UIWindow*)[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideHUDForView:pWindow animated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"----------------------------the url:%@", requestString);
    newUrl = requestString;
    if(oldUrl == nil){
        oldUrl = [requestString mutableCopy];
    }else{
        //如果新页面地址和现在的不一样，就可以返回上层网页
        if ([requestString hasPrefix:@"http://"] || [requestString hasPrefix:@"https://"]) {
            if ([self compareDomain:newUrl second:oldUrl]) {
                goBack = NO;
            }else{
                goBack = YES;
            };
        }
    }
    return true;
}

-(BOOL)compareDomain:(NSString *)url1 second:(NSString *)url2{
    NSString *str1 = url1;
    NSString *str2 = url2;
    NSArray *arr1 = [str1 componentsSeparatedByString:@"/"];
    NSString *domain1 = [arr1 objectAtIndex:2];
    NSArray *arr2 = [str2 componentsSeparatedByString:@"/"];
    NSString *domain2 = [arr2 objectAtIndex:2];
    if ([domain1 isEqualToString:domain2]) {
        return YES;
    }
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    webView.loadFailed = NO;
    NSString *urlStr = theWebView.request.URL.absoluteString;
    NSLog(@"webViewDidStartLoad  %@", urlStr);
    
    if ([timeOut isValid])
    {
        [timeOut invalidate];
        timeOut = nil;
    }
    timeOut = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    if(firstComing)
    {
        NSLog(@"只在第一次进来web时显示加载框");
        UIWindow *pWindow = [(UIWindow*)[UIApplication sharedApplication].delegate window];
//        [MBProgressHUD showHUDAddedTo:pWindow animated:YES withMessage:@"正在加载，请稍候"];
        [MBProgressHUD showHUDAddedTo:pWindow animated:YES];
        firstComing = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSLog(@"webViewDidFinishLoad");
    [self removeTimerAndProgress];
}

- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError  %@", [error localizedDescription]);
    [self removeTimerAndProgress];
    webView.loadFailed = YES;
    
    if ([error code] == -999)
    {
        return;
    }
    
    if ([[[error userInfo] objectForKey:@"NSErrorFailingURLStringKey"] hasPrefix:@"tel:"]) {
        return;
    }
    NSLog(@"加载失败，有异常，请检查网络，此处根据页面稳定性看是否需要提示框");
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请查看您的网络是否正常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)dealloc
{
    if ([timeOut isValid])
    {
        [timeOut invalidate];
        timeOut = nil;
    }
    webView.delegate = nil;
    webView = nil;
}


@end
