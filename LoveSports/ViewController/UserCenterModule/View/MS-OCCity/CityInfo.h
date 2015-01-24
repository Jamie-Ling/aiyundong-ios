//
//  CityInfo.h
//  PAChat
//
//  Created by liu jacky on 13-11-16.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject {
    NSString *_city;
    NSString *_number;
    NSString *_stateID;
}
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *number;
@property (nonatomic,strong)NSString *stateID;

@end
