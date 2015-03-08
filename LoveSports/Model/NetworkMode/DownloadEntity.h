//
//  DownloadEntity.h
//  MultiMedia
//
//  Created by zorro on 15-1-5.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define DownLoadEntity_UpdateZip @"http://lovesports.qiniudn.com/update.zip"

#import "BaseModelEntity.h"

typedef enum {
    DownloadEntityRequestOthers = 0,
    DownloadEntityRequestUpgradePatch = 1
} DownloadEntityRequest;

@interface DownloadEntity : BaseModelEntity

@property (nonatomic, strong) DownloadHelper *downloadEngine;
@property (nonatomic, strong) NSArray *pathArray;

@property (nonatomic, assign) NSInteger coverAnimationMark;
@property (nonatomic, assign) NSInteger upgradePatchMark;

AS_SINGLETON(DownloadEntity)
- (void)downloadFileWithWebsite:(NSString *)website withRequestType:(DownloadEntityRequest)requestType;

@end
