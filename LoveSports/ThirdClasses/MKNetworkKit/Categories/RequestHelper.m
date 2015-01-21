//
//  XYNetWorkEngine.m
//  JoinShow
//
//  Created by Heaven on 13-9-7.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

/*
 MKNetworkEngine是一个假单例的类，负责管理你的app的网络队列。因此，简单的请求时，你应该直接使用MKNetworkEngine的方法。在更为复杂的定制中，你应该集成并子类化它。每一个MKNetworkEngine的子类都有他自己的Reachability对象来通知服务器的连通情况。你应该考虑为你的每一个特别的REST服务器请求子类化MKNetworkEngine。因为是假单例模式，每一个单独的子类的请求，都会通过仅有的队列发送。
 
 
 重写 MKNetworkEngin的一些方法时,需要调用 -(void) registerOperationSubclass:(Class) aClass;
 
 改变提交的数据类型需要设置postDataEncoding
 */

#import "RequestHelper.h"

@interface RequestHelper()

@end

@implementation RequestHelper

+(id) defaultSettings{
    // 参考
    RequestHelper *eg = [[RequestHelper alloc] initWithHostName:@"www.webxml.com.cn" customHeaderFields:@{@"x-client-identifier" : @"iOS"}];
    
    eg.freezable = YES;
    eg.forceReload = YES;
    
    return eg;
}

// [super initWithHostName:@"www.apple.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}]
- (id)init
{
    if (self = [super init])
    {
        _freezable = YES;
        _forceReload = YES;
    }
    
    return self;
}

- (HttpRequest *)get:(NSString *)path
{
    return [self get:path params:nil];
}

- (HttpRequest *)get:(NSString *)path params:(id)anObject
{
    return [self request:path params:anObject method:requestHelper_get];
}

- (HttpRequest *)post:(NSString *)path params:(id)anObject
{
    return [self request:path params:anObject method:requestHelper_post];
}

// anObejct 必须是字典
- (HttpRequest *)request:(NSString *)path params:(id)anObject method:(HTTPMethod)httpMethod
{
    
    NSString *strHttpMethod = nil;
    
    if (httpMethod == requestHelper_get)
    {
        strHttpMethod = @"GET";
    }
    else if (httpMethod == requestHelper_post)
    {
        strHttpMethod = @"POST";
    }
    else if (httpMethod == requestHelper_put)
    {
        strHttpMethod = @"PUT";
    }
    else if (httpMethod == requestHelper_del)
    {
        strHttpMethod = @"DELETE";
    }
    
    if (strHttpMethod == nil)
    {
        return nil;
    }
    
    NSDictionary *dic = nil;
    
    if (anObject)
    {
        if ([anObject isKindOfClass:[NSDictionary class]])
        {
            dic = anObject;
        }
        else
        {
           // dic = [anObject YYJSONDictionary];
        }
    }

    HttpRequest *tempOp = [self operationWithPath:path params:dic httpMethod:strHttpMethod];
    
    return tempOp;
}

- (void)cancelRequestWithString:(NSString*)string
{
    [RequestHelper cancelOperationsContainingURLString:string];
}


#pragma mark- Image
+ (void)webImageSetup
{
    [UIImageView setDefaultEngine:[[MKNetworkEngine alloc] init]];
}

+(id) webImageEngine{
    static dispatch_once_t once;
    static MKNetworkEngine * __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

- (id)submit:(HttpRequest *)op
{
    if (op != nil)
    {
        if ([op.HTTPMethod isEqualToString:@"GET"])
        {
            [self enqueueOperation:op forceReload:self.forceReload];
        }
        else
        {
            [self enqueueOperation:op forceReload:NO];
        }
    }
    
    return self;
}

@end

#pragma mark -  MKNetworkOperation (XY)
@implementation MKNetworkOperation (XY)

// if forceReload == YES, 先读缓存,然后发请求,blockS响应2次, 只支持GET
- (id)submitInQueue:(RequestHelper *)requests
{
    // 非下载请求
    [requests enqueueOperation:self forceReload:NO];
    return self;
}

- (id)uploadFiles:(NSDictionary *)name_path
{
    if (name_path)
    {
        [name_path enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            [self addFile:obj forKey:key];
        }];
    }
    
    return self;
}

