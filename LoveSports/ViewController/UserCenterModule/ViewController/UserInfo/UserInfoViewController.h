//
//  UserInfoViewController.h
//  Woyoli
//
//  Created by jamie on 14-12-2.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//  个人信息

#define vHeightMin(a)    (a ? 60 : 24)
#define vHeightMax(a)   (a ? 220 : 87)

#define vWeightMin(a)   (a ? 20 : 44)
#define vWeightMax(a)   (a ? 297 : 654)

#define vStepLongMin(a)   (a ? 30 : 12)
#define vStepLongMax(a)   (a ? 120 : 47)

#import <UIKit/UIKit.h>
#import "BraceletInfoModel.h"

@interface UserInfoViewController : UIViewController

@property (nonatomic, weak) BraceletInfoModel *_thisModel;

@end
