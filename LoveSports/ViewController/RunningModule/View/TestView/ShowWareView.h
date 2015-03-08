//
//  ShowWareView.h
//  LoveSports
//
//  Created by zorro on 15-1-28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTModel.h"
@protocol ShowWareViewDelegate;

@interface ShowWareView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, assign) BOOL isShowAll;

@property (nonatomic, assign) id <ShowWareViewDelegate> delegate;

@end

@protocol ShowWareViewDelegate <NSObject>

- (void)showWareViewSelectHardware:(ShowWareView *)wareView withModel:(BLTModel *)model;

@end