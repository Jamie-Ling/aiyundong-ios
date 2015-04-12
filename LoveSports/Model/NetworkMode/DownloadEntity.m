//
//  DownloadEntity.m
//  MultiMedia
//
//  Created by zorro on 15-1-5.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DownloadEntity.h"
#import "ZipArchive.h"

@implementation DownloadEntity

DEF_SINGLETON(DownloadEntity)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadEngine = [DownloadHelper defaultSettings];
        
        self.downloadEngine.freezable = NO;
        self.downloadEngine.forceReload = NO;
        
        self.pathArray = @[[[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_Others],
                           [[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_UpgradePatch]];
    }
    return self;
}

- (void)downloadFileWithWebsite:(NSString *)website withRequestType:(DownloadEntityRequest)requestType
{
    if (website && website.length > 6)
    {
        NSString *fileName = [[website componentsSeparatedByString:@"/"] lastObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", self.pathArray[requestType], fileName];
        
        [self.downloadEngine cancelDownloadWithString:website];
        Downloader *down = [self.downloadEngine downLoad:website to:filePath params:nil breakpointResume:NO];
        NSLog(@"..%@", down);
        [down succeed:^(MKNetworkOperation *op) {
            [self unzipWithZipPath:filePath withRequest:requestType];
            
            if (requestType == DownloadEntityRequestUpgradePatch )
            {
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                [ud setFloat:[[FileModelEntity sharedInstance].wareInfo.wareVeriosn floatValue] forKey:MM_CurrentUpgradePatchVersion];
//                [ud synchronize];
            }
            
        } failed:^(MKNetworkOperation *op, NSError *err) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatDownloadFileFromCurrentWebsite:) object:@[website, [NSNumber numberWithInteger:requestType]]];
            [self performSelector:@selector(repeatDownloadFileFromCurrentWebsite:) withObject:@[website, [NSNumber numberWithInteger:requestType]] afterDelay:60];
        }];
        
        [self.downloadEngine submit:down];
    }
}

- (void)repeatDownloadFileFromCurrentWebsite:(NSArray *)array
{
    [self downloadFileWithWebsite:array[0] withRequestType:(DownloadEntityRequest)[array[1] integerValue]];
}

- (void)unzipWithZipPath:(NSString *)zipPath withRequest:(DownloadEntityRequest)requestType
{
    ZipArchive *zip = [[ZipArchive alloc] init];
    
    if ([zip UnzipOpenFile:zipPath])
    {
        BOOL result = [zip UnzipFileTo:_pathArray[requestType] overWrite:YES];
        if (result)
        {
            if (requestType == DownloadEntityRequestOthers)
            {
                self.coverAnimationMark ++;
            }
            else
            {
                self.upgradePatchMark ++;
            }
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:zipPath error:nil];
        }
        else
        {
            
        }
        
        [zip UnzipCloseFile];
        
        [BLTDFUBaseInfo getUpdateFirmWareData];
    }
}

@end
