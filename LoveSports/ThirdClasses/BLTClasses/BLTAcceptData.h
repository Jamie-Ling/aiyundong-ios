//
//  BLTAcceptData.h
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

typedef enum {
    BLTAcceptDataTypeNoData = 0,
    BLTAcceptDataTypeBaseInfo = 1,
    BLTAcceptDataTypeLocTime = 2,
    BLTAcceptDataTypeUserInfo = 3,
    BLTAcceptDataTypeWareTime = 4,
    BLTAcceptDataTypeWareUserInfo = 5,
    BLTAcceptDataTypeWareScreenColor = 6
} BLTAcceptDataType;

#import <Foundation/Foundation.h>
#import "BLTManager.h"

@protocol BLTAcceptDataDelegate;

typedef void(^BLTAcceptDataUpdateValue)(id object, BLTAcceptDataType type);

@interface BLTAcceptData : NSObject

@property (nonatomic, assign) id <BLTAcceptDataDelegate> delegate;

@property (nonatomic, strong) NSString *wareTime;

@property (nonatomic, strong) BLTAcceptDataUpdateValue updateValue;
@property (nonatomic, assign) BLTAcceptDataType type;

AS_SINGLETON(BLTAcceptData)

@end

@protocol BLTAcceptDataDelegate <NSObject>

- (void)acceptDataDelegateWith:(NSData *)data;

@end
