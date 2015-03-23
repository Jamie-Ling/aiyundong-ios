//
//  NightVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NightVC.h"
#import "NightScrollView.h"

@interface NightVC ()

@property (nonatomic, strong) NightScrollView *scrollView;

@end

@implementation NightVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DEF_WEAKSELF_(NightVC);
    [BLTSimpleSend sharedInstance].backBlock = ^(NSDate *date){
        [weakSelf updateConnectForView];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [BLTSimpleSend sharedInstance].backBlock = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // self.view.layer.contents = (id)[UIImage imageNamed:@"background@2x.jpg"].CGImage;
    
    [self loadNightScrollView];
}

- (void)loadNightScrollView
{
    _scrollView = [[NightScrollView alloc] initWithFrame:self.view.bounds];
    
    [self addSubview:_scrollView];
    [self loadShareButton];
}

- (void)loadShareButton
{
    UIButton *calendarButton = [UIButton simpleWithRect:CGRectMake(self.width - 45, self.height - 99, 90/2.0, 70/2.0)
                                              withImage:@"分享@2x.png"
                                        withSelectImage:@"分享@2x.png"];
    
    [self addSubview:calendarButton];
}

#pragma mark --- 重写父类方法 ---
- (void)leftSwipe
{
    // [self updateContentForBarShowViewWithDate:[_currentDate dateAfterDay:1]];
}

- (void)rightSwipe
{
    // [self updateContentForBarShowViewWithDate:[_currentDate dateAfterDay:-1]];
}

- (void)updateConnectForView
{
 
}

@end
