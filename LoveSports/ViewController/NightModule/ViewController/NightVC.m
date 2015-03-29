//
//  NightVC.m
//  LoveSports
//
//  Created by zorro on 15-1-21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NightVC.h"
#import "NightScrollView.h"
#import "ShareView.h"

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
    
    self.view.backgroundColor = [UIColor clearColor];
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
    SphereMenu *sphereMenu = [[ShareView sharedInstance] simpleWithPoint:CGPointMake(self.width - 22.5, self.height - 86)];
    [self addSubview:sphereMenu];
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
