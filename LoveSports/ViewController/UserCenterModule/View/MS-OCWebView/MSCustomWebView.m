//
//  MSCustomWebView.m
//  CivicHero
//
//  Created by jamie on 14-11-10.
//  Copyright (c) 2014年 Missionsky-Mobile. All rights reserved.
//

#define	LOADING_TIMEOUT	 120 // Loading动画超时时间，单位：秒

#import "MSCustomWebView.h"

@implementation MSCustomWebView
@synthesize lastLoadURLString;
@synthesize loadFailed,LoadCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        for (id view in self.subviews)
        {
            if ([[view class] isSubclassOfClass:[UIScrollView class]])
                ((UIScrollView *)view).bounces = YES;
        }
        self.scalesPageToFit = YES;
    }
    return self;
}

- (void)showLoadingAnimationAjax
{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:LOADING_TIMEOUT target:self selector:@selector(timerTimeoutAjax) userInfo:nil repeats:NO];
}

- (void)timerTimeoutAjax
{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    [self hideLoadingAnimationAjax];
}

- (void)hideLoadingAnimationAjax
{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)clearContent
{
    [self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML='';"];
}

- (void)loadErrorPage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"failLoadPage" ofType:@"html"];
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)loadLastPage
{
    if (lastLoadURLString) {
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lastLoadURLString]]];
        loadFailed = NO;
    }
}

- (void)dealloc
{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
//    [lastLoadURLString release];
//    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
