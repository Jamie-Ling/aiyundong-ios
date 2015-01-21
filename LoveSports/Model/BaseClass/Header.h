//
//  Header.h
//  VPhone
//
//  Created by zorro on 14-10-24.
//  Copyright (c) 2014年 zorro. All rights reserved.
//

#ifndef VPhone_Header_h
#define VPhone_Header_h


#endif

//
//  CommonDefine.h
//
//  Created by Heaven on 12-11-23.
//  Copyright (c) 2012年 Heaven. All rights reserved.
//

#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

/**************************************************************/
// 单例模式
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;
//+ (void) purgeSharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

/**************************************************************/
// 执行一次
#undef	XY_ONCE_BEGIN
#define XY_ONCE_BEGIN( __name ) \
static dispatch_once_t once_##__name; \
dispatch_once( &once_##__name , ^{

#undef	XY_ONCE_END
#define XY_ONCE_END		});


/**************************************************************/
// GCD 多线程
#define Common_MainFun(aFun) dispatch_async( dispatch_get_main_queue(), ^(void){aFun;} );
#define Common_MainBlock(block) dispatch_async( dispatch_get_main_queue(), block );

#define Common_BackGroundBlock(block) dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block );
#define Common_BackGroundFun(aFun) dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){aFun;} );

/**************************************************************/
// block
#pragma mark -todo
//typedef void (^BasicBlock)(void);

/**************************************************************/
// 宏定义字符串 转NSString, NSStringify( __name )
#define NSStringifyWithoutExpandingMacros(x) @#x
#define NSStringify(x) NSStringifyWithoutExpandingMacros(x)

/**************************************************************/
// delegate 委托
// arm64下失效,具体看https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaTouch64BitGuide/ConvertingYourAppto64-Bit/ConvertingYourAppto64-Bit.html
/*
 #define DelegateSelf( __fun ) \
 if (_delegate && [_delegate respondsToSelector:@selector( __fun )]) { \
 [_delegate __x self];}
 */
#define DelegateSelf( __fun ) Delegate( __fun, self)

/*
 #define Delegate( __x ) \
 if (_delegate && [_delegate respondsToSelector:@selector(__x)]) { \
 [_delegate __x];}
 */
#pragma mark - to  delegate被注册KVO时,isa会变, 判断delegate被释放?
#define Delegate( __fun, ...) \
if (_delegate && [_delegate respondsToSelector:@selector( __fun )]) \
{ \
objc_msgSend(_delegate, @selector( __fun ), ## __VA_ARGS__); \
}

/**************************************************************/
// NSUserDefaults
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

/**************************************************************/
// Use dummy class for category in static library.
#ifndef DUMMY_CLASS
#define DUMMY_CLASS(UNIQUE_NAME) \
@interface DUMMY_CLASS_##UNIQUE_NAME : NSObject @end \
@implementation DUMMY_CLASS_##UNIQUE_NAME @end
#endif

//使用示例:
//UIColor+YYAdd.m
/*
 #import "UIColor+YYAdd.h"
 DUMMY_CLASS(UIColor+YYAdd)
 
 @implementation UIColor(YYAdd)
 ...
 @end
 */

/**************************************************************/
// block 安全self
// mrc
//#define DEF_WEAKSELF     __block typeof(id) weakSelf = self;
//#define DEF_WEAKSELF_( __CLASSNAME__ )     __block typeof( __CLASSNAME__ *) weakSelf = self;
// arc
#define DEF_WEAKSELF __weak __typeof(self) weakSelf = self;
#define DEF_WEAKSELF_( __CLASSNAME__ ) __weak typeof( __CLASSNAME__ *) weakSelf = self;
/**************************************************************/

/**************************************************************/
// property
#undef	AS_STATIC_PROPERTY
#define AS_STATIC_PROPERTY( __name ) \
- (NSString *)__name; \
+ (NSString *)__name;

#undef	DEF_STATIC_PROPERTY
#define DEF_STATIC_PROPERTY( __name ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [NSString stringWithFormat:@"%s", #__name]; \
} \
return __local; \
}

