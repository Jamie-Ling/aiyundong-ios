//
//  GraphicButton.h
//  LoveSports
//
//  Created by zorro on 15/3/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphicButton : UIButton

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSString *subTitle;

@end
