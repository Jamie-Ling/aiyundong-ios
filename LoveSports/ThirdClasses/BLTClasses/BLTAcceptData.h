//
//  BLTAcceptData.h
//  LoveSports
//
//  Created by zorro on 15-1-27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BLTAcceptDataDelegate;

@interface BLTAcceptData : NSObject

@property (nonatomic, assign) id <BLTAcceptDataDelegate> delegate;

AS_SINGLETON(BLTAcceptData)

@end

@protocol BLTAcceptDataDelegate <NSObject>

- (void)acceptDataDelegateWith:(NSData *)data;

@end
