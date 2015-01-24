//
//  ProvinceInfo.h
//  PAChat
//
//  Created by liu jacky on 13-11-16.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceInfo : NSObject {
    NSArray *_citys;
    NSString *_number;
    NSString *_state;
}
@property (nonatomic,strong)NSArray *citys;
@property (nonatomic,strong)NSString *number;
@property (nonatomic,strong)NSString *state;

@end