- (id)succeed:(void (^)(HttpRequest *op))blockS failed:(void (^)(HttpRequest *op, NSError* err))blockF
{
    [self addCompletionHandler:blockS errorHandler:blockF];
    
    return self;
}

@end

#pragma mark -  Downloader
@interface Downloader()
@property (nonatomic, copy) NSString *tempFilePath;
@property (nonatomic, assign) DownloadHelper *downloadHelper;

@end

@interface DownloadHelper()
@property (nonatomic, retain) NSMutableArray *downloadArray;

@end

@implementation Downloader

/*
-(void) setDownloadHelper:(DownloadHelper *)downloadHelper{
    _downloadHelper = downloadHelper;
}
*/

- (id)submitInQueue:(DownloadHelper *)requests
{
    NSString *str = self.toFile;
    
    if (str && [requests isKindOfClass:[DownloadHelper class]])
    {
        // 下载请求
        [requests enqueueOperation:self];
        [((DownloadHelper *)requests).downloadArray addObject:self];
    }
    else if (str == nil)
    {
        // 非下载请求
    }
    
    return self;
}

-(id) progress:(void(^)(double progress))blockP
{
    [self onDownloadProgressChanged:^(double progress)
    {
        if (blockP) blockP(progress);
    }];
    
    return self;
}

-(id) succeed:(void (^)(HttpRequest *op))blockS failed:(void (^)(HttpRequest *op, NSError* err))blockF
{
    __weak Downloader *safeSelf = self;
    
    [self addCompletionHandler:^(HttpRequest *operation)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        NSString *filePath = safeSelf.toFile;
        
        // 下载完成以后 先删除之前的文件 然后mv新的文件
        if ([fileManager fileExistsAtPath:filePath])
        {
            [fileManager removeItemAtPath:filePath error:&error];
            
            if (error)
            {
                exit(-1);
            }
        }
        
        [fileManager moveItemAtPath:safeSelf.tempFilePath toPath:filePath error:&error];
         
        if (error)
        {
            exit(-1);
        }
        
        if (blockS)
        {
            blockS(operation);
        }
         
        [safeSelf.downloadHelper.downloadArray removeObject:safeSelf];
        
    } errorHandler:^(HttpRequest *errorOp, NSError *err)
    {
        if (blockF)
        {
            blockF(errorOp, err);
        }
    }];
    
    return self;
}

@end

#pragma mark - DownloadHelper
@implementation DownloadHelper

+ (id)defaultSettings
{
    // 参考
    DownloadHelper *eg = [[DownloadHelper alloc] initWithHostName:nil];
    [eg setup];
    
    return eg;
}

- (void)setup
{
    [self registerOperationSubclass:[Downloader class]];
    
    if (self.downloadArray == nil)
    {
        self.downloadArray = [NSMutableArray arrayWithCapacity:8];
    }
}

