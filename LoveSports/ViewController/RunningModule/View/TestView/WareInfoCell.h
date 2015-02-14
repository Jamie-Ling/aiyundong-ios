//
//  WareInfoCell.h
//  LoveSports
//
//  Created by zorro on 15-2-1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTModel.h"

@interface WareInfoCell : UITableViewCell

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rssiLabel;

@property (nonatomic, strong) UIView *lockView;
@property (nonatomic, strong) UIView *bltView;
@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) BLTModel *model;

- (void)updateContentForWareInfoCell:(BLTModel *)model withHeight:(CGFloat)height;

@end
