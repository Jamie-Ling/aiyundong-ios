//
//  PAGameAnswerItem.h
//  PAChat
//
//  Created by Chen Jacky on 14-1-2.
//  Copyright (c) 2014年 FreeDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAGameAnswerItem;

@protocol PAGameAnswerItemDelegate <NSObject>
@optional
- (void)PAGameAnswerItem:(PAGameAnswerItem *)item selectIndex:(NSInteger)index;
@end

@interface PAGameAnswerItem : UIButton
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSString *score;

- (void)setSelectButtonImage:(NSString *)imageName;
- (void)refresh;

@end
