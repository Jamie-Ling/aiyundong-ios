//
//  ZKKBaseObject.m
//  VPhone
//
//  Created by zorro on 14-10-24.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "ZKKBaseObject.h"

@implementation ZKKBaseObject

+(UIViewController *) topMostController {
    //Getting rootViewController
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //Getting topMost ViewController
    while (topController.presentedViewController)
        topController = topController.presentedViewController;
    
    //Returning topMost ViewController
    return topController;
}

static MBProgressHUD *HUD = nil;
+(void) hiddenMBProgressHUD{
    [HUD hide:YES];
}
+(MBProgressHUD *) MBProgressHUD{
    return HUD;
}
+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg image:(UIImage *)aImg dimBG:(BOOL)dimBG delay:(float)d{
    UIViewController *vc = [self topMostController];
    
    if (vc == nil) {
        return nil;
    }
    
    if (nil == HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    }
    
    [vc.view addSubview:HUD];
    
    
    if (aTitle || aMsg) {
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = aTitle;
        HUD.detailsLabelText = aMsg;
    }
    
    if (aImg)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:aImg];
        HUD.customView = img;
        HUD.mode = MBProgressHUDModeCustomView;
    }
    
    HUD.removeFromSuperViewOnHide = YES;
    HUD.dimBackground = NO;
    HUD.userInteractionEnabled = !dimBG;
    [HUD show:YES];
    
    if (d > 0) {
        [HUD hide:YES afterDelay:d];
    }
    
    return HUD;
}

+(MBProgressHUD *) showMBProgressHUDModeIndeterminateTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG{
    UIViewController *vc = [self topMostController];
    
    if (vc == nil) {
        return nil;
    }
    
    if (nil == HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    }
    [vc.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = aTitle;
    HUD.detailsLabelText = aMsg;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.dimBackground = dimBG;
    [HUD show:YES];
    
    return HUD;
}

+(MBProgressHUD *) showMBProgressHUDTitle:(NSString *)aTitle msg:(NSString *)aMsg dimBG:(BOOL)dimBG executeBlock:(void(^)(MBProgressHUD *hud))blockE finishBlock:(void(^)(void))blockF{
    UIViewController *vc = [self topMostController];
    
    if (vc == nil) {
        return nil;
    }
    
    if (nil == HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    }
    
    [vc.view addSubview:HUD];
    
    HUD.labelText = aTitle;
    HUD.detailsLabelText = aMsg;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.dimBackground = dimBG;
    [HUD showAnimated:YES whileExecutingBlock:^{
        blockE(HUD);
    } completionBlock:^{
        //[hud hide:YES];
        blockF();
    }];
    
    return HUD;
}

@end
