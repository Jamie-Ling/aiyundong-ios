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

- (void)forgeFirmwareInformation
{
    _bltName = [NSString stringWithFormat:@"Device %d", arc4random() % 100];
    _bltID = @"sjdfkjsdfjskdfsdfsdfsdfsdf";
    _bltVersion = @"45";
    _bltElec = @"30";
    _bltRSSI = @"888";
}

@end
