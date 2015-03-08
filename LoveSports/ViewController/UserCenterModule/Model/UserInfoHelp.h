//
//  UserInfoHelp.h
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface UserInfoHelp : NSObject

@property (nonatomic, strong) UserInfoModel *userModel;

AS_SINGLETON(UserInfoHelp)

@end
