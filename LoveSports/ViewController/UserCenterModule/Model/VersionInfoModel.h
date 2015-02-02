//
//  VersionInfoModel.h
//  LoveSports
//
//  Created by jamie on 15/2/2.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionInfoModel : NSObject

@property (nonatomic, strong) NSString *_versionID;  //版本号
@property (nonatomic, strong) NSString *_versionUpdatInfo;    //更新信息
@property (nonatomic, strong) NSString *_versionSize; //版本大小

@end
