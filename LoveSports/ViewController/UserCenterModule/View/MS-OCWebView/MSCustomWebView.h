//
//  MSCustomWebView.h
//  CivicHero
//
//  Created by jamie on 14-11-10.
//  Copyright (c) 2014年 Missionsky-Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCustomWebView : UIWebView
{
    NSTimer *timer;               //加载timeout计时器
    int      LoadCount;           //加载次数计数
}
@property (nonatomic, copy)     NSString    *lastLoadURLString;  // 上一次加载的网址
@property (nonatomic, assign)   int          LoadCount;
@property (nonatomic, assign)   BOOL         loadFailed;

- (void)showLoadingAnimationAjax;	// WebView Ajax引起的加载动画
- (void)hideLoadingAnimationAjax;	// WebView Ajax引起的隐藏动画
- (void)clearContent;               // 清除页面
- (void)loadErrorPage;              // 加载发生载入错误时的网页
- (void)loadLastPage;               // 加载上一次的网址

@end

