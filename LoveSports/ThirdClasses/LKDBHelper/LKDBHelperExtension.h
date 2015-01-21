//
//  LKDBHelperExtension.h
//  JoinShow
//
//  Created by Heaven on 13-10-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "LKDBHelper.h"
#import "NSObject+Property.h"

@interface NSObject(XY_LKDBHelper)

- (void)loadFromDB;

+ (NSString *)primaryKeyAndDESC;

@end

@interface NSArray(XY_LKDBHelper)

- (void)saveAllToDB;
+ (id)loadFromDBWithClass:(Class)modelClass;

@end
