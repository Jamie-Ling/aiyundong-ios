//
//  UserInfoHelp.m
//  LoveSports
//
//  Created by zorro on 15/3/8.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoHelp.h"

@implementation UserInfoHelp

DEF_SINGLETON(UserInfoHelp)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _userModel = [[UserInfoModel alloc] init];
    }
    
    return self;
}

@end
