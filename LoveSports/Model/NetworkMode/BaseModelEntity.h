//
//  BaseModelEntity.h
//  TalentOnline
//
//  Created by zorro on 14-4-8.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestHelper.h"
#import "Header.h"

@protocol EntityModelDelegate;

@interface BaseModelEntity : NSObject
{
   @public __unsafe_unretained id <EntityModelDelegate> _delegate;
}

AS_SINGLETON(BaseModelEntity)

@property (nonatomic, strong) NSMutableArray *data;                           // 数据
@property (nonatomic, assign) int tag;                                        // 编号
@property (nonatomic, assign) Class dataClass;                                // 数据类型
@property (nonatomic, assign) id <EntityModelDelegate> delegate;

@property (nonatomic, retain) RequestHelper *requestHelper;                   // 网络请求,需要自己初始化


- (void)showAlert:(NSString *)error withAdvice:(NSString *)advice;

// 获取服务器数据
- (void)refreshFromServerLimit:(NSString *)idString;

// 发送POST请求进行注册或者登陆.
- (void)sendPostRequestToServerWithArray:(NSArray *)array;

- (void)sortArray:(NSMutableArray *)array;

- (void)sortArrayOrderById:(NSMutableArray *)array;

// 对完整的文件路径进行判断,isDirectory 如果是文件夹返回YES, 如果不是返回NO.
- (BOOL)completePathDetermineIsThere:(NSString *)path;

// 删除文件夹和文件都可以用这个方法
- (void)removeFileName:(NSString *)file withFolderPath:(NSString *)path;

@end

#pragma mark - EntityModelDelegate
@protocol EntityModelDelegate <NSObject>

// 刷新
- (void)entityModelRefreshFromServerSucceed:(BaseModelEntity *)em withTag:(NSInteger)tag;
- (void)entityModelRefreshFromServerFailed:(BaseModelEntity *)em error:(NSError *)err withTag:(NSInteger)tag;


@end