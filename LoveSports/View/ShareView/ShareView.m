//
//  ShareView.m
//  LoveSports
//
//  Created by zorro on 15/3/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShareView.h"

@interface ShareView () <SphereMenuDelegate>

@end

@implementation ShareView

DEF_SINGLETON(ShareView)

- (SphereMenu *)simpleWithPoint:(CGPoint)point
{
    NSArray *images = @[UIImageNamed(@"icon-twitter"), UIImageNamed(@"icon-email"), UIImageNamed(@"icon-facebook")];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:point
                                                         startImage:UIImageNamed(@"分享@2x.png")
                                                      submenuImages:images];
    sphereMenu.sphereDamping = 0.3;
    sphereMenu.sphereLength = 120;
    sphereMenu.delegate = self;
    
    return sphereMenu;
}

- (void)sphereDidSelected:(int)index
{
    // 在这里弹出分享.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

@end
