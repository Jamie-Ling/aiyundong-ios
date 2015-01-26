//
//  BLTModel.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTModel.h"

@implementation BLTModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _bltName = @"";
        _bltID = @"";
        _bltVersion = @"";
        _bltElec = @"";
        _bltRSSI = @"";
    }
    
    return self;
}

@end
