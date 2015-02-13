//
//  FileModelEntity.m
//  MultiMedia
//
//  Created by zorro on 14-12-5.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "UserModelEntity.h"
#import "Header.h"

@implementation UserModelEntity

DEF_SINGLETON(UserModelEntity)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.requestHelper useCache];
        [self createLinkArray];
    }
    return self;
}

- (void)createLinkArray
{
    _baseLink = @[@"/app_register", @"/app_logon",
                  @"/app_upload", @"/app_download",
                  @"/app_addnote", @"/app_foodnote"];
    
    _leftArgus = @[@[@"username", @"password", @"email", @"mobile"],
                   @[@"username", @"password"],
                   @[],
                   @[],
                   @[@"Username", @"Datetime", @"Picture", @"text"],
                   @[@"Username", @"Datetime"]];
}

- (void)userModelRequestWithRighArgus:(NSArray *)rightArray withRequestType:(UserModelEntityRequest)requestType
{
    [self.requestHelper emptyCache];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // 传入的右边的参数个数必须与初始化左边的参数个数相等
    for (int i = 0; i < rightArray.count; i++)
    {
        [dict setObject:[rightArray objectAtIndex:i] forKey:[_leftArgus[requestType] objectAtIndex:i]];
    }
    
    HttpRequest *hr = [self.requestHelper post:_baseLink[requestType] params:dict];

    [hr succeed:^(MKNetworkOperation *op) {
        NSString *str = [op responseString];
        NSLog(@"..%@",str);
        if (str)
        {
            [self saveData:str withRequestType:requestType];
        }
    } failed:^(MKNetworkOperation *op, NSError *err) {
        
        [self requestFailWithString:nil withRequestType:requestType];
    }];
    
    [self.requestHelper submit:hr];
}

- (void)saveData:(NSString *)string withRequestType:(UserModelEntityRequest)requestType
{
    switch (requestType)
    {
        case UserModelEntityRequestRegister:
        {
        
        }
            break;
        case UserModelEntityRequestLogin:
        {
            
        }
            break;
        case UserModelEntityRequestUpload:
        {
            
        }
            break;
        case UserModelEntityRequestDownload:
        {
            
        }
            break;
        case UserModelEntityRequestAddNote:
        {
            
        }
            break;
        case UserModelEntityRequestFoodnote:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)requestSuccessWithString:(NSString *)string withRequestType:(UserModelEntityRequest)requestType
{
    if (_delegate && [_delegate respondsToSelector:@selector(entityModelRefreshFromServerSucceed:withTag:)])
    {
        [_delegate entityModelRefreshFromServerSucceed:self withTag:UserModelEntity_Request_Tag + requestType];
    }
}

- (void)requestFailWithString:(NSString *)string withRequestType:(UserModelEntityRequest)requestType
{
   
}

#define FileModelEntity_Sort_Tag 9000
- (NSArray *)sortByNumberWithArray:(NSArray *)array withSEC:(BOOL)sec
{
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
    
    [muArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         if (sec)
         {
             return NSOrderedAscending;
         }
         else
         {
             return NSOrderedDescending;
         }
     }];
    
    return muArray;
}

@end
