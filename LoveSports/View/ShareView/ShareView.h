//
//  ShareView.h
//  LoveSports
//
//  Created by zorro on 15/3/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SphereMenu.h"

@interface ShareView : NSObject

AS_SINGLETON(ShareView)

- (SphereMenu *)simpleWithPoint:(CGPoint)point;

@end
