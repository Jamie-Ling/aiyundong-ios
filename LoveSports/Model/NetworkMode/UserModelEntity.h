//
//  FileModelEntity.h
//  MultiMedia
//
//  Created by zorro on 14-12-5.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#define UserModelEntity_Request_Tag 1000
#import "BaseModelEntity.h"

typedef enum {
    UserModelEntityRequestRegister = 0,
    UserModelEntityRequestLogin = 1,
    UserModelEntityRequestUpload = 2,
    UserModelEntityRequestDownload = 3,
    UserModelEntityRequestAddNote = 4,
    UserModelEntityRequestFoodnote = 5
} UserModelEntityRequest;

@interface UserModelEntity : BaseModelEntity

@property (nonatomic, strong) NSArray *baseLink;
@property (nonatomic, assign) CGFloat currentBLVersion;

AS_SINGLETON(UserModelEntity)

- (void)userModelRequestWithBaseLink:(NSString *)link withRequestType:(UserModelEntityRequest)requestType;

@end
