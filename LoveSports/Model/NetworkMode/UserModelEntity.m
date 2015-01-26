//
//  FileModelEntity.m
//  MultiMedia
//
//  Created by zorro on 14-12-5.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#import "UserModelEntity.h"

@implementation UserModelEntity

DEF_SINGLETON(UserModelEntity)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.requestHelper useCache];
        [self createLinkArray];
        [self loadVideoArray];
    }
    return self;
}

- (void)createLinkArray
{
}

- (void)loadVideoArray
{
    /*
    NSArray *array = @[@"https://twerkingbutt.files.wordpress.com/2014/12/lextwerkout_how_to_1_-_youtube.mp4",
                       @"https://twerkingbutt.files.wordpress.com/2014/12/lextwerkout_how_to_1_-_youtube.mp4",
                       @"https://twerkingbutt.files.wordpress.com/2014/12/lextwerkout_how_to_1_-_youtube.mp4",
                       @"https://twerkingbutt.files.wordpress.com/2014/12/lextwerkout_how_to_1_-_youtube.mp4",
                       @"https://twerkingbutt.files.wordpress.com/2014/12/lextwerkout_how_to_1_-_youtube.mp4"];
    
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 5; i++)
    {
        VideoInfoModel *model = [[VideoInfoModel alloc] init];
        
        model.downloadUrl = array[i];
        model.coverImage = @"Ac_Twerking_Video.jpg";
        model.serialNumber = [NSString stringWithFormat:@"%d", i];
        model.nameOfVideo = [NSString stringWithFormat:@"sample--%d", i];
        model.videoIntroduction = @"https://twerkingbutt.files.wordpress.com/2014/12/lextwerkout_how_to_1_-_youtube.mp4";
        
        [muArray addObject:model];
        [model saveToDB];
    }
    
    _videoArray = muArray;
    
    NSArray *getArray;
     */
    

}

- (void)userModelRequestWithBaseLink:(NSString *)link withRequestType:(UserModelEntityRequest)requestType
{
    [self.requestHelper emptyCache];
    
    HttpRequest *hr = [self.requestHelper get:link];

    [hr succeed:^(MKNetworkOperation *op) {
        NSString *str = [op responseString];
        NSLog(@"..%@",str);
        if (str)
        {
            [self saveData:str withRequestType:requestType];
            
            [self requestSuccessWithString:str withRequestType:requestType];
        }
    } failed:^(MKNetworkOperation *op, NSError *err) {
        
        [self requestFailWithString:nil withRequestType:requestType];
    }];
    
    [self.requestHelper submit:hr];
}

- (void)saveData:(NSString *)string withRequestType:(UserModelEntityRequest)requestType
{
   
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
