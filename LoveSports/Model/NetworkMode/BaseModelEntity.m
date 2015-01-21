//
//  NewsModelEntity.m
//  TalentOnline
//
//  Created by zorro on 14-4-8.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "BaseModelEntity.h"

@implementation BaseModelEntity

- (id)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] initWithCapacity:64];
        self.requestHelper = [[RequestHelper alloc] initWithHostName:@"s3-us-west-1.amazonaws.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
      //  [self.requestHelper emptyCache];
        
        self.requestHelper.freezable = NO;
        self.requestHelper.forceReload = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [_data removeAllObjects];
    _delegate = nil;
    
    [self.requestHelper cancelAllOperations];
    self.requestHelper = nil;
}

DEF_SINGLETON(BaseModelEntity)

- (void)showAlert:(NSString *)error withAdvice:(NSString *)advice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:advice delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

// net
// 刷新
-(void) refreshFromServerLimit:(NSString *)idString
{
 
}

- (void)sortArray:(NSMutableArray *)array
{
}

- (void)sendPostRequestToServerWithArray:(NSArray *)array
{
    
}

- (void)sortArrayOrderById:(NSMutableArray *)array
{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         
         if (1 > 0)
         {
             return NSOrderedAscending;
         }
         else
         {
             return NSOrderedDescending;
         }
     }];
}

// 对完整的文件路径进行判断,isDirectory 如果是文件夹返回YES, 如果不是返回NO.
- (BOOL)completePathDetermineIsThere:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:path];
    
    return existed;
}

// 删除文件夹和文件都可以用这个方法
- (void)removeFileName:(NSString *)file withFolderPath:(NSString *)path
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:filePath error:nil];
}

@end
