//
//  MSCustomWebViewController.h
//  CivicHero
//
//  Created by jamie on 14-11-10.
//  Copyright (c) 2014年 Missionsky-Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCustomWebView.h"

@interface MSCustomWebViewController : UIViewController<UIWebViewDelegate>
{
    MSCustomWebView     *webView;    //web页面视图
    NSString            *loadURL;
    NSString            *oldUrl;
    NSString            *newUrl;
    NSTimer             *timeOut;

//    NSString            *jidString;
//    NSString            *serviceName;
    BOOL                 goBack;
    BOOL                firstComing;
}
- (void)backToPrePage;                     //点击返回按钮
- (void)loadURL:(NSURL *)URLString;
- (void)setNavTitle:(NSString *)title;

@property (nonatomic,retain) NSString           *jidString;
@property (nonatomic,retain) NSString           *serviceName;
@property (nonatomic,retain) NSString           *loadURL;

@end
