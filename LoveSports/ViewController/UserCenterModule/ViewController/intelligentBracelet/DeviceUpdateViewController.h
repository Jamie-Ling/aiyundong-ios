//
//  DeviceUpdateViewController.h
//  LoveSports
//
//  Created by jamie on 15/2/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "MSCustomWebViewController.h"
#import "BraceletInfoModel.h"
#import "VersionInfoModel.h"

@interface DeviceUpdateViewController : MSCustomWebViewController
@property (nonatomic, strong) VersionInfoModel *_thisVersionInfoModel;
@property (nonatomic, weak) BraceletInfoModel *_thisBraceletInfoModel;

@end
