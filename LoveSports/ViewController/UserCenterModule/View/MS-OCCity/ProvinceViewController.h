//
//  ProvinceViewController.h
//  PAChat
//
//  Created by liu jacky on 13-11-8.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityViewController.h"
#import "UserInfoViewController.h"
//#import "NSObject+SBJson.h"
#import "ProvinceInfo.h"

@class UserInfoViewController;

@interface ProvinceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    UserInfoViewController *_setUserInfoViewCtl;
    UITableView *_tableView;
    NSMutableArray *_provinceArray;
}
@property (nonatomic,retain)UserInfoViewController *setUserInfoViewCtl;

@end
