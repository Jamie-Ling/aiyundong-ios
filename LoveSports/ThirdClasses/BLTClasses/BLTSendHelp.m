//
//  BLTSendHelp.m
//  LoveSports
//
//  Created by zorro on 15/3/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendHelp.h"

@implementation BLTSendHelp

+ (void)sendSetUserInfo:(BLTSendHelpSimpleBlock)block
{
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
        // 设置用户信息.
        //[[BLTSimpleSend sharedInstance]
    }
    else
    {
    
    }
}

+ (void)sendSetPedInfo:(BLTSendHelpSimpleBlock)block
{
    if ([BLTManager sharedInstance].model.isNewDevice)
    {
       // 设置手环信息.
    }
    else
    {
        
    }
}

@end