#undef	DEF_STATIC_PROPERTY2
#define DEF_STATIC_PROPERTY2( __name, __prefix ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [NSString stringWithFormat:@"%@.%s", __prefix, #__name]; \
} \
return __local; \
}


#undef	DEF_STATIC_PROPERTY3
#define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \
} \
return __local; \
}

#undef	DEF_STATIC_PROPERTY4
#define DEF_STATIC_PROPERTY4( __name, __value, __prefix, __prefix2 ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
static NSString * __local = nil; \
if ( nil == __local ) \
{ \
__local = [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__value]; \
} \
return __local; \
}

#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( __name ) \
- (NSInteger)__name; \
+ (NSInteger)__name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( __name, __value ) \
- (NSInteger)__name \
{ \
return (NSInteger)[[self class] __name]; \
} \
+ (NSInteger)__name \
{ \
return __value; \
}


#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT

/**************************************************************/


#pragma mark -end
/**************************************************************/

/*
 #define NavigationBar_HEIGHT 44
 
 #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
 #define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
 #define SAFE_RELEASE(x) [x release];x=nil
 #define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
 #define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
 #define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
 
 #define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
 
 
 //use dlog to print while in debug model
 #ifdef DEBUG
 #   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
 #else
 #   define DLog(...)
 #endif
 
 
 #define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
 #define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
 #define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 
 
 #if TARGET_OS_IPHONE
 //iPhone Device
 #endif
 
 #if TARGET_IPHONE_SIMULATOR
 //iPhone Simulator
 #endif
 
 
 //ARC
 #if __has_feature(objc_arc)
 //compiling with ARC
 #else
 // compiling without ARC
 #endif
 
 
 #pragma mark - common functions
 #define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
 
 
 #pragma mark - degrees/radian functions
 #define degreesToRadian(x) (M_PI * (x) / 180.0)
 #define radianToDegrees(radian) (radian*180.0)/(M_PI)
 
 #pragma mark - color functions
 #define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
 #define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
 #define ITTDEBUG
 #define ITTLOGLEVEL_INFO     10
 #define ITTLOGLEVEL_WARNING  3
 #define ITTLOGLEVEL_ERROR    1
 
 #ifndef ITTMAXLOGLEVEL
 
 #ifdef DEBUG
 #define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
 #else
 #define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
 #endif
 
 #endif
 
 // The general purpose logger. This ignores logging levels.
 #ifdef ITTDEBUG
 #define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
 #else
 #define ITTDPRINT(xx, ...)  ((void)0)
 #endif
 
 // Prints the current method's name.
 #define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)
 
 // Log-level based logging macros.
 #if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
 #define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
 #else
 #define ITTDERROR(xx, ...)  ((void)0)
 #endif
 
 #if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
 #define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
 #else
 #define ITTDWARNING(xx, ...)  ((void)0)
 #endif
 
 #if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
 #define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
 #else
 #define ITTDINFO(xx, ...)  ((void)0)
 #endif
 
 #ifdef ITTDEBUG
 #define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
 ITTDPRINT(xx, ##__VA_ARGS__); \
 } \
 } ((void)0)
 #else
 #define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
 #endif
 
 #define ITTAssert(condition, ...)                                       \
 do {                                                                      \
 if (!(condition)) {                                                     \
 [[NSAssertionHandler currentHandler]                                  \
 handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
 file:[NSString stringWithUTF8String:__FILE__]  \
 lineNumber:__LINE__                                  \
 description:__VA_ARGS__];                             \
 }                                                                       \
 } while(0)
 
 #define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
 #define   WIDTH   [[UIScreen mainScreen] bounds].size.width
 #define  HEIGHT  [[UIScreen mainScreen] bounds].size.height
 
 #define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
 #define MyLocal(x, ...) NSLocalizedString(x, nil)
 
 
 #define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
 
 // rgb颜色转换（16进制->10进制）
 #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
 */
