//
//  BLTDFUBaseInfo.m
//  ZKKBLT_OTA
//
//  Created by zorro on 15/2/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTDFUBaseInfo.h"

@implementation BLTDFUBaseInfo

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _zipVersion = 100;
    }
    
    return self;
}

DEF_SINGLETON(BLTDFUBaseInfo)

+ (NSData *)getUpdateFirmWareData
{
    NSString *string = [[DownLoadEntity_UpdateZip lastPathComponent] stringByDeletingPathExtension];
    if (string)
    {
        NSArray *array = [self getLibCacheFirmUpdateZip:string];
        if (array && [[array lastObject] isKindOfClass:[NSString class]])
        {
            NSURL *url = [[NSURL alloc] initFileURLWithPath:[array lastObject]];
            NSData *data = [NSData dataWithContentsOfURL:url];

            return data;
        }
        else
        {
            return nil;
        }
    }
    
    return nil;
}

+ (NSArray *)getLibCacheFirmUpdateZip:(NSString *)folderName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[XYSandbox libCachePath] stringByAppendingPathComponent:LS_FileCache_UpgradePatch], folderName];
    NSArray *files = [NSMutableArray arrayWithArray:[fm contentsOfDirectoryAtPath:path error:nil]];
    NSMutableArray *zips = [[NSMutableArray alloc] init];
    
    for (NSString *file in files)
    {
        if ([[[file pathExtension] lowercaseString] isEqualToString:@"bin"])
        {
            [zips addObject:[path stringByAppendingPathComponent:file]];
            [BLTDFUBaseInfo sharedInstance].zipVersion = [[[[file stringByDeletingPathExtension] componentsSeparatedByString:@"_"] lastObject] integerValue];
        }
    }
    
    return zips;
}

@end
