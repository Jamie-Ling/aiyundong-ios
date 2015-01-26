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
@property (nonatomic, strong) NSArray *leftArgus;
@property (nonatomic, assign) CGFloat currentBLVersion;

AS_SINGLETON(UserModelEntity)

/*
 rightArray:传入url链接的？后面字典部分的右边，即所有的value.
 个数要和leftArguments对应, 如果数据是空就传入@""或者0, 由数据类型决定
 requestType:请求类型
 */
- (void)userModelRequestWithRighArgus:(NSArray *)rightArray withRequestType:(UserModelEntityRequest)requestType;

@end
