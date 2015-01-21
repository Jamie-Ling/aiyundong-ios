//
//  GlobalTool.h
//  MissionSky-iOS

//  通用宏 & 枚举

#ifndef Global_h
#define Global_h

#pragma mark ---------------- 屏幕适配 ------------
#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window] //获得window
#define kUnderStatusBarStartY (kIOSVersions>=7.0 ? 20 : 0)                 //7.0以上stautsbar不占位置，内容视图的起始位置要往下20

#define kIPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kIOS7OffHeight (kIOSVersions>=7.0 ? 64 : 0)     //设置

#define kApplicationSize      [[UIScreen mainScreen] applicationFrame].size       //(e.g. 320,460)
#define kApplicationWidth     [[UIScreen mainScreen] applicationFrame].size.width //(e.g. 320)
#define kApplicationHeight    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)

#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
#define kTableRowTitleSize       14
#define maxPopLength             215

#define kButtonDefaultWidth (kIPhone4s ? 278 : 288)   //默认输入框宽
#define kSendSMSButtonWidth  90  //验证码按钮长度
#define kButtonDefaultHeight 42  //默认输入框高
#define kCellDefaultHeight = 44       //默认Cell高度

#pragma mark ---------------- 第三方函数 ------------
//比较字符串是否相等（忽略大小写），相等的话返回YES，否则返回NO。
#define kCompareStringCaseInsenstive(thing1, thing2) [thing1 compare:thing2 options:NSCaseInsensitiveSearch|NSNumericSearch] == NSOrderedSame
#define kCenterTheView(view) view.center = CGPointMake(kScreenWidth / 2.0, view.center.y)  //设置x方向屏幕居中


#pragma mark ---------------- 字体/颜色 ------------
#define kRGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define kRGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define kHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


// 字体  yuweif [UIFont fontWithName:@"yuweif" size:20]

//页面通用背景颜色
#define kBackgroundColor kRGB(8.0, 23.0, 67.0)
//导航栏背景颜色值
#define kNavigationBarColor kRGB(8.0, 23.0, 67.0)
//导航栏字体颜色值：#FFFFFF;
#define kNavigationBarTitleColor kHexRGB(0xFFFFFF)
//页面字体颜色
#define kPageTitleColor [UIColor blackColor]
//holdPlacer字体颜色
#define kHoldPlacerColor kRGB(166.0, 166.0, 166.0)

#define kNavigationBarTitleFontSize       20   //导航条标题字体大小

#define kStatementFontSize    [UIFont systemFontOfSize:12]            //陈述字体大小
#define kNavigationItemFontSize    [UIFont systemFontOfSize:15]       //NavigationItem字体大小
#define kTextFontSize         [UIFont systemFontOfSize:16]            //正文字体大小
#define kButtonFontSize       [UIFont systemFontOfSize:19]         //按钮字体大小
#define kTitleFontSize        [UIFont systemFontOfSize:20]            //标题字体
#define kTextFeildFontSize     [UIFont systemFontOfSize:12]             //输入框字体大小
#define kBackGroundImage      [UIImage imageNamed:@"shurukuang.png"]  //输入框背景图片


#pragma mark ---------------- 请求相关------------
#define kNotifyOfOutTimer       @"requestoutoftime"                     //请求超时



#pragma mark ---------------- 通知 & Key------------
/*
 登录
 */
#define kNotifyLoginSuccess                     @"kNotifyLoginSuccess"   //登录成功
#define kNotifyLoginFailure                     @"kNotifyLoginFailure";  //登录失败

/*
 用户信息
 */
#define kLastLoginUserName             @"LoginSuccess_userName"   //前一次登录用户名
#define kLastLoginUserInfo                      @"kLastLoginUserInfo"      //上次登录用户的信息 用于持续登录

/*
 缓存信息
 */
#define kLastHomePageInfo             @"LastHomePageInfo"   //前一次首页信息


#pragma mark ---------------- 枚举、类型------------
/*
 接收、发送、更新数据
 */
typedef enum{
    kAPI_GET,       //get data from sever
    kAPI_POST,      //post data to sever
    kAPI_PUT,       //update the data to sever
    kAPI_DELETE     //delete
}kAPI_PROTO;

/*
 API接口
 */
#define kCheckVersion  @"CheckVersion"            //1.1.1  版本检测



#pragma mark ---------------- 描述文字、默认业务字符------------
#define kCustomerServicePhoneNumber   @"0591-8888888"  //客服电话号码

#define kUserNamePlaceHoldText @"请输入您的手机号或Email"              //用户名holdplace文字

#define kMultiMediaDownLoadOverPath  @"Library/WuxiaMusic/Over"  //最终完成后的存储目录


#endif
