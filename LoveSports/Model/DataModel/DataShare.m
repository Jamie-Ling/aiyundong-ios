//
//  DataShare.m
//  LoveSports
//
//  Created by zorro on 15/3/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DataShare.h"

@implementation DataShare

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _showCount = 8;
    }
    
    return self;
}

DEF_SINGLETON(DataShare)

@end
