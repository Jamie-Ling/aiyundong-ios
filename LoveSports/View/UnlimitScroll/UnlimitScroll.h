//
//  UnlimitScroll.h
//  LoveSports
//
//  Created by zorro on 15/3/14.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UnlimitScrollDelegate;

@interface UnlimitScroll : UIView
typedef void (^UnlimitScrollUpdateViews)(UnlimitScroll *view, NSInteger index);
typedef BOOL (^UnlimitScrollAllowScroll)(UnlimitScroll *view, int index);

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSInteger (^totalPagesCount)(void);
@property (nonatomic, strong) NSArray *viewsArray;
@property (nonatomic, strong) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
@property (nonatomic, strong) void (^TapActionBlock)(NSInteger pageIndex);

@property (nonatomic, assign) id <UnlimitScrollDelegate> delegate;

@property (nonatomic, strong) UnlimitScrollUpdateViews updateBlock;
@property (nonatomic, strong) UnlimitScrollAllowScroll allowBlock;

// 限制是否在右边。
@property (nonatomic, assign) BOOL isRight;

@end

@protocol UnlimitScrollDelegate <NSObject>

- (void)unlimitScrollUpdateNewViewsArrayWithIndex:(NSInteger)index withDate:(NSDate *)date;

@end