- (Downloader *)downLoad:(NSString *)remoteURL to:(NSString*)filePath params:(id)anObject breakpointResume:(BOOL)isResume
{
    if (self.downloadArray == nil)
    {
        return nil;
    }
    
    // 获得临时文件的路径
    NSString *tempDoucment = NSTemporaryDirectory();
    NSString *tempFilePath = [tempDoucment stringByAppendingPathComponent:@"tempdownload"];
    
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:tempFilePath isDirectory:NULL])
    {
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:tempFilePath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:nil];
        
        if ( NO == ret )
        {
            NSLog(@"%s, create %@ failed", __PRETTY_FUNCTION__, tempFilePath);
            return nil;
        }
    }
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSRange lastCharRange = [filePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    tempFilePath = [NSString stringWithFormat:@"%@/%@.temp", tempFilePath, [filePath substringFromIndex:lastCharRange.location + 1]];
    
    // 获得临时文件的路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *newHeadersDict = [[NSMutableDictionary alloc] init];
    
    // 如果是重新下载，就要删除之前下载过的文件
    if (!isResume && [fileManager fileExistsAtPath:tempFilePath])
    {
        NSError *error = nil;
        [fileManager removeItemAtPath:tempFilePath error:&error];
        
        if (error)
        {
            NSLog(@"%@ file remove failed!\nError:%@", tempFilePath, error);
        }
        
    }
    else if(!isResume && [fileManager fileExistsAtPath:filePath])
    {
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        
        if (error)
        {
            NSLog(@"%@ file remove failed!\nError:%@", filePath, error);
        }
    }
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        return nil;
    }
    else
    {
        
        NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleNameKey],
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleVersionKey]];
                                    [newHeadersDict setObject:userAgentString forKey:@"User-Agent"];
        
        // 判断之前是否下载过 如果有下载重新构造Header
        if (isResume && [fileManager fileExistsAtPath:tempFilePath])
        {
            NSError *error = nil;
            unsigned long long fileSize = [[fileManager attributesOfItemAtPath:tempFilePath
                                                                         error:&error] fileSize];
            if (error)
            {
                NSLog(@"get %@ fileSize failed!\nError:%@", tempFilePath, error);
            }
            
            NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
            [newHeadersDict setObject:headerRange forKey:@"Range"];
        }
        
        NSDictionary *dic = nil;
        
        if (anObject)
        {
            if ([anObject isKindOfClass:[NSDictionary class]])
            {
                dic = anObject;
            }
            else
            {
               // dic = [anObject YYJSONDictionary];
            }
        }
        
        Downloader *op = (Downloader *)[self operationWithURLString:remoteURL params:dic];
        op.downloadHelper = self;
        [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES]];
        [op addHeaders:newHeadersDict];
        
        op.toFile = filePath;
        op.tempFilePath = tempFilePath;
        
        // 如果已经存在下载文件 operation返回nil,否则把operation放入下载队列当中
        BOOL existDownload = NO;
        
        for (HttpRequest *tempOP in self.downloadArray)
        {
            if ([tempOP.url isEqualToString:op.url])
            {
                existDownload = YES;
                break;
            }
        }
        
        if (existDownload)
        {
            // [[self delegate] downloadManagerDownloadExist:self withURL:paramURL];
            // 下载任务已经存在
        }
        else if (op == nil)
        {
            // [[self delegate] downloadManagerDownloadDone:self withURL:paramURL];
            // 下载文件已经存在
        }
        else
        {
            
        }
        
        return op;
    }
    
    return nil;
}


- (void)cancelDownloadWithString:(NSString *)string
{
    Downloader *op = [self getADownloadWithString:string];
    
    if (op)
    {
        [op cancel];
        [self.downloadArray removeObject:op];
    }
}

- (void)cancelAllDownloads
{
    for (HttpRequest *tempOP in self.downloadArray)
    {
        [tempOP cancel];
    }
    
    [self.downloadArray removeAllObjects];
}

- (void)emptyTempFile
{
    NSString *tempDoucment = NSTemporaryDirectory();
    NSString *tempFilePath = [tempDoucment stringByAppendingPathComponent:@"tempdownload"];
    [[NSFileManager defaultManager] removeItemAtPath:tempFilePath error:nil];
}

- (NSArray *)allDownloads
{
    return self.downloadArray;
}

- (Downloader *)getADownloadWithString:(NSString *)string
{
    Downloader *op = nil;
    
    for (Downloader *tempOP in self.downloadArray)
    {
        if ([tempOP.url isEqualToString:string])
        {
            op = tempOP;
            break;
        }
    }
    
    return op;
}

- (id)submit:(Downloader *)op
{
    NSString *str = op.toFile;
    
    if (str)
    {
        // 下载请求
        [self enqueueOperation:op];
        [self.downloadArray addObject:op];
    }
    
    return self;
}
#pragma mark -
#pragma mark KVO for network Queue

@end
