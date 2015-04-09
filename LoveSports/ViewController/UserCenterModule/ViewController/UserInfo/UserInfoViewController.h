//
//  UserInfoViewController.h
//  Woyoli
//
//  Created by jamie on 14-12-2.
//  Copyright (c) 2014年 Missionsky. All rights reserved.
//  个人信息

#define vHeightMin(a)    (a ? 60 : 3.0)
#define vHeightMax(a)   (a ? 220 : 9.0)

#define vWeightMin(a)   (a ? 20 : 44)
#define vWeightMax(a)   (a ? 297 : 654)

#define vStepLongMin(a)   (a ? 30 : 1.0)
#define vStepLongMax(a)   (a ? 120 : 5.0)

#define vChangeToFT(A)  ((A / 30.48) + 1)   //CM - >转换为英尺
#define vChangeToLB(A)  (A * 2.2046226)  //KG - >转换为磅

#define vChangeToMI(A)  (A * 0.6213712)  //千米- 》英里


#define vBackToCM(A)  ((A - 1) * 30.48)   //英尺 - > cm
#define vBackToKG(A)  (A / 2.2046226)  //磅 - > kg

#import <UIKit/UIKit.h>
#import "BraceletInfoModel.h"

@interface UserInfoViewController : UIViewController

@property (nonatomic, weak) BraceletInfoModel *_thisModel;

@end
