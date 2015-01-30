//
//  TargetViewController.m
//  LoveSports
//
//  Created by jamie on 15/1/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define vOneCellHeight    (kIPhone4s ? 44 : 45.0) //cell单行高度
#define vDistanceSide   10   // 距离边缘宽度

#define vChoiceBackGroundColor  kRGBAlpha(237, 147, 102, 0.2)

#define vUITag_AnswerItem     0x15

#import "TargetViewController.h"
#import "PAGameAnswerItem.h"

@interface TargetViewController ()<PAGameAnswerItemDelegate>
{
    NSArray *_titleArray;
}

@end

@implementation TargetViewController
@synthesize _thisModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"每日目标";
    self.view.backgroundColor = kBackgroundColor;   //设置通用背景颜色
    self.navigationItem.leftBarButtonItem = [[ObjectCTools shared] createLeftBarButtonItem:@"返回" target:self selector:@selector(goBackPrePage) ImageName:@""];
    
    _titleArray = [NSArray arrayWithObjects:@"步数  10000步", @"卡路里  3500大卡", @"距离  5.8千米", nil];

    [self addChoices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //将要消失时更新存储
    [[BraceletInfoModel getUsingLKDBHelper] insertToDB:_thisModel];
}

#pragma mark ---------------- 页面布局 -----------------
- (void) addChoices
{
    UIView *pCustomView = [[UIView alloc] init];
    [pCustomView setBackgroundColor:vChoiceBackGroundColor];
    [pCustomView.layer setBorderColor:vChoiceBackGroundColor.CGColor];
    [pCustomView.layer setBorderWidth:1];
    [pCustomView.layer setCornerRadius:8];
    [pCustomView setFrame:CGRectMake(vDistanceSide, vDistanceSide, self.view.width - vDistanceSide * 2.0, vDistanceSide * 2 + 4 * 20)];
    [self.view addSubview:pCustomView];
    
    for (int i = 0 ; i < 3; i++)
    {
        CGFloat fX = vDistanceSide;
        CGFloat fY = vDistanceSide;
        
        //label
        CGRect titleFrame = CGRectMake(fX + 25 + 3, fY + i * 32 , self.view.width - fX, 20);
        UILabel *title = [[ObjectCTools shared] getACustomLableFrame:titleFrame
                                                     backgroundColor:[UIColor clearColor]
                                                                text:[_titleArray objectAtIndex:i]
                                                           textColor:kLabelTitleDefaultColor
                                                                font:[UIFont boldSystemFontOfSize:14]
                                                       textAlignment:NSTextAlignmentLeft
                                                       lineBreakMode:0
                                                       numberOfLines:0];
        [pCustomView addSubview:title];
        

        PAGameAnswerItem *pItem = [[PAGameAnswerItem alloc] initWithFrame:titleFrame];
        [pItem setX:fX];
        [pItem setWidth:self.view.width - fX];
        [pItem setTag:vUITag_AnswerItem + i];
        [pItem setAlpha:1.0];
        [pItem setDelegate:self];
        [pCustomView addSubview:pItem];
    }

    NSInteger choice = [_thisModel._target integerValue];
    
    PAGameAnswerItem *pItem = (PAGameAnswerItem *)[self.view viewWithTag:vUITag_AnswerItem + choice];
    [pItem setSelectButtonImage:@"game_button_select_Highlighted.png"];
}

#pragma mark ---------------- User-choice -----------------
//返回上一页
- (void) goBackPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------------- PAGameAnswerItemDelegate -----------------
- (void)PAGameAnswerItem:(PAGameAnswerItem *)item selectIndex:(NSInteger)index
{
    [self resetButtonImage];
    [item setSelectButtonImage:@"game_button_select_Highlighted.png"];
    
    _thisModel._target = [NSString stringWithFormat:@"%ld", (long)index];
}

- (void)resetButtonImage
{
    for (int i = 0; i < 3; i++)
    {
        PAGameAnswerItem *pItem = (PAGameAnswerItem *)[self.view viewWithTag:vUITag_AnswerItem + i];
        [pItem setSelectButtonImage:@"game_button_select_Normal.png"];
    }
}

@end
