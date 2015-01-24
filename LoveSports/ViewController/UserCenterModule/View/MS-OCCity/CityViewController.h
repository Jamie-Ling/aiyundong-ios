//
//  CityViewController.h
//  PAChat
//
//  Created by liu jacky on 13-11-8.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"
#import "CityInfo.h"
@class SetUserInfoViewController;

@interface CityViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UserInfoViewController *_setUserInfoViewCtl;
    UITableView *_tableView;
    NSMutableArray *_cityArray;
}
@property (nonatomic,copy)NSArray *cityArray;
@property (nonatomic,retain)UserInfoViewController *setUserInfoViewCtl;

@end
