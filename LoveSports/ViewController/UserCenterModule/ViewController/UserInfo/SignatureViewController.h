//
//  SignatureViewController.h
//  PAChat
//
//  Created by Coson on 13-9-16.
//  Copyright (c) 2013年 FreeDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSString *signatureString;

@property (nonatomic,assign)BOOL isBubbleChatCtl;

@end
