//
//  UpdateBraceletNameViewController.h
//  LoveSports
//
//  Created by jamie on 15/1/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BraceletInfoModel.h"

@interface UpdateBraceletNameViewController : UIViewController

@property (nonatomic, strong) NSString *_lastNickName;
@property (nonatomic, weak) BraceletInfoModel *_thisModel;

@end
