//
//  NSString+Extension.m
//  CBExtension
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

// 注明文件不需要备份
- (BOOL)addSkipBackupAttributeToItem
{
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:self];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}


#pragma mark - Regular expression
- (NSMutableArray *)itemsForPattern:(NSString *)pattern
{
    return [self itemsForPattern:pattern captureGroupIndex:0];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
        options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Error for create regular expression:\nString: %@\nPattern %@\nError: %@\n",self, pattern, error);
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange groupRange =  [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            [results addObject:match];
        }];
        return results;
    }
    
    return nil;
}

- (NSString *)itemForPatter:(NSString *)pattern
{
    return [self itemForPattern:pattern captureGroupIndex:0];
}

- (NSString *)itemForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
        options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Error for create regular expression:\nString: %@\nPattern %@\nError: %@\n",self, pattern, error);
    }
    else
    {
        NSRange searchRange = NSMakeRange(0, [self length]);
        NSTextCheckingResult *result = [regx firstMatchInString:self options:0 range:searchRange];
        NSRange groupRange = [result rangeAtIndex:index];
        NSString *match = [self substringWithRange:groupRange];
        return match;
    }
    
    return nil;
}

#pragma mark - Time Interval
- (NSTimeInterval)timeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [[formatter dateFromString:timeString] timeIntervalSince1970];
}

- (NSTimeInterval)localTimeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSTimeInterval timeInterval = [self timeIntervalFromString:timeString withDateFormat:format];
    NSUInteger secondsOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
    return (timeInterval + secondsOffset);
}

#pragma mark - Contains
- (BOOL)contains:(NSString *)piece
{
    return ( [self rangeOfString:piece].location != NSNotFound );
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#pragma mark - check
//add by jamie 20140121
/**
 *  判断字符串是否为Nil或者空
 *
 *  @param str 需要校验的字符串
 *
 *  @return  YES:为nil或者空，NO:有内容
 */
+ (BOOL )isNilOrEmpty: (NSString *) str;
{
    if (str && ![str isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

/**
 *  通过key设置value或者取value
 *
 *  @param key
 *
 *  @return
 */
- (id)getObjectValue
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    return [UD objectForKey:self];
}

- (NSInteger)getIntValue
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    return [UD integerForKey:self];
}

- (BOOL)getBOOLValue
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    return [UD boolForKey:self];
}

- (void)setObjectValue:(id)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    [UD setObject:value forKey:self];
    [UD synchronize];
}

- (void)setIntValue:(NSInteger)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    [UD setInteger:value forKey:self];
    [UD synchronize];
}

- (void)setBOOLValue:(BOOL)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    
    [UD setBool:value forKey:self];
    [UD synchronize];
}

- (BOOL)isContainQuotationMark
{
    NSRange range1 = [self rangeOfString:@"'"];
    NSRange range2 = [self rangeOfString:@"\""];
    if (range1.location != NSNotFound || range2.location != NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

@end